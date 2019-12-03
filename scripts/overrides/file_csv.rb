class FileCsv < FileType

  # NOTE: not a standard override!!!
  # GOAL: create geojson from csvs
  #   - do not post to solr
  #   - generate geojson as javascript file
  #   - utilize csv_to_html behavior and write to different location

  def build_json_from_csv
    features = []

    @csv.each_with_index do |row, index|
      next if row.header_row?
      feature = {
        "type" => "Feature",
        "geometry" => {
          "type" => "Point",
          "coordinates" => [ row["Long"].to_f, row["Lat"].to_f ]
        },
        "properties" => {}
      }
      @csv.headers.each do |field|
        next if field == "Lat" || field == "Long"
        # imitating empty string syntax from original arcGIS export
        feature["properties"][field] = row[field] || ""
      end
      features << feature
    end

    collection = {
      "type" => "FeatureCollection",
      "features" => features
    }

    pretty = JSON.pretty_generate(collection)
    write_json_to_file(pretty, self.filename(false))
    # write_json_to_file("var testing = #{features.to_json};", "testing")
  end

  # no support for elasticsearch, leave blank
  def transform_es
  end

  def transform_html
    puts "transforming #{self.filename} to HTML subdocuments"
    build_json_from_csv
    # transform_html method is expected to send back a hash
    # but already wrote to filesystem so just sending back empty
    {}
  end

  def write_json_to_file(json, filename)
    out_js = File.join(
      @options["collection_dir"], "output", @options["environment"], "json"
    )
    Datura::Helpers.make_dirs(out_js)

    filepath = File.join(out_js, "#{filename}.json")
    puts "writing to #{filepath}" if @options["verbose"]
    File.open(filepath, "w") { |f| f.write(json) }
  end
end
