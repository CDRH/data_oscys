class TeiToSolrPersonography < TeiToSolr

  def initialize(options, file_location, output_location)
    @options = options
    @file_location = file_location
    # this returns multiple documents for the single file in question
    # line 674 of tei_to_solr.xsl has tei_person template
    @people_xml = CommonXml.create_xml_object(file_location)
    @viaf = @people_xml.at_xpath("//sourceDesc[1]//bibl[1]/ref/text()").text
    @principals = @people_xml.xpath("//principal").map { |pi| CommonXml.normalize_space(pi.text) }
  end

  def get_pers_name(person)
    first = person.at_xpath("persName[@type='display']")
    first ? first.text : ""
  end

  def xml
    builder = Nokogiri::XML::Builder.new do |x|
      x.add {
        @people_xml.xpath("//person").each do |person|
          id = person["id"]
          # note: ".doc" is an existing method so have to use doc_ to distinguish
          x.doc_ {
            x.field(@options["collection"], "name" => "project")
            # Note altered from original XSLT
            filename = File.basename(@file_location)
            x.field(File.join(@options["variables_solr"]["site_location"], "people", id), "name" => "uri")
            x.field(File.join(@options["data_base"], "data", @options["collection"], "output", @options["environment"], "html", "#{id}.html"), "name" => "uriHTML")
            x.field(File.join(@options["data_base"], "data", @options["collection"], "source/tei", filename), "name" => "uriXML")

            x.field("tei", "name" => "dataType")
            title = get_pers_name(person)
            x.field(title, "name" => "title")
            x.field(CommonXml.normalize_name(title), "name" => "titleSort")
            # grab the first letter of the title
            letter = title[0] ? title[0].downcase : ""
            x.field(letter, "name" => "titleLetter_s")

            # TODO check if contributor / date fields needed for personography
            x.field("", "name" => "contributor")
            x.field("", "name" => "date")
            x.field("", "name" => "dateDisplay")
            
            if @principals
              x.field(@principals.join("; "), "name" => "principalInvestigator")
              @principals.each { |p| x.field(p, "name" => "principalInvestigators") }
            end

            x.field("People", "name" => "category")
            x.field("Person", "name" => "subCategory")
            x.field("", "name" => "sourceTitle_s")
            x.field("person", "name" => "recordType_s")

            x.field(id, "name" => "id")
            x.field(title, "name" => "people_ss")
            x.field(id, "name" => "peopleID_ss")

            # TODO this is in the XSLT but doesn't actually appear to be
            # in the output file
            get_field(person, "idno[@type='viaf']").each do |v|
              x.field(v, "name" => "personIdnoVIAF_ss")
            end

            # Note seems odd to just pull first name but that's how the XSLT worked
            get_data_field(person, "persName[1]").each do |p|
              x.field(json(p, {"id" => id}), "name" => "peopleData_ss")
              x.field(p["label"], "name" => "personName_ss")
              x.field(json(p), "name" => "personNameData_ss")
            end

            get_field(person, "persName/addName").each do |n|
              x.field(n, "name" => "personAltName_ss")
            end

            get_field(person, "persName/surname[@type='birth']").each do |s|
              x.field(s, "name" => "personBirthName_ss")
            end

            get_data_field(person, "sex").each do |s|
              x.field(s["label"], "name" => "personSex_ss")
              x.field(json(s), "name" => "personSexData_ss")
            end

            get_data_field(person, "affiliation").each do |a|
              x.field(a["label"], "name" => "personAffiliation_ss")
              x.field(json(a), "name" => "personAffiliationData_ss")
            end

            get_data_field(person, "age").each do |a|
              x.field(a["label"], "name" => "personAge_ss")
              x.field(json(a), "name" => "personAgeData_ss")
            end

            get_data_field(person, "bibl").each do |b|
              x.field(b["label"], "name" => "personBibl_ss")
              x.field(json(b), "name" => "personBiblData_ss")
            end

            get_data_field(person, "birth").each do |b|
              x.field(b["label"], "name" => "personBirth_ss")
              x.field(json(b), "name" => "personBirthData_ss")
            end

            get_data_field(person, "death").each do |d|
              x.field(d["label"], "name" => "personDeath_ss")
              x.field(json(d), "name" => "personDeathData_ss")
            end

            get_data_field(person, "event").each do |e|
              x.field(e["label"], "name" => "personEvent_ss")
              x.field(json(e), "name" => "personEventData_ss")
            end

            get_data_field(person, "nationality").each do |n|
              x.field(n["label"], "name" => "personNationality_ss")
              x.field(json(n), "name" => "personNationalityData_ss")
            end

            get_data_field(person, "note").each do |n|
              x.field(n["label"], "name" => "personNote_ss")
              x.field(json(n), "name" => "personNoteData_ss")
            end

            get_data_field(person, "occupation").each do |o|
              x.field(o["label"], "name" => "personOccupation_ss")
              x.field(json(o), "name" => "personOccupationData_ss")
            end

            get_data_field(person, "residence").each do |r|
              x.field(r["label"], "name" => "personResidence_ss")
              x.field(json(r), "name" => "personResidenceData_ss")
            end

            get_data_field(person, "socecStatus").each do |s|
              x.field(s["label"], "name" => "personSocecStatus_ss")
              x.field(json(s), "name" => "personSocecStatusData_ss")
            end

            get_data_field(person, "trait[@type='color']").each do |t|
              x.field(t["label"], "name" => "personColor_ss")
              x.field(json(t), "name" => "personColorData_ss")
            end

            text = []
            person.traverse do |node|
              text << node.text if node.class == Nokogiri::XML::Text
            end
            x.field(CommonXml.normalize_space(text.join(" ")), "name" => "text")
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
