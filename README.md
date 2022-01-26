# Data Repository for O Say Can You See: Early Washington, D.C., Law and Family Project

## About This Data Repository

**How to Use This Repository:** This repository is intended for use with the [CDRH API](https://github.com/CDRH/api) and the [O Say Can You See Ruby on Rails application](https://github.com/CDRH/earlywashingtondc).

**Data Repo:** [https://github.com/CDRH/data_oscys](https://github.com/CDRH/data_oscys)

**Source Files:** TEI XML, TXT, HTML, CSV

- TEI-XML
  - documents
  - cases
  - a personography file
- CSV
  - information from Washington D.C directories
  - relationship information between individuals (in `rdf` directory)

Posting documentation now available at: https://cdrh.github.io/posting_docs/projects/oscys

**Script Languages:** JavaScript, HTML, Ruby

- Search
  - Add documents, cases, and people into the search results
- Relationship Queries
  - Turn relationship CSV into TTL file for querying with RDF / SPARQL
- HTML
  - Transforms TEI-XML into HTML files
  - Transforms CSVs into geoJSON for maps

It's important to know that scripts for searching, found in `data_manager.rb` and `tei_to_solr_*` may pull multiple files. For example, a case's solr information may be built by pulling data from multiple document XML files.

Additionally, there is more documentation for the RDF related scripts in the [scripts directory](/scripts/README.md).

**Encoding Schema:** [Text Encoding Initiative (TEI) Guidelines](https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html) & [EAD](https://www.loc.gov/ead/)

## About O Say Can You See

This project collects, digitizes, and makes accessible the freedom suits brought by enslaved families in the Circuit Court for the District of Columbia, Maryland state courts, and the U.S. Supreme Court. In making these documents accessible, the project invites you to explore the legal history of American slavery and the web of litigants, jurists, legal actors, and participants in the freedom suits. This project places these families in the foreground of our interpretive framework of slavery and national formation.

**Project Site:** [https://earlywashingtondc.org/](https://earlywashingtondc.org/)

**Rails Repo:** [https://github.com/CDRH/earlywashingtondc](https://github.com/CDRH/earlywashingtondc)

**Credits:** [https://earlywashingtondc.org/about/credits](https://earlywashingtondc.org/about/credits)

**Work to Be Done:** [https://github.com/CDRH/earlywashingtondc/issues](https://github.com/CDRH/earlywashingtondc/issues)

## Copyright

By William G. Thomas and the Center for Digital Research in the Humanities, distributed under a [Creative Commons License](https://creativecommons.org/licenses/by-nc-sa/3.0/).

## Technical Information

Posting documentation is available at: [https://cdrh.github.io/posting_docs/projects/oscys](https://cdrh.github.io/posting_docs/projects/oscys)

See project site [Technical Information page](https://earlywashingtondc.org/about/technical)

See the [Datura documentation](https://github.com/CDRH/datura) for general updating and posting instructions. 

## About the Center for Digital Research in the Humanities

The Center for Digital Research in the Humanities (CDRH) is a joint initiative of the University of Nebraska-Lincoln Libraries and the College of Arts & Sciences. The Center for Digital Research in the Humanities is a community of researchers collaborating to build digital content and systems in order to generate and express knowledge of the humanities. We mentor emerging voices and advance digital futures for all.

**Center for Digital Research in the Humanities GitHub:** [https://github.com/CDRH](https://github.com/CDRH)

**Center for Digital Research in the Humanities Website:** [https://cdrh.unl.edu/](https://cdrh.unl.edu/)
