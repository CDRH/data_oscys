# Generalized SOLR Schema

I have not compared these fields to every project to make sure they fit, but here is my preliminary list of general CDRH SOLR fields. All are single valued unless indicated:

## Resource Identification:

### id
* **id**
   * oscys.case.XXXX.XXX - Case Documents. recordType_s:document. ID pulled from filename
   * oscys.mb*, oscys.report*, Supplementary case documents. recordType_s:document. ID pulled from filename. 
   * oscys.caseid.XXXX - Case ID record. Describes a case. recordType_s:caseid. ID pulled from filename. 
   * per.XXXXX - Person record, describes a person. All come from 1 file: oscys.persons.xml  recordType_s:person. ID pulled from xml:id of person element. 
   
* **slug** (I have been using this in some contexts to indicate where the files are found, i.e. cody/xml/tei/. Should include the shorthand version of the project, i.e. "cody" at the least)
* **project** (the full CDRH name of the resource, e.g. "The William F. Cody Archive")
* **uri** (full URI of resource)
* **uriXML** (full URL to XML of data, when available)
* **uriHTML** (full URL to HTML snippit of data)
* **dataType** (the format the data was originally stored in at CDRH. current options: tei, dublin_core, vra_core, csv)

### Dublin Core Metadata Elements. 

I've included a couple of extra elements here as they make sense to support the DC elements. DC Elements described here: http://dublincore.org/documents/dcmi-terms/

* **title**
* **titleSort** (a,an,the removed/moved to the end)
* **creator** (a singular field for the creator, used for sorting. If there are multiple creators, they will be alphabetized  i.e. "Boggs, Jeremy; Earhart, Amy; Graham, Wayne"
* **creators** (multivalued field containing the names from above - <field>Boggs, Jeremy</field>, <field>Earhart, Amy</field>, <field>Graham, Wayne</field>)
* **subject** (generally won't be used because it's covered by topics below, but may use this for controlled vocab subject)
* **subjects** (multivalued version of above)
* **description** (a short description of the resource, often what will be shown in search results/aggregation pages)
* **publisher** (generally for books. The CDRH is the known publisher of the electronic versions, and we may want to find a way to distinguish that from the original publisher)
* **contributor** (all contributors collapsed into one field like creator above. Pulled from TEI resp statements and the like)
* **contributors** (multivalued)
* **date** (date using the solr date value)
* **dateDisplay** (however we want the date to display, either pulled from the TEI or normalized from the @when)
* **type** (From Dublin core, usually will be Image, Text, Sound or something like this. Often a duplicate of "subCategory" field)
* **format** (The file format, physical medium, or dimensions of the resource.)
* **medium** (added because a few projects seem to use it)
* **extent** (size or time span)
* **language**
* **relation** (A related resource that is substantially the same as the described resource, but in another format.)
* **coverage** (The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.) (Included for completeness, but probably covered in most cases by other fields)
* **source** (A related resource from which the described resource is derived) - in many cases, this may be the newspaper, publication, or book the resource is from.
* **rightsHolder** (A person or organization owning or managing rights over the resource.) - often this is where the CDRH got the object
* **rights** (any information about the rights)
* **rightsURI** (URI for above, will usually be linked to the "rights holder" for display purposes)

### Other elements: 

* **principalInvestigator** (in TEI header)
* **principalInvestigators** (multivalued)
* **place** (solr lat/long type) (for now, I am assuming each document has only one place. we may need to reevaluate in the future)
* **placeName** (name for the place above, or may be used without the lat/long)
* **recipient** (a singular field for the recipient(s), used for sorting. If there are multiple recipients, they will be alphabetized  i.e. "Boggs, Jeremy; Earhart, Amy; Graham, Wayne"
* **recipients** (multivalued field containing the names from above - <field>Boggs, Jeremy</field>, <field>Earhart, Amy</field>, <field>Graham, Wayne</field>)

### CDRH specific categorization (all pulled directly from the profileDesc)

* **category**
* **subCategory**
* **topics** (multivalued)
* **keywords** (multivalued)
* **people** (multivalued)
* **places** (multivalued)
* **works** (multivalued)

### OSCYS General Fields
* **peopleID_ss** The id of a person appearing in the file. for person files this should be repeated from ID
* **peopleIDName_ss** The ID and name of any people appearing in the file (Format: ID/Title)
* **plaintiff_ss**
* **defendant_ss**
* **attorneyP_ss**
* **attorneyD_ss**
* **term_ss**
* **attorney_ss**


### OSCYS Person Fields

* **personAffiliation_ss**
* **personAge_ss**
* **personBibl_ss**
* **personBirth_ss**
* **personDeath_ss**
* **personEvent_ss**
* **personIdnoVIAF_ss**
* **personNationality_ss**
* **personNote_ss**
* **personOccupation_ss**
* **personName_ss**
* **personResidence_ss**
* **personSex_ss**
* **personSocecStatus_ss**
* **personColor_ss**

### OSCYS CaseID Fields

* **relatedCaseID_ss** - related cases ID
* **relatedCaseIDName_ss** - related cases ID + Name

### OSCYS Documents Fields

* **caseID_ss** (documents only) The id of any cases associate with this document
* **caseIDName_ss** (documents only) the ID and Name of any cases associated with this document (e.g. "oscys.caseid.0002/Ann Shorter v. Thomas Corcoran")

### Generic Text field: (much of the above is copied into this for text searching)

