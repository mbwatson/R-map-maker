library(ggplot2)
library(ggmap)

source("src/public.R")
source("src/geocodes.R")
source("src/map_settings.R")

###########################################################
###########################################################

## read cities and people counts from file

people <- read.csv("./data/people.csv",sep=",",header=TRUE)

## change NAs to 0s

people[is.na(people)] <- 0

## read already-known geocodes from file & save a backup copy

known_geocodes <- read.csv("./data/geocodes.csv",sep=",",header=TRUE)
write(known_geocodes,"./data/geocodes_backup.csv")

## read needed cities from people data frame

geocodes <- data.frame("city"=people[,"city"],"lon"=NA,"lat"=NA)

## check if each city's geocode is already known, and look it up if not

for (n in 1:nrow(geocodes)) {
  cityname <- geocodes[n,1]
  if ( (cityname %in% known_geocodes$city)
    & (!is.na(known_geocodes[known_geocodes$city %in% cityname, "lon"]))
    & (!is.na(known_geocodes[known_geocodes$city %in% cityname, "lat"]))) {
    geocodes[n,"lon"] <- known_geocodes[cityname,"lon"]
    geocodes[n,"lat"] <- known_geocodes[cityname,"lat"]
  } else {
    cat(paste("Looking up",cityname,"..."  ))
    city_coords <- get_coords(cityname)
    geocodes[n,"lon"] <- city_coords$lon
    geocodes[n,"lat"] <- city_coords$lat
  }
}

# note: possible to remove known_geocodes from memory with : rm(known_geocodes)

# save now-known geocodes to speed things up next time

write(geocodes,"data/geocodes.csv")

## create blank map

worldmap <- map_base()

###########################################################
###########################################################

## what should each map be named?
## map_title <- readline('Enter a title for your map(s): ')
map_title = "Generic Map Title"

