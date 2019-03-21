# manually require because datura doesn't have a base TeiToSolr class
require_relative "tei_to_solr.rb"

class TeiToSolrDocument < TeiToSolr

  def initialize(options, file_location, output_location)
    @options = options
    @file_location = file_location
    # this returns multiple documents for the single file in question
    # line 674 of tei_to_solr.xsl has tei_person template
    @xml = CommonXml.create_xml_object(file_location)
  end

  def get_source
    source = ""
    sourceDesc = @xml.at_xpath("/TEI/teiHeader/fileDesc/sourceDesc")
    if sourceDesc
      ms = sourceDesc.at_xpath("msDesc")
      if ms
        desc = []
        desc += get_field(ms, "msIdentifier/repository")
        desc += get_field(ms, "msIdentifier/collection")
        desc += get_field(ms, "msIdentifier/idno")
        source = desc.join(", ")
      else
        desc = []
        desc += get_field(sourceDesc, "bibl/author")
        desc += get_field(sourceDesc, "bibl/title")
        desc += get_field(sourceDesc, "bibl/biblScope")
        place = get_field(sourceDesc, "bibl/pubPlace")
        pub = get_field(sourceDesc, "bibl/publisher")
        date = get_field(sourceDesc, "bibl/date")

        source = desc.join(", ")
        source << ", #{place.first}:" if place.first
        source << " #{pub.first}" if pub.first
        source << " (#{date.first})" if date.first
      end
    end
    source
  end

  def xml
    builder = Nokogiri::XML::Builder.new do |x|
      @id = @xml.at_xpath("//idno[@type='project']").text
      x.add {
        # note: ".doc" is an existing method so have to use doc_ to distinguish
        x.doc_ {
          x.field(@id, "name" => "id")
          x.field(@options["collection"], "name" => "project")
          # Note altered from original XSLT
          filename = File.basename(@file_location)
          x.field(File.join(@options["variables_solr"]["site_location"], "doc", @id), "name" => "uri")
          x.field(File.join(@options["data_base"], "data", @options["collection"], "output", @options["environment"], "html", "#{@id}.html"), "name" => "uriHTML")
          x.field(File.join(@options["data_base"], "data", @options["collection"], "source/tei", filename), "name" => "uriXML")

          x.field("tei", "name" => "dataType")
          title = get_title
          # title, titleSort, titleLetter
          build_title_fields(x, title)

          # Note: no creators nor contributors nor recipients for oscys
          pub = get_field(@xml, "/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher").first
          x.field(pub, "name" => "publisher") if pub

          date = doc_date(@xml)
          x.field("#{date["date"]}T00:00:00Z", "name" => "date") if date && date["date"]
          x.field(date["dateDisplay"], "name" => "dateDisplay") if date && date["dateDisplay"]

          # note: this will need to change if there are ever non-manuscripts included
          manu_format = get_field(@xml, "/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='m']").first
          if manu_format
            x.field("manuscript", "name" => "format")
          end

          source = get_source
          x.field(source, "name" => "source") if source

          rights = get_field(@xml, "/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository").first
          x.field(rights, "name" => "rightsHolder") if rights
          build_pi_fields(x)

          category = get_field(@xml, "/TEI/teiHeader/profileDesc/textClass/keywords[@n='category'][1]/term").first
          x.field(category, "name" => "category") if category
          subcat = get_field(@xml, "/TEI/teiHeader/profileDesc/textClass/keywords[@n='subcategory'][1]/term").first
          x.field(subcat, "name" => "subCategory") if subcat

          # Note: no topics or keywords for oscys

          people = get_field(@xml, "/TEI/teiHeader/profileDesc/textClass/keywords[@n='people']/term")
          people += get_field(@xml, "//listPerson/person/persName")
          people.uniq.each do |person|
            x.field(person, "name" => "people")
          end

          get_field(@xml, "//textClass/keywords[@n='places']/term").each do |place|
            x.field(place, "name" => "places")
          end

          # Note: no works in oscys
          people_role = people_role_template

          # unlike caseid file, grab all document people regardless of case identified with
          @xml.xpath("//listPerson/person").each do |pnode|
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
          @xml.xpath("//keywords[@n='people']//term").each do |keyword|
            if keyword.text && keyword["id"]
              people_role["person"] << { "label" => keyword.text, "id" => keyword["id"] }
            end
          end

          # add attorneys together
          people_role["attorney"] = people_role["attorneyP"] + people_role["attorneyD"]
          # iterate through the people related to a case and deduplicate based on person id
          people_role.each do |role, people|
            build_person_fields(x, role, people)
          end

          src = get_field(@xml, "/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@type='main']").first
          x.field(src, "name" => "sourceTitle_s") if src

          x.field("document", "name" => "recordType_s")

          get_field(@xml, "/TEI/teiHeader/profileDesc/textClass/keywords[@n='term']/term/date/@when").each do |t|
            x.field(t, "name" => "term_ss")
          end

          @xml.xpath("//idno[@type='case']").each do |relCase|
            caseid = relCase.text
            x.field(caseid, "name" => "documentCaseID_ss")
            caseid_file = File.join(@options["collection_dir"], "source/tei", "#{caseid}.xml")
            caseid_xml = CommonXml.create_xml_object(caseid_file)
            case_title = get_title(caseid_xml)
            obj = { "label" => case_title, "id" => caseid }
            x.field(json(obj), "name" => "documentCaseData_ss")
          end

          @xml.xpath("//org").each do |org|
            jurisdiction = org.at_xpath("orgName").text
            if org.at_xpath("placeName")
              jurisdiction << " - #{org.at_xpath("placeName").text}"
            end
            x.field(jurisdiction, "name" => "jurisdiction_ss")
          end

          get_field(@xml, "//keywords[@n='claims']/term").each do |claim|
            x.field(claim, "nam" => "claims_ss")
          end

          text = []
          text_eles = @xml.xpath("//text")
          text_eles.each do |t|
            t.traverse do |node|
              if node.class == Nokogiri::XML::Text
                text << node.text
              end
            end
          end
          x.field(CommonXml.normalize_space(text.join(" ")), "name" => "text")
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
