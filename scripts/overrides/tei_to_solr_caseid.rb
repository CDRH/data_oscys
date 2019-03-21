# manually require because datura doesn't have a base TeiToSolr class
require_relative "tei_to_solr.rb"

class TeiToSolrCaseid < TeiToSolr

  def initialize(options, file_location, output_location)
    @options = options
    @file_location = file_location
    # this returns multiple documents for the single file in question
    # line 674 of tei_to_solr.xsl has tei_person template
    @xml = CommonXml.create_xml_object(file_location)
  end

  def documents(x)
    # collect certain fields at the top so that they can be deduplicated
    # after all the documents have reported back
    jurisdictions = []
    people_role = people_role_template
    dates = []

    # DOCUMENTS
    # For each case document or related document associated with a case,
    # grab all the information about people who are part of the document
    @xml.xpath("//div2[@type='documents']/ab").each do |doc_ref|
      doc_id = doc_ref.text
      doc_file = File.join(@options["collection_dir"], "source/tei", "#{doc_id}.xml")
      doc = CommonXml.create_xml_object(doc_file)

      # neither type of date is actually assigned directly to the caseid
      # but it is used to populate data fields for specific outcomes, etc
      date = doc_date(doc) || {}
      dates << date["date"]
      title = get_field(doc, "/TEI/teiHeader/fileDesc/titleStmt/title").first
      title = "#{title} (#{date["dateDisplay"]})" if date.key?("dateDisplay") && !date["dateDisplay"].empty?

      # if this is a Case Paper then it should be a case document, otherwise
      # consider it a related document
      data = { "label" => title, "id" => doc_id }.merge(date)
      if get_field(doc, "//keywords[@n='category']").include?("Case Papers")
        x.field(doc_id, "name" => "caseDocumentID_ss")
        x.field(json(data), "name" => "caseDocumentData_ss")
      else
        x.field(doc_id, "name" => "caseRelatedDocumentID_ss")
        x.field(json(data), "name" => "caseRelatedDocumentData_ss")
      end

      get_field(doc, "//TEI/teiHeader/profileDesc/textClass/keywords[@n='outcome']/term").each do |outcome|
        x.field(json({ "label" => outcome, "id" => doc_id }.merge(date)), "name" => "outcomeData_ss")
        x.field(outcome, "name" => "outcome_ss")
      end

      doc.xpath("//org").each do |org|
        jurisdiction = org.at_xpath("orgName").text
        if org.at_xpath("placeName")
          jurisdiction << " - #{org.at_xpath("placeName").text}"
        end
        jurisdictions << jurisdiction
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
            role_label = get_person_role(person)
            people_role[role_label] << person
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

    # AFTER INDIVIDUAL DOCUMENTS HAVE BEEN RUN

    # deduplicate jurisdiction and push
    jurisdictions.uniq.each { |j| x.field(j, "name" => "jurisdiction_ss") }

    # add attorneys together
    people_role["attorney"] = people_role["attorneyP"] + people_role["attorneyD"]
    # iterate through the people related to a case and deduplicate based on person id
    people_role.each do |role, people|
      build_person_fields(x, role, people)
    end

    # now figure out which document had the most recent date and use that as the
    # caseid date (and dateDisplay)
    dates = dates.map{|d| CommonXml.date_standardize(d)}.compact.sort
    if dates.length > 0
      x.field(dates.last, "name" => "date")
      x.field(CommonXml.date_display(dates.last), "name" => "dateDisplay")
    end
  end

  def related_cases(x)
    # you have to open all of the caseid files in question to get titles
    # note: this assumes caseid files are always TEI XML
    @xml.xpath("//ref[@type='related.case']/text()").each do |f|
      caseid = f.text
      if caseid
        case_file = File.join(@options["collection_dir"], "source/tei", "#{caseid}.xml")
        case_xml = CommonXml.create_xml_object(case_file)
        title = get_field(case_xml, "//title").first
        data = { "label" => title, "id" => caseid }
        x.field(JSON.generate(data), "name" => "relatedCaseData_ss")
        x.field(caseid, "name" => "relatedCaseID_ss")
      end
    end
  end

  def xml
    builder = Nokogiri::XML::Builder.new do |x|
      @id = @xml.at_xpath("//idno").text
      x.add {
        # note: ".doc" is an existing method so have to use doc_ to distinguish
        x.doc_ {
          x.field(@id, "name" => "id")
          x.field(@options["collection"], "name" => "project")
          x.field(File.join(@options["variables_solr"]["site_location"], "cases", @id), "name" => "uri")
          x.field(File.join(@options["data_base"], "data", @options["collection"], "output", @options["environment"], "html", "#{@id}.html"), "name" => "uriHTML")
          filename = File.basename(@file_location)
          x.field(File.join(@options["data_base"], "data", @options["collection"], "source/tei", filename), "name" => "uriXML")

          x.field("tei", "name" => "dataType")

          title = get_title
          build_title_fields(x, title)

          x.field("", "name" => "contributor")

          build_pi_fields(x)

          category = get_field(@xml, "/TEI/teiHeader/profileDesc/textClass/keywords[@n='category'][1]/term")
          x.field(category.first, "name" => "category")
          # caseid files do not have subcategory

          # caseid does not have a sourcetitle_s
          x.field("", "name" => "sourceTitle_s")
          x.field("caseid", "name" => "recordType_s")

          related_cases(x)

          get_field(@xml, "//keywords[@n='claims']/term").each do |f|
            x.field(f, "name" => "claims_ss")
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
          x.field(CommonXml.normalize_space(text.join(" ")), "name" => "text")

          # NOTE this is a change from the original xpath which was looking for div1 type case
          narrative = get_field(@xml, "//div2[@type='narrative']")
          x.field("true", "name" => "caseidHasNarrative_s") if narrative.length > 0

          # go through all of the associated documents and pull out relevant information
          documents(x)
        }
      }
    end
    # debugging courtesy line
    # puts builder.to_xml

    # note XSLT had 3 space indents so imitating in order to make comparisons more easily
    builder.to_xml(
      encoding: "UTF-8",
      indent: 3,
    )
  end

end
