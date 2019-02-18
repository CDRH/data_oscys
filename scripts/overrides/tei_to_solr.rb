class TeiToSolr

  # people is expecting array of hashes with id, label, and name
  def build_person_fields(x, role, people)
    uniq_ppl = people.uniq { |person| person["id"] }
    # make the following fields for each role:  _ss, ID_ss, Data_ss
    uniq_ppl.each do |uniq_pers|
      x.field(uniq_pers["label"], "name" => "#{role}_ss")
      x.field(uniq_pers["id"], "name" => "#{role}ID_ss")
      obj = { "label" => uniq_pers["label"], "id" => uniq_pers["id"] }
      x.field(json(obj), "name" => "#{role}Data_ss")
    end
  end

  def build_pi_fields(x)
    pis = @xml.xpath("/TEI/teiHeader/fileDesc/titleStmt/principal").map { |f| f.text }
    if pis.length > 0
      x.field(pis.join("; "), "name" => "principalInvestigator", "update" => "add")
    end
    pis.each do |f|
      x.field(f, "name" => "principalInvestigators", "update" => "add")
    end
  end

  def build_title_fields(x, title)
    x.field(title, "name" => "title", "update" => "add")
    x.field(CommonXml.normalize_name(title), "name" => "titleSort", "update" => "add")
    # grab the first letter of the title
    letter = title[0] ? title[0].downcase : ""
    x.field(letter, "name" => "titleLetter_s", "update" => "add")
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

  # TODO documents also call date_standardize XSLT and add T00:00:00Z to the end
  # but see if this is required or relic of older code
  def doc_date(doc_xml)
    date_node = nil
    if doc_xml.at_xpath("//keywords[@n='subcategory']/term[text()='Court Report']")
      date_node = doc_xml.at_xpath("//keywords[@n='term']/term/date")
    else
      date_node = doc_xml.at_xpath("/TEI/teiHeader/fileDesc/sourceDesc/bibl/date")
    end
    if date_node
      { "date" => date_node["when"], "dateDisplay" => CommonXml.normalize_space(date_node.text) }
    end
  end

  # returns an array of strings
  def get_field(xml_in, xpath)
    values = xml_in.xpath(xpath)
    values = values.map { |val| CommonXml.normalize_space(val.text) }
    values.reject { |val| val.empty? }
  end

  def get_person_role(person)
    if person["role"]
      case person["role"]
      when "petitioner"
        "plaintiff"
      when "attorney_plaintiff", "attorney_petitioner"
        "attorneyP"
      when "attorney_defendant"
        "attorneyD"
      else
        # defendant and plaintiff go into this category
        person["role"]
      end
    end
  end

  def get_title(src_xml=@xml)
    title = src_xml.xpath(
      "/TEI/teiHeader/fileDesc/titleStmt/title[@type='main']",
      "/TEI/teiHeader/fileDesc/titleStmt/title"
    )
    title.first.text if title && title.first
  end

  def json(object, overrides={})
    combined = object.merge(overrides)
    JSON.generate(combined)
  end

  def people_role_template
    {
      "person" => [],
      "plaintiff" => [],
      "defendant" => [],
      "attorneyP" => [],
      "attorneyD" => []
    }
  end

end
