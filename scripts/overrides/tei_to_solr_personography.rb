class TeiToSolrPersonography < TeiToSolr

  def initialize(options, file_location, output_location)
    @options = options
    @file_location = file_location
    # this returns multiple documents for the single file in question
    # line 674 of tei_to_solr.xsl has tei_person template
    @people_xml = CommonXml.create_xml_object(file_location)
    @viaf = @people_xml.at_xpath("//sourceDesc[1]//bibl[1]/ref/text()")
    @principals = @people_xml.xpath("//principal").map { |pi| CommonXml.normalize_space(pi.text) }
  end

  def get_pers_name(person)
    first = person.at_xpath("persName[@type='display']")
    first ? first.text : ""
  end

  def xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.add {
        @people_xml.xpath("//person").each do |person|
          id = person["id"]
          # note: ".doc" is an existing method so have to use doc_ to distinguish
          xml.doc_ {
            xml.field(@options["collection"], "name" => "project")
            # Note altered from original XSLT
            filename = File.basename(@file_location)
            xml.field(File.join(@options["variables_solr"]["site_location"], "people", id), "name" => "uri")
            xml.field(File.join(@options["data_base"], "data", @options["collection"], "output", @options["environment"], "html", "#{id}.html"), "name" => "uriHTML")
            xml.field(File.join(@options["data_base"], "data", @options["collection"], "source/tei", filename), "name" => "uriXML")

            xml.field("tei", "name" => "dataType")
            title = get_pers_name(person)
            xml.field(title, "name" => "title")
            xml.field(CommonXml.normalize_name(title), "name" => "titleSort")
            # grab the first letter of the title
            letter = title[0] ? title[0].downcase : ""
            xml.field(letter, "name" => "titleLetter_s")

            # TODO check if contributor / date fields needed for personography
            xml.field("", "name" => "contributor")
            xml.field("", "name" => "date")
            xml.field("", "name" => "dateDisplay")
            
            if @principals
              xml.field(@principals.join("; "), "name" => "principalInvestigator")
              @principals.each { |p| xml.field(p, "name" => "principalInvestigators") }
            end

            xml.field("People", "name" => "category")
            xml.field("Person", "name" => "subCategory")
            xml.field("", "name" => "sourceTitle_s")
            xml.field("person", "name" => "recordType_s")

            xml.field(id, "name" => "id")
            xml.field(title, "name" => "people_ss")
            xml.field(id, "name" => "peopleID_ss")

            # TODO this is in the XSLT but doesn't actually appear to be
            # in the output file
            get_field(person, "idno[@type='viaf']").each do |v|
              xml.field(v, "name" => "personIdnoVIAF_ss")
            end

            # Note seems odd to just pull first name but that's how the XSLT worked
            get_data_field(person, "persName[1]").each do |p|
              xml.field(json(p, id), "name" => "peopleData_ss")
              xml.field(p["val"], "name" => "personName_ss")
              xml.field(json(p), "name" => "personNameData_ss")
            end

            get_field(person, "persName/addName").each do |n|
              xml.field(n, "name" => "personAltName_ss")
            end

            get_field(person, "persName/surname[@type='birth']").each do |s|
              xml.field(s, "name" => "personBirthName_ss")
            end

            get_data_field(person, "sex").each do |s|
              xml.field(s["val"], "name" => "personSex_ss")
              xml.field(json(s), "name" => "personSexData_ss")
            end

            get_data_field(person, "affiliation").each do |a|
              xml.field(a["val"], "name" => "personAffiliation_ss")
              xml.field(json(a), "name" => "personAffiliationData_ss")
            end

            get_data_field(person, "age").each do |a|
              xml.field(a["val"], "name" => "personAge_ss")
              xml.field(json(a), "name" => "personAgeData_ss")
            end

            get_data_field(person, "bibl").each do |b|
              xml.field(b["val"], "name" => "personBibl_ss")
              xml.field(json(b), "name" => "personBiblData_ss")
            end

            get_data_field(person, "birth").each do |b|
              xml.field(b["val"], "name" => "personBirth_ss")
              xml.field(json(b), "name" => "personBirthData_ss")
            end

            get_data_field(person, "death").each do |d|
              xml.field(d["val"], "name" => "personDeath_ss")
              xml.field(json(d), "name" => "personDeathData_ss")
            end

            get_data_field(person, "event").each do |e|
              xml.field(e["val"], "name" => "personEvent_ss")
              xml.field(json(e), "name" => "personEventData_ss")
            end

            get_data_field(person, "nationality").each do |n|
              xml.field(n["val"], "name" => "personNationality_ss")
              xml.field(json(n), "name" => "personNationalityData_ss")
            end

            get_data_field(person, "note").each do |n|
              xml.field(n["val"], "name" => "personNote_ss")
              xml.field(json(n), "name" => "personNoteData_ss")
            end

            get_data_field(person, "occupation").each do |o|
              xml.field(o["val"], "name" => "personOccupation_ss")
              xml.field(json(o), "name" => "personOccupationData_ss")
            end

            get_data_field(person, "residence").each do |r|
              xml.field(r["val"], "name" => "personResidence_ss")
              xml.field(json(r), "name" => "personResidenceData_ss")
            end

            get_data_field(person, "socecStatus").each do |s|
              xml.field(s["val"], "name" => "personSocecStatus_ss")
              xml.field(json(s), "name" => "personSocecStatusData_ss")
            end

            get_data_field(person, "trait[@type='color']").each do |t|
              xml.field(t["val"], "name" => "personColor_ss")
              xml.field(json(t), "name" => "personColorData_ss")
            end

            text = []
            person.traverse do |node|
              text << node.text if node.class == Nokogiri::XML::Text
            end
            xml.field(CommonXml.normalize_space(text.join(" ")), "name" => "text")
          }
        end
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
