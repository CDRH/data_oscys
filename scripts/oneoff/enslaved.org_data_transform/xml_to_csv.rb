require 'csv'
require 'nokogiri'

puts "This script converts XML files into CSV. Before running this script be sure you have an XML file (named people.xml, sources.xml, or events.xml) saved to the same directory. These files are currently exported from SOLR.\n\n"
puts "Enter the name of the output file you want to create. Options are output_events.csv, output_people.csv, output_personEvent.csv, and output_sources.csv."
filename = gets.chomp()

def events_csv(xml)
	doc = Nokogiri::XML(xml)
	source_xml = File.read("sources.xml")
	source_doc = Nokogiri::XML(source_xml)
	list = []

	doc.xpath('//doc').each do |i|
		identifier = i.xpath("./str[@name='id']").text
		uri = i.xpath("./str[@name='uri']").text
		name = i.xpath("./str[@name='title']").text
		type = "Legal Proceedings"
		documentDateRange = []
		i.xpath(".//arr[@name='caseDocumentData_ss']/str").each do |node|
			date_string = node.text
			if date_string.include? "date\"" and !date_string.include? "date\":null" and !date_string.include? "date\":\"--"
				documentDateRange << date_string.split("date\":\"").last.split("\",\"dateDisplay").first
			end
		end
		relatedDocumentDateRange = []
		i.xpath(".//arr[@name='caseRelatedDocumentData_ss']/str").each do |node|
			date_string = node.text
			if date_string.include? "date\"" and !date_string.include? "date\":null" and !date_string.include? "date\":--"
				relatedDocumentDateRange << date_string.split("date\":\"").last.split("\",\"dateDisplay").first
			end
		end
		dateRange = documentDateRange + relatedDocumentDateRange
		startdate = dateRange.sort[0]
		enddate = i.xpath(".//str[@name='date']").text
		documents = []
		i.xpath(".//arr[@name='caseDocumentID_ss']/str").each do |node|
			documents << node.text
		end
		documents = documents.join(";")
		relatedDocuments = []
		i.xpath(".//arr[@name='caseRelatedDocumentID_ss']/str").each do |node|
			relatedDocuments << node.text
		end
		relatedDocuments = relatedDocuments.join(";")
		documentSources = []
		i.xpath(".//arr[@name='caseDocumentID_ss']/str").each.with_index do |node,ii|
			percentage = (ii.to_f / i.xpath(".//arr[@name='caseDocumentID_ss']/str").length * 100).to_i
			print "\b" * 16, "Progress: #{percentage}%. "
			doc_id = node.text
			documentSource = source_doc.xpath("//str[@name=\"source\"][preceding-sibling::str[@name=\"id\"]=\"#{doc_id}\"]").text
			documentSources << documentSource
		end
		documentSources = documentSources.uniq.join(";")
		relatedDocumentSources = []
		i.xpath(".//arr[@name='caseRelatedDocumentID_ss']/str").each.with_index do |node,ii|
			percentage = (ii.to_f / i.xpath(".//arr[@name='caseRelatedDocumentID_ss']/str").length * 100).to_i
			print "\b" * 16, "Progress: #{percentage}%. "
			doc_id = node.text
			relatedDocumentSource = source_doc.xpath("//str[@name=\"source\"][preceding-sibling::str[@name=\"id\"]=\"#{doc_id}\"]").text
			relatedDocumentSources << relatedDocumentSource
		end
		relatedDocumentSources = relatedDocumentSources.uniq.join(";")
		people = []
		i.xpath(".//arr[@name='personID_ss']/str").each do |node|
			people << node.text
		end
		people = people.join(";")

		list << [identifier,uri,name,type,startdate,enddate,documents,relatedDocuments,documentSources,relatedDocumentSources,people]
	end

	CSV.open("output_events.csv",'wb') do |row|
		row << ['identifier','uri','name','type','startdate','enddate','documents','relatedDocuments','documentSources','relatedDocumentSources','people']
		list.each do |data|
			row << data
		end
	end
end

def people_csv(xml)
	doc = Nokogiri::XML(xml)
	list = []

	doc.xpath('//doc').each do |i|
		identifier = i.xpath("./str[@name='id']").text
		uri = i.xpath("./str[@name='uri']").text
		name = i.xpath("./str[@name='title']").text
		altName = []
		i.xpath("./arr[@name='personAltName_ss']/str").each do |node|
			altName << node.text
		end
		altName = altName.join(";")
		type = "Person"
		raceOrColor = []
		i.xpath("./arr[@name='personColor_ss']/str").each do |node|
			raceOrColor << node.text
		end
		raceOrColor = raceOrColor.join(";")
		birthdate = []
		i.xpath(".//arr[@name='personBirth_ss']/str").each do |node|
			birthdate << node.text
		end
		birthdate = birthdate.join(";")
		deathdate = []
		i.xpath(".//arr[@name='personDeath_ss']/str").each do |node|
			deathdate << node.text
		end
		deathdate = deathdate.join(";")
		sex = []
		i.xpath(".//arr[@name='personSex_ss']/str").each do |node|
			sex << node.text
		end
		sex = sex.join(";")
		status = []
		i.xpath(".//arr[@name='personSocecStatus_ss']/str").each do |node|
			status << node.text
		end
		status = status.join(";")
		note = []
		i.xpath(".//arr[@name='personNote_ss']/str").each do |node|
			note << node.text
		end
		note = note.join(";")

		list << [identifier,uri,name,altName,type,raceOrColor,birthdate,deathdate,sex,status,note]
	end

	CSV.open("output_people.csv",'wb') do |row|
		row << ['identifier','uri','name','altName','type','raceOrColor','birthdate','deathdate','sex','status','note']
		list.each do |data|
			row << data
		end
	end
end

def personEvent_csv(xml)
	doc = Nokogiri::XML(xml)
	list = []

	doc.xpath('//doc').each do |i|
		petitioners = []
		i.xpath(".//arr[@name='plaintiffID_ss']/str").each do |y|
			petitioners << y.text
		end
		defendants = []
		i.xpath(".//arr[@name='defendantID_ss']/str").each do |y|
			defendants << y.text
		end
		attorneysP = []
		i.xpath(".//arr[@name='attorneyPID_ss']/str").each do |y|
			attorneysP << y.text
		end
		attorneysD = []
		i.xpath(".//arr[@name='attorneyDID_ss']/str").each do |y|
			attorneysD << y.text
		end
		i.xpath(".//arr[@name='personID_ss']/str").each do |node|
			person = node.text
			event = node.xpath("ancestor::doc/str[@name='id']").text
			roleWithinEvent = []
			if petitioners.include?(person)
				roleWithinEvent << "petitioner"
			elsif defendants.include?(person)
				roleWithinEvent << "defendant"
			elsif attorneysP.include?(person)
				roleWithinEvent << "petitionerAttorney"
			elsif attorneysD.include?(person)
				roleWithinEvent << "defendantAttorney"
			else
				roleWithinEvent = []
			end

			roleWithinEvent = roleWithinEvent.join("; ")

			list << [person,event,roleWithinEvent]
		end
	end

	CSV.open("output_personEvent.csv",'wb') do |row|
		row << ['person','event','roleWithinEvent']
		list.each do |data|
			row << data
		end
	end
end

def sources_csv(xml)
	doc = Nokogiri::XML(xml)
	list = []

	doc.xpath('//doc[not(contains(descendant::str[@name="id"],"supp"))]').each do |i|
		identifier = i.xpath("./str[@name='id']").text
		uri = i.xpath("./str[@name='uri']").text
		name = i.xpath("./str[@name='title']").text
		type = "Civil (document)"
		project = "O Say Can You See"
		dateAll = i.xpath(".//str[@name='date']").text
		date = dateAll.split("T00:00:00Z").first
		event = []
		i.xpath(".//arr[@name='documentCaseID_ss']/str").each do |node|
			event << node.text
		end
		event = event.join(";")
		source = i.xpath(".//str[@name='source']").text
		people = []
		i.xpath(".//arr[@name='personID_ss']/str").each do |node|
			people << node.text
		end
		people = people.join(";")
		list << [identifier,uri,name,type,project,date,event,source,people]
	end

	CSV.open("output_sources.csv",'wb') do |row|
		row << ['identifier','uri','name','type','project','date','event','source','people']
		list.each do |data|
			row << data
		end
	end
end

if filename.include? "events"
	xml = File.read("events.xml")
	events_csv(xml)
	puts "Transformation successful. See the output_events.csv file for results."
elsif filename.include? "people"
	xml = File.read("people.xml")
	people_csv(xml)
	puts "Transformation successful. See the output_people.csv file for results."
elsif filename.include? "person"
	xml = File.read("events.xml")
	personEvent_csv(xml)
	puts "Transformation successful. See the output_personEvent.csv file for results."
elsif filename.include? "sources"
	xml = File.read("sources.xml")
	sources_csv(xml)
	puts "Transformation successful. See the output_sources.csv file for results."
else 
	puts "Alas, that is not one of the possible output files. Please try again."
end