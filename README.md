# OSCYS

This is the data repository for the [O Say Can You See](https://earlywashingtondc.org/) website. It contains the following:

__source files__

- TEI-XML
  - documents
  - cases
  - a personography file
- CSV
  - information from Washington D.C directories
  - relationship information between individuals (in `rdf` directory)

__scripts__

- search
  - add documents, cases, and people into the search results
- relationship queries
  - turn relationship CSV into TTL file for querying with RDF / SPARQL
- html
  - transforms TEI-XML into HTML files
  - transforms CSVs into geoJSON for maps

It's important to know that scripts for searching, found in `data_manager.rb` and `tei_to_solr_*` may pull multiple files. For example, a case's solr information may be built by pulling data from multiple document XML files.

Additionally, there is more documentation for the RDF related scripts in the [scripts directory](/scripts/README.md).

Posting documentation now available at: https://cdrh.github.io/posting_docs/projects/oscys
