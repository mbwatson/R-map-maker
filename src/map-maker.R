library(ggplot2)
library(ggmap)

source("geocodes.R")
source("map_settings.R")

###########################################################

## all maps have template defined by this function
map_base <- function() {
  mapWorld <- borders("world", colour=outline_color, fill=fill_color)
  map <- ggplot()
  map <- map + mapWorld
}

## input year(s), and save maps for people enrolled during
map_people_in <- function(years, all=FALSE, style="dots") {
  if (all == FALSE) {
    for (year in years) {
      cat(paste(year,": Loading data... "))
      df <- merge(geocodes,people_in(year))
      cat("Generating map... ")
      map <- worldmap + geom_point(data=df,
              aes(x=lon,y=lat),
              size=0.1, color=pin_color, alpha=1) + map_theme + labs(title=paste(map_title," ",year))
      cat("Saving map... ")
      ggsave( paste(map_location,"map",year,".png",sep=""), 
              plot=map, scale=1, dpi=map_dpi, width=map_width, height=map_height, unit=map_unit)
      cat("Done!\n")
    }
  } else {
    cat(paste(years[1],"-",years[length(years)],": Loading data... "))
    df <- people_in(years)
    df <- cbind(df,total=rowSums(df[, X(years)]))
    df <- df[,!names(df) %in% X(years)]
    df <- merge(df,geocodes)
    timeSpan <- paste(years[1],"-",years[length(years)])
    cat("Generating map... ")
    map <- worldmap + geom_point(data=df,
              aes(x=lon,y=lat),
              size=0.1, color=pin_color, alpha=1) + map_theme + labs(title=paste(map_title," ",timeSpan))
    cat("Saving map... ")
    ggsave( paste(map_location,"map",timeSpan,".png",sep=""), 
              plot=map, scale=1, dpi=map_dpi, width=map_width, height=map_height, unit=map_unit)
    cat("Done!\n")
  }
}

###########################################################

## takes in a year (an integer, e.g., 1905). returns a string (e.g., "X1905")
## this is necessary for column reference
X <- function(str) {
  return(paste("X",str,sep=""))
}

## write a given data frame to a given filename
write <- function(df, filename) {
  write.table(df,filename,sep=",",row.name=FALSE)
}

## return data frame with columns [city, desired year(s)]
people_in <- function(years) {
  ## grab only columns/years desired
  df <- people[c("city",X(years))]
  ## remove rows with all 0s (i.e., no people)
  df <- df[rowSums(df == 0) != length(years),]
  return(df)
}

###########################################################
###########################################################
###########################################################

## read cities and student counts from file
people <- read.csv("data/people.csv",sep=",",header=TRUE)
## change NAs to 0s
people[is.na(people)] <- 0

## read already-known geocodes from file & save a backup copy
known_geocodes <- read.csv("data/geocodes.csv",sep=",",header=TRUE)
write(known_geocodes,"data/geocodes_backup.csv")

## read needed cities from people data frame
geocodes <- data.frame("city"=people[,"city"],"lon"=NA,"lat"=NA)
## check if each city's geocode is already known,
## and look it up if not
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
# remove known_geocodes from memory with : rm(known_geocodes)
# save now-known geocodes for next time
write(geocodes,"data/geocodes.csv")

## create blank map
worldmap <- map_base()

