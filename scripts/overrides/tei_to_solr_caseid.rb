class TeiToSolrCaseid < TeiToSolr

  def initialize(options, file_location, output_location)
    @options = options
    @file_location = file_location
    # this returns multiple documents for the single file in question
    # line 674 of tei_to_solr.xsl has tei_person template
    @xml = CommonXml.create_xml_object(file_location)
  end

  def get_title
    title = @xml.xpath(
      "/TEI/teiHeader/fileDesc/titleStmt/title[@type='main']",
      "/TEI/teiHeader/fileDesc/titleStmt/title"
    )
    title.first.text if title && title.first
  end

  def xml
    builder = Nokogiri::XML::Builder.new do |xml|
      id = @xml.at_xpath("//idno").text
      xml.add {
        # note: ".doc" is an existing method so have to use doc_ to distinguish
        xml.doc_ {
          xml.field(id, "name" => "id")
          xml.field("", "name" => "slug", "update" => "add")
          xml.field(@options["collection"], "name" => "project", "update" => "add")
          # TODO replace with more accurate URL
          xml.field("http://earlywashingtondc.org/files/#{id}.html", "name" => "uri", "update" => "add")
          # xml.field(File.join(@options["variables_solr"]["site_location"], "people", id), "name" => "uri", "update" => "add")
          xml.field(File.join(@options["data_base"], "data", @options["collection"], "output", @options["environment"], "html", "#{id}.html"), "name" => "uriHTML", "update" => "add")
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
              # xml.field(caseid, "name" => "relatedCaseID_ss", "update" => "add")
              case_file = File.join(@options["collection_dir"], "source/tei", "#{caseid}.xml")
              case_xml = CommonXml.create_xml_object(case_file)
              title = get_field(case_xml, "//title").first
              data = { "label" => title, "id" => caseid }
              xml.field(JSON.generate(data), "name" => "relatedCaseData_ss", "update" => "add")
            end
          end

          # TODO ?
          # term
          # related case id
          # related case data
          # case name
          # jurisdiction

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
