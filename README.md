# OSCYS Posting Instructions

## Update Development

Add your new files and update the relationships CSV.  Now, log into the development server and navigate to the oscys collection repository.


If relationships have changed or been updated, run the RDF generation.  This step may take several minutes:

```
ruby scripts/csv_to_rdf.rb
```

Now index everything to solr and generate the development HTML. This also includes the map geojson, which is regenerated as part of the HTML output format:

```
post -x html,solr
```

Once the above is done, review the development website.  If all looks well, then you can commit your changes:

```
(git pull to make sure you have the most up-to-date files)
git status  # check the branch is correct and the files look correct
git add (files)
git commit -m "message"
git push origin (branchname)
```

## Update Production

Once you have reviewed the development site, it's time to run everything for production!

Log into the server and visit the rails site.  Change the config file to use `api_oscys_emergency`.

```
vim config/config.yml
# press i to edit the file
# when done
:wq

touch tmp/restart.txt
```

Ensure that the site looks okay and then go to the collection repository.  When you pull, you will update the linked data relationships immediately so you do not need to re-run the script.  You will need to index the documents to Solr and generate HTML:

```
(git status or git branch to ensure you're on the correct branch)
git pull origin (branchname)

post -e production -x html,solr
```

Change the rails site back to using the `api_oscys` index and `touch tmp/restart.txt` again.  Check the website.  Does the HTML look okay?  If not, grab a developer to help figure out what is different.  If there is nobody nearby and it needs immediately attention, switch your index back to the emergency index.

Otherwise, if all is well, commit any changes / additions to the production HTML:

```
git add (files)
git commit -m "message"
git push origin (branchname)
```

## Update the Maps

To update the maps, you will need to determine which layer needs updating. If it is a ward, public building, etc, then you need to update the geojson files in the Rails application. If it is a directory layer, like the breakdowns of court roles, gender, occupation, and race, then you should modify the directory CSV file in `source/csv`. Once your CSV is updated, you may run:

```
post -f csv -x html -e [environment]
```

This will create geojson files in the output directory which, if located on the development / production servers, will automatically update on the map.
