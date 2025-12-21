class Datura::DataManager
  # entire purpose of this override is to insert document ids into
  # caseid xml files BEFORE running the transformation scripts per file


  # oscys caseid files have some elements with attribute `xml:id`
  # and these are removed when writing the file if loaded with no namespace
  NS = "http://www.tei-c.org/ns/1.0"


  def get_doc_type(xml)
    categories = xml.xpath("//keywords[@n='category']")
                    .map { |node| Datura::Helpers.normalize_space(node.text) }
    categories.include?("Case Papers") ? "document" : "related.document"
  end

  # this method iterates through the documents and inserts references
  # to specific documents into relevant caseid files
  # when a document is not a case paper, then it should be considered
  # a case related document instead of a case document
  def pre_batch_processing
    if should_transform?("solr")
      puts "inserting documents into case files"
      case_loc = File.join(@options["collection_dir"], "source/tei")
      @files.each do |file|
        doc_id = file.filename(false)
        # skip if this is the personography or a case
        next if doc_id[/caseid|persons/]

        # search each document for references to cases
        doc_xml = CommonXml.create_xml_object(file.file_location)
        doc_type = get_doc_type(doc_xml)
        doc_cases = doc_xml.xpath("//idno[@type='case']")
        case_ids = doc_cases.map { |cs| cs.text }
        # need to open each of these caseid files and add the document to them
        case_ids.each do |caseid|
          caseid_path = File.join(case_loc, "#{caseid}.xml")
          caseid_xml = CommonXml.create_xml_object(caseid_path, false)

          # find the cases's div1 and look to see if it already has a div2 for documents
          div1 = caseid_xml.at_xpath("//xmlns:div1", xmlns: NS)
          div2 = div1.at_xpath("xmlns:div2[@type='documents']", xmlns: NS)
          if div2
            # check if the document id is already part of the case
            # and skip to the next case if it is
            next if div1.xpath("xmlns:div2[@type='documents']", xmlns: NS)
                      .children
                      .map { |node| node.text }
                      .include?(doc_id)
          else
            # create a div2 to contain the documents, add a comment explaining it
            # and then add the specific document to the caseid file
            div2 = div1.add_child("<div2 type='documents'/>").first
            comment = Nokogiri::XML::Comment.new(
              caseid_xml, "Documents are generated programmatically from document files. If document is no longer associated with a case it must be manually removed below."
            )
            div2.add_child(comment)
          end
          div2.add_child("<ab type='#{doc_type}'>#{doc_id}</ab>")

          # save caseid file back to location
          File.write("#{caseid_path}", caseid_xml.to_xml(
            encoding: "UTF-8",
            indent: 0,
          ))
        end
      end
      puts "inserted documents into case files, please review and commit to version control"
    end
  end

end
