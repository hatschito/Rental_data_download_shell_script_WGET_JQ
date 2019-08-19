#!/bin/bash

#**************************************************************
#Bash-script to download real estate data from the Nestoria API
#@hatschito & @bellackn
#**************************************************************

# HS 8.8.2019 There is an issue with csvkit: https://github.com/wireservice/csvkit/issues/982 Some dependencies might not be OK concerning Python importlib 
# Json cannot be converted to csv. A Workaround is the online converter: http://convertcsv.com/json-to-csv.htm
#This online converter works really well!

# Pfad zum Skript /media/harald/Harald_1/AUSTAUSCH_TEMP/RealEstateProject$


# Pdad zum Skript /media/harald/Harald_1/AUSTAUSCH_TEMP/RealEstateProject$

datum=$(date +%Y%m%d_%H%M)
place=Potsdam
#insert the name of the place which you want to download data for

#download the first page, completely with all features
#-w 60 and --random-wait tells the command to either wait 0, 60 or 120 secs to download (tricking the server)
(
wget -w 60 --random-wait -qO- "http://api.nestoria.de/api?country=de&pretty=1&encoding=json&action=search_listings&place_name=$place&listing_type=rent&page=1";
) > ./rentalprice-$datum.json

echo -e "\nOrt: $place\nSeite 1 wird heruntergeladen."

sed '/application/ d' ./rentalprice-$datum.json > clr-rentalprice-$datum.json
#this part has to be removed via "sed" for the following insertion working properly

#now download the remaining pages, but just the locations-part ("jq" does this, jq has to be installed by sudo apt install jq),
#the rest is enough if once existent in the file that contains just the first page,
#you just need to insert the following stuff right in between those features

i=1
while [ $i -le 25 ]
#insert the number of pages you want to download, here: 2 to 28
#(find out how much pages you need/Nestoria offers - the json with "locs" in the file name should have just one comma at the end
#of the file - lower the number according to the odd commas - e.g. for Potsdam, it's 28)
# -----> (you'll also have to comment the deletion of the locs-file way down the script in order to do so...) <---------
do
  echo -e "Seite $i wird heruntergeladen."
  (
  wget -w 60 --random-wait -qO- "http://api.nestoria.de/api?country=de&pretty=1&encoding=json&action=search_listings&place_name=Potsdam&listing_type=rent&page=$i" | jq .response.listings;
  ) | tr -d "[]" | sed '/^\s*$/d' >> ./rentalprice-locs-$datum.json
  printf "," >> ./rentalprice-locs-$datum.json
  i=$[$i+1]
done

#what happens in the loop:
#a new file containing just the locations (without request, response and so on) is created, then the square brackets are removed via "tr"
#also, "sed" removes empty lines resulting from the deletion of those square brackets

sed "/listings/ r ./rentalprice-locs-$datum.json" ./clr-rentalprice-$datum.json > rental_prices-$place-$datum.json
#this combines the first page with the rest. the rest is inserted at the correct place and the syntax of the
#JSON will not be destroyed

rm rentalprice-$datum.json
rm rentalprice-locs-$datum.json
rm clr-rentalprice-$datum.json
#remove all the temporary files for better overview in the working directory

jq .response.listings < rental_prices-$place-$datum.json | in2csv -f json > CSV-rental_prices.csv

#CSV2Shapefile conversion with R
Rscript csv2shapefile.R

#Append date to shapefile and delete shapefile without timestamp
cp rental.prj rental$datum.prj
cp rental.shx rental$datum.shx
cp rental.shp rental$datum.shp
cp rental.dbf rental$datum.dbf

rm rental.prj
rm rental.shx
rm rental.shp
rm rental.dbf






#finally, convert the json into a csv
#-----> eventually, you have to 'sudo -H pip install csvkit' first! <-----

#sort -u CSV-rental_prices-$place-$datum.csv -o CSV-rental_prices_unique-$place-$datum.csv
#sorts the output and only keeps unique entries. Thanx Erik for the advice


#sqllite to convert csv to shapefile



echo -e "Fertig.\n"
