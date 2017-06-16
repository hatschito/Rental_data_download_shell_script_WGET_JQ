rm(list = ls())
setwd("/media/harald/Harald_1/AUSTAUSCH_TEMP/RealEstateProject")


library(sp)
library(rgdal)


Rental <- read.csv("CSV-rental_prices.csv", header = T, sep = ",")
coordinates(Rental) <- ~longitude + latitude

proj4string(Rental) = CRS("+init=epsg:4326")
#fügt Datum hinzu
writeOGR(Rental, ".","rental", "ESRI Shapefile", overwrite_layer = TRUE)

