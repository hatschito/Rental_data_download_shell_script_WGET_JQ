# fetch_rental_data
Fetch rental data via a shell script

Until recently I fetched rental data via a R script based on R´s Jsonlite ( library and by accessing Nestorias API (a meta search engine, that bundles the data of several real estate engines). First script had to be executed manually, in the next step, I started automatisation of the data downloading, the service blocked my IP. I admit, I excessively downloaded data and did the download via a cronjob always on the same daytime. This resulted in a 403 error (IP forbidden, I used a static IP). So together with Nico (@bellackn) an alternative was figured out. Instead of Jsonlite our shell script uses WGET and makes use of the great JQ tool.
We use w 60 and --random-wait flag, this tells WGET to either wait 0, 60 or 120 secs to download - tricking the server.

Next the first page is downloaded and the first page has to be altered with the sed command (UNIX command to parse text). A for loop does the downloading of the remaining pages, the page number to be downloaded can be changed. We get JSON files, that have to be parsed to a geodata format. This is done in several steps.

- JQ, a command line JSON interpreter parses the JSON to CSV: http://manpages.ubuntu.com/manpages/trusty/man1/jq.1.html

- Next the data is loaded to a short R script. R´s SP library converts the CSV to a Shapefile (actually we will skip this part and in the next version gdal should manage the file conversion).
- Back in the shell script, a timestap is appended to the Shapefile.

Finally, a Cronjob is created to manage the daily data download. The Cronjob also can be done via a GUI: The resulting Shapefiles are written to a locally installed PostgreSQL database.

Feel free to use our script if you are interested in downloading geocoded rental data for your area of interest.
