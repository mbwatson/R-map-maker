###########################################################
## Geocode Functions ######################################
###########################################################

## given a city name, return the location [lon,lat]

get_coords <- function(cityname) {
  coords <- geocode(as.character(cityname),output="latlon",source="google")
  return(coords)
}

## given a city name, return all geocode information [a whole bunch of stuff]

get_geocode <- function(place) {
  as.data.frame(geocode(place, output="all", source="google"))
}

## given an array of city names, return all geocode information [a whole bunch of stuff]

get_geocodes <- function(places) {
  df <- data.frame()
  for (place in places) {
    cat(paste("Looking up",place,"..."))
    gc <- get_geocode(place)
    df <- rbind(df,gc)
  }
  return(df)
}

###########################################################
## Map-making Functions ###################################
###########################################################

## all maps are based on a template defined by this function

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
## General Functions ######################################
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
