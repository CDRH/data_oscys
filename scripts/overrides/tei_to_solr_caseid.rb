class TeiToSolrCaseid < TeiToSolr

  def initialize(options, file_location, output_location)
    @options = options
    @file_location = file_location
    # this returns multiple documents for the single file in question
    # line 674 of tei_to_solr.xsl has tei_person template
    @xml = CommonXml.create_xml_object(file_location)
  end

  # THINGS THAT CAN PROBABLY BE REUSED BY DOCUMENTS
  # TODO evaluate and move when working on documents
  def doc_date(xml)
    date_node = nil
    if xml.at_xpath("//keywords[@n='subcategory']/term[text()='Court Report']")
      date_node = xml.at_xpath("//keywords[@n='term']/term/date")
    else
      date_node = xml.at_xpath("/TEI/teiHeader/fileDesc/sourceDesc/bibl/date")
    end
    { "date" => date_node["when"], "dateDisplay" => date_node.text } if date_node
  end

  def documents(xml)
    # collect people at the top so that they can be deduplicated
    # after all the documents have reported back
    people_role = {
      "person" => [],
      "plaintiff" => [],
      "defendant" => [],
      "attorneyP" => [],
      "attorneyD" => []
    }

    # DOCUMENTS
    # For each case document or related document associated with a case,
    # grab all the information about people who are part of the document
    @xml.xpath("//div2[@type='documents']/ab").each do |doc_ref|
      doc_id = doc_ref.text
      doc_file = File.join(@options["collection_dir"], "source/tei", "#{doc_id}.xml")
      doc = CommonXml.create_xml_object(doc_file)

      # neither type of date is actually assigned directly to the caseid
      # but it is used to populate data fields for specific outcomes, etc
      date = doc_date(doc)

      # TODO verify this is working with a different case
      get_field(doc, "//TEI/teiHeader/profileDesc/textClass/keywords[@n='outcome']/term").each do |outcome|
        xml.field(json({ "label" => outcome, "id" => doc_id }.merge(date)), "name" => "outcomeData_ss")
        xml.field(outcome, "name" => "outcome_ss")
      end

      # sometimes a document belongs to two cases at once
      # when this is true, the listPerson elements will have a caseid attached to them
      # (see oscys.case.0017.003 for an example)
      # but if there is no type associated then it's safe to pull all the people
      # in the listPerson path

      # check where listPerson type is caseid and where listPerson has no case attribute
      doc.xpath("//listPerson[@type='#{@id}']/person", "//listPerson[not(@*)]/person").each do |pnode|
        if pnode.text
          person = {
            "label" => CommonXml.normalize_space(pnode.text),
            "id" => pnode["id"],
            "role" => CommonXml.normalize_space(pnode["role"])
          }
          if person["id"] && person["label"] && person["role"]
            # "person" contains all individuals mentioned cases regardless of roles
            people_role["person"] << person
            if person["role"]
              case person["role"]
              when "petitioner"
                people_role["plaintiff"] << person
              when "attorney_plaintiff", "attorney_petitioner"
                people_role["attorneyP"] << person
              when "attorney_defendant"
                people_role["attorneyD"] << person
              else
                # defendant and plaintiff go into this category
                people_role[person["role"]] << person
              end
            end
          end
        end
      end
      # now add all the keywords for people in as well
      # they are not attorneys, defendants, etc, but might be
      # jury members, judges, clerks, etc and only need to be in the "person" fields
      doc.xpath("//keywords[@n='people']//term").each do |keyword|
        if keyword.text && keyword["id"]
          people_role["person"] << { "label" => keyword.text, "id" => keyword["id"] }
        end
      end


    end

    # add attorneys together
    people_role["attorney"] = people_role["attorneyP"] + people_role["attorneyD"]
    # iterate through the people related to a case and deduplicate based on person id
    # TODO is there a more elegant way of doing this?
    people_role.each do |role, people|
      uniq_ppl = people.uniq { |person| person["id"] }
      # make the following fields for each role:  _ss, ID_ss, Data_ss
      uniq_ppl.each do |uniq_pers|
        xml.field(uniq_pers["id"], "name" => "#{role}ID_ss")
        xml.field(uniq_pers["label"], "name" => "#{role}_ss")
        obj = { "label" => uniq_pers["label"], "id" => uniq_pers["id"] }
        xml.field(json(obj), "name" => "#{role}Data_ss")
      end
    end
  end

  def get_title
    title = @xml.xpath(
      "/TEI/teiHeader/fileDesc/titleStmt/title[@type='main']",
      "/TEI/teiHeader/fileDesc/titleStmt/title"
    )
    title.first.text if title && title.first
  end

  def related_cases(xml)
    # TODO put this inside the other related cases loop once it's determined that
    # there have been no changes to the case files
    @xml.xpath("//ref[@type='related.case']/text()").each do |f|
      caseid = f.text
      xml.field(caseid, "name" => "relatedCaseID_ss", "update" => "add")
    end
    # you have to open all of the caseid files in question to get titles
    # note: this assumes caseid files are always TEI XML
    @xml.xpath("//ref[@type='related.case']/text()").each do |f|
      caseid = f.text
      if caseid
        case_file = File.join(@options["collection_dir"], "source/tei", "#{caseid}.xml")
        case_xml = CommonXml.create_xml_object(case_file)
        title = get_field(case_xml, "//title").first
        data = { "label" => title, "id" => caseid }
        xml.field(JSON.generate(data), "name" => "relatedCaseData_ss", "update" => "add")
        xml.field(caseid, "name" => "relatedCaseID_ss", "update" => "add")
      end
    end
  end

  def xml
    builder = Nokogiri::XML::Builder.new do |xml|
      @id = @xml.at_xpath("//idno").text
      xml.add {
        # note: ".doc" is an existing method so have to use doc_ to distinguish
        xml.doc_ {
          xml.field(@id, "name" => "id")
          xml.field("", "name" => "slug", "update" => "add")
          xml.field(@options["collection"], "name" => "project", "update" => "add")
          # TODO replace with more accurate URL
          xml.field("http://earlywashingtondc.org/files/#{@id}.html", "name" => "uri", "update" => "add")
          # xml.field(File.join(@options["variables_solr"]["site_location"], "people", id), "name" => "uri", "update" => "add")
          xml.field(File.join(@options["data_base"], "data", @options["collection"], "output", @options["environment"], "html", "#{@id}.html"), "name" => "uriHTML", "update" => "add")
          filename = File.basename(@file_location)
          xml.field(File.join(@options["data_base"], "data", @options["collection"], "source/tei", filename), "name" => "uriXML", "update" => "add")

          xml.field("tei", "name" => "dataType", "update" => "add")

          # TODO consider pulling these common fields out into a different file
          title = get_title
          xml.field(title, "name" => "title", "update" => "add")
          xml.field(CommonXml.normalize_name(title), "name" => "titleSort", "update" => "add")
          # grab the first letter of the title
          letter = title[0] ? title[0].downcase : ""
          xml.field(letter, "name" => "titleLetter_s", "update" => "add")

          xml.field("", "name" => "contributor")
          xml.field("", "name" => "date")
          xml.field("", "name" => "dateDisplay")
          # Look into whether the following are needed
          # creator / s
          # publisher
          # contributor
          # date
          # dateDisplay
          # format
          # source
          # rightsholder

          pis = @xml.xpath("/TEI/teiHeader/fileDesc/titleStmt/principal").map { |f| f.text }
          if pis.length > 0
            xml.field(pis.join("; "), "name" => "principalInvestigator", "update" => "add")
          end
          pis.each do |f|
            xml.field(f, "name" => "principalInvestigators", "update" => "add")
          end

          category = get_field(@xml, "/TEI/teiHeader/profileDesc/textClass/keywords[@n='category'][1]/term")
          xml.field(category.first, "name" => "category", "update" => "add")
          # subcat = get_field(@xml, "/TEI/teiHeader/profileDesc/textClass/keywords[@n='subcategory'][1]/term")
          # xml.field(subcat.first, "name" => "subCategory")

          # TODO look into following fields
          # topic
          # keywords
          # people

          # TODO see if we need to keep this
          xml.field("", "name" => "sourceTitle_s")
          xml.field("caseid", "name" => "recordType_s")

          related_cases(xml)

          get_field(@xml, "//keywords[@n='claims']/term").each do |f|
            xml.field(f, "name" => "claims_ss")
          end

          text = []
          text_eles = @xml.xpath("//text")
          text_eles.each do |t|
            t.traverse do |node|
              if node.class == Nokogiri::XML::Text && !node.text[/oscys\.[a-z]+\.\d{4}\.\d{3}/]
                text << node.text
              end
            end
          end
          xml.field(CommonXml.normalize_space(text.join(" ")), "name" => "text")

          # TODO this is a change from the original xpath which was looking for div1 type case
          narrative = get_field(@xml, "//div2[@type='narrative']")
          xml.field("true", "name" => "caseidHasNarrative_s") if narrative.length > 0

          # go through all of the associated documents and pull out relevant information
          documents(xml)
        }
      }
    end
    # debugging courtesy line
    puts builder.to_xml

    # note XSLT had 3 space indents so imitating in order to make comparisons more easily
    builder.to_xml(
      encoding: "UTF-8",
      indent: 3,
    )
  end

end
