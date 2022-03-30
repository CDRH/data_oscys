# Data Transformation for OSCYS
The following instructions describe how to transform OSCYS data for ingest into enslaved.org. The scripts require Ruby to be installed. Depending on which version of Ruby you are using locally, you may need to install gems or switch to a different version of Ruby. 

- Make sure you have Ruby installed and save the following script files to a local directory:
  - `xml_to_csv.xsl` #this file is a pre-transformation for oscys.persons.xml only
  - `xml_to_csv.rb` #this is where most of the action happens
- Access the OSCYS SOLR interface (you will need to be on the VPN to do this) and do the following: 
  - In "q", enter: `recordType_s:caseid`
  - In "wt", select "xml"
  - Adjust row number to more than numFound in results and re-execute query
  - Open the link at the top of the results window in new tab, then save as `events.xml`
  - Repeat this process for people and source records (`recordType_s:person`, save as `people.xml`; `recordType_s:document`, save as `sources.xml`)
- Copy the personography file (`oscys.persons.xml`) from `source/tei` in the OSCYS data repo to your local directory.
- From within the directory, run the following command: `ruby xml_to_csv.rb`
- The script will prompt you for the name of your XML file and should inform you of the name of your new CSV file when the transformation is completed.
- Check the CSV output file and confirm the information looks accurate. 

## List of Scripts and Input Files
- xml_to_csv.xsl
- xml_to_csv.rb
- events.xml
- people.xml
- personEvent.xml
- sources.xml

## List of Output Files
- output_events.csv
- output_people.csv
- output_personEvent.csv
- output_sources.csv