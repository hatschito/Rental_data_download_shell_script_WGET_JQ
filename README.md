# Fetch_rental data from NESTORIA
Until recently I fetched rental data via a R script based on R´s Jsonlite library and by accessing Nestoria´s API  (a  vertical search engine, that bundles the data of several real estate engines). My first script had to be executed manually; in the next attempt, I started to automate the data downloading, unlikely the service blocked my IP.  I admit, I excessively downloaded data and did the download  using  a static IP and a  cronjob that has been executed always on daily basis always on the same daytime. This resulted in a 403 error (IP forbidden, I used a static IP). So together with Nico (@bellackn) an alternative was figured out. Instead of Jsonlite our shell script uses WGET and makes use of the great JQ tool (CSV to JSON Parser). Thank´s Nico, for the input and ideas.

We use the  w 60 and –random-wait flag, this tells WGET to either wait 0, 60 or 120 secs to download. This behavior tricks the server. Within WGET also the area of interest is defined. The API allows LAT/LONG in decimal degrees or place names.

Next the first page is downloaded and the first page has to be altered with the sed command (UNIX command to parse text). A while loop does the downloading of the remaining pages, the page number to be downloaded can be changed. We receive JSON files, that have to be parsed to a geodata format.

Next the data is loaded to a short R script. R´s SP library converts the CSV to a Shapefile (actually we will skip this part and in the next version GDAL should manage the file conversion). 
At the end of the script the shapefile is converted to a GEOJSON dataset, so it can be used as an input for a webmap. 
Back in the shell script, a timestamp is appended to the Shapefile. After some cleaning at the end of the shell script, finally a cronjob is created to schedule the daily data download. 


A GUI based job sheduler can be found here https://wiki.ubuntuusers.de/GNOME_Schedule/

Still the resulting shapefiles are stored file based but in the next step I´ll hook the script to an PostgreSQL database that was already installed on a Linux VServer.

Feel free to use our script if you are interested in downloading geocoded rental data for your area of interest. Any feedback or comment is appreciated.
