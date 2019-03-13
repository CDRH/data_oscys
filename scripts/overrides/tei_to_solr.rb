class TeiToSolr

  def build_json_field(val, label=nil)
    json = {}

    json["label"] = label || CommonXml.normalize_space(val.text)

    # Note it seems wrong to have "date" be a non date format (includes text, etc)
    # but this is how it was being outputted in XSLT
    date = []
    date << "Not after #{val["notAfter"]}" if val["notAfter"]
    date << "Not before #{val["notBefore"]}" if val["notBefore"]
    date << val["when"] if val["when"]

    if !date.empty?
      json["date"] = date.join(" ")
      json["dateDisplay"] = date_display(date.join(" "))
    end

    if val["source"]
      json["id"] = val["source"].include?("viaf") ? @viaf : val["source"][/oscys\.[a-z]+\.[0-9]{4}\.[0-9]{3}/]
    elsif val.parent["source"]
      json["id"] = val.parent["source"][/oscys\.[a-z]+\.[0-9]{4}\.[0-9]{3}/]
    end
    # remove nil keys
    json.each { |k,v| json.delete(k) if !v }
    # json.delete("id") if !json["id"]

    json
  end

  def date_display(date_in)
    # if date has a letter, show as is
    if date_in[/[A-Za-z]/]
      date_in
    else
      y, m, d = date_in.split("-").map {|d| d.to_i }
      m = Date::MONTHNAMES[m.to_i] if m
      if y && m && d
        "#{m} #{d}, #{y}"
      elsif y && m
        "#{m}, #{y}"
      elsif y
        y.to_s
      end
    end
  end

  # returns an array of strings
  def get_field(xml, xpath)
    values = xml.xpath(xpath)
    values = values.map { |val| CommonXml.normalize_space(val.text) }
    values.reject { |val| val.empty? }
  end

  # returns a data structure formatted for Data_ss fields
  def get_data_field(xml, xpath)
    values = xml.xpath(xpath)
    values = values.reject { |val| val.text.empty? }
    values.map { |val| build_json_field(val) }
  end

  def json(object, overrides={})
    combined = object.merge(overrides)
    JSON.generate(combined)
  end

end
