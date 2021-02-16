# Scripts

Datura overrides are still to be found in the `overrides` directory.

There are a couple RDF related scripts in this directory, however, which you should be aware of:

__csv_to_rdf.rb__

This is the important one, which turns the mega CSV into a TTL file which can be queried! It will use files from and output files to `/rdf`.

__owl_to_ttl.rb__

I don't remember ever using this, and I suspect that it was written during development years ago and now remains as unused legacy code.

__relationship_generation.rb__

This is a script which Laura uses when she has a large number of people in a document whose relationships she needs to map out. This is meant to be run as-needed, not each time the repository is regenerated, etc.
