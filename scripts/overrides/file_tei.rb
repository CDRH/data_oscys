class FileTei < FileType

  # this is an override of the default XSLT behavior to transform
  # TEI to Solr XML
  def transform_solr
    puts "transforming #{self.filename}"
    req = {}

    # imitating structure of tei_to_es for oscys overrides
    # but not worrying about breaking into subdocuments for each class
    if self.filename.include?("persons")
      require_relative "tei_to_solr_personography.rb"
      docs = TeiToSolrPersonography.new(@options, self.file_location, self.out_solr).xml
    elsif self.filename.include?("caseid")
      require_relative "tei_to_solr_caseid.rb"
      docs = TeiToSolrCaseid.new(@options, self.file_location, self.out_solr).xml
    else
      # document
    end


    if @options["output"]
      File.write(File.join(@out_solr, self.filename), docs)
    end
    # TODO send back any problems with an error key
    { "doc" => docs }
  end

end
