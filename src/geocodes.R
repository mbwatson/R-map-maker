## given a city name,
## return the location [lon,lat]
get_coords <- function(cityname) {
  coords <- geocode(as.character(cityname),output="latlon",source="google")
  return(coords)
}

## given a city name,
## return all geocode information [a whole bunch of stuff]
get_geocode <- function(place) {
  as.data.frame(geocode(place, output="all", source="google"))
}

## given an array of city names,
## return all geocode information [a whole bunch of stuff]
get_geocodes <- function(places) {
  df <- data.frame()
  for (place in places) {
    cat(paste("Looking up",place,"..."))
    gc <- get_geocode(place)
    df <- rbind(df,gc)
  }
  return(df)
}

