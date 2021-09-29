## About Data Export

Currently these are exported manually from Solr. The queries used are documented below. Keep in mind that the "rows" might need to change based on number of people/cases (and could be set to some arbitratily high number)

### Case

#### json

https://cors1601.unl.edu/solr/api_oscys/select?q=category%3ACase&start=0&rows=667&wt=json&indent=true

#### csv

https://cors1601.unl.edu/solr/api_oscys/select?q=category%3ACase&start=0&rows=667&wt=csv&indent=true

### People

#### json

https://cors1601.unl.edu/solr/api_oscys/select?q=subCategory%3APerson&start=0&rows=6788&wt=json&indent=true

#### csv

https://cors1601.unl.edu/solr/api_oscys/select?q=subCategory%3APerson&start=0&rows=6788&wt=csv&indent=true