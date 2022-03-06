library(sf)

# sfg - simple feature geometries

## Wir erstellen einen einfachen Punkt:
pnt1 <- st_point(c(10.333205574817187, 51.80423475315072))

## ... kann jemand die Koordinate erraten?
pnt1
class(pnt1)

## Wir erstellen ein Polygon:
a <- st_polygon(list(cbind(c(0,0,7.5,7.5,0),c(0,-1,-1,0,0))))
class(a)
plot(a, border = "blue", col = "#0000FF33", lwd = 2)

## ... und ein zweites Polygon:
b <- st_polygon(list(cbind(c(0,1,2,3,4,5,6,7,7,0),c(1,0,0.5,0,0,0.5,-0.5,-0.5,1,1))))
class(b)
plot(b, border = "red", col = "#FF000033", lwd = 2)

## Solange wir nur mit der Klasse sfg arbeiten, verbinden wir die 2 Objekte wie normale Vektoren
ab <- c(a,b)
ab
plot(ab, border = "darkgreen", col = "#00FF0033", lwd = 2)

# Wo überschneiden sich die 2 Polygone? (mehr zu räumlichen Operationen in dem nächsten Abschnitt)
i <- st_intersection(a, b)
i
class(i)
plot(i, border = "black", col = "darkgrey", lwd = 2)


# sfc - Geometrie Spalte

## Wir brauchen mehr Punkte für eine Spalte:
pnt2 <- st_point(c(10.333688372401111, 51.804957872859994))
pnt3 <- st_point(c(7.844758252372815, 48.01435815079368))

## ... und vereinen die Punkte in einer simple feature column:
geom <- st_sfc(pnt1, pnt2, pnt3, crs = 4326)
geom 

# sf - Layer 
## Um einen Layer zu erzeugen, benötigen wir Metadaten:
name <- c("LBEG Hannover", "Bäckerei Biel", "Marcos Büro")
city <- c("Hannover", "Hannover", "Freiburg")
sunhours <- c(4, 4, 9)
bakery <- c(FALSE, TRUE, FALSE)
dat <- data.frame(name, city, sunhours, bakery)
dat

## Unsere 3 Punkte + Metadaten = sf Layer
layer <- st_sf(dat, geom)

## kurzer Blick auf die Daten:
library(mapview)
mapview(layer)

## Nur die simple features selektieren:
st_geometry(layer)

## Nur die Daten selektieren:
st_drop_geometry(layer)

## Koordinaten:
st_coordinates(layer)

# Daten einlesen

## Rohdaten: Wir haben Niederschlagsdaten, die geographisch verortet sind:
rainfall <- read.csv("data/rainfall.csv")
rainfall

## Mit st_as_sf wandeln wir den data.frame in ein sf Objekt um
## st_as_sf(x, coords, crs)
### x : Der Datensatz mit den Metainformationen und Koordinaten
### coords : Spaltenname der Koordinaten (X, Y)
### crs : Das CRS (NA falls nicht speziell gesetzt)
rainfall_sf <- st_as_sf(rainfall, coords = c("x_utm", "y_utm"), crs = 32636) # https://epsg.io/32636
rainfall_sf

mapview(rainfall_sf, zcol = "altitude")

## Bounding box
st_bbox(rainfall_sf)

## Verteilung der Messstationen
plot(st_geometry(rainfall_sf))

## Subsetting von Metainformationen
library(dplyr)
rainfall_sf %>% 
  filter(jan > 100) %>% 
  st_geometry(rainfall_sf) %>% 
  plot()

## Shapefiles einlesen
county <- st_read("data/USA_2_GADM_fips.shp")

## ... oder geojson Format:
airports <- st_read("data/airports.geojson")

# Grundlagen des Plottens

# plot plotted automatisch jede Spalte als Subplot:
plot(county)

## Einzelne Spalten können so ausgewählt werden:
plot(county[, "TYPE_2"], key.width = lcm(5), key.pos = 4)

## Das Aussehen kann hierbei beliebig verändert werden:
plot(st_geometry(county), border = "pink")

## und verschiedene Geometrien können dabei auch überlagert werden:
plot(st_geometry(county), border = "grey")
plot(st_geometry(airports), col = "red", add = TRUE)

# CRS

## sf Objekte werden mit einem EPSG Code umtransformiert:
### EPSG:2163 - US National Atlas Equal Area (https://epsg.io/2163)
county_reprojected <- st_transform(county, 2163) 
airports_reprojected <- st_transform(airports, 2163)

## Vergleicht hierzu die letzten zwei Plots:
par(mfrow=c(1,2))
plot(st_geometry(county), border = "grey")

# Exportieren von sf Objekten
st_write(rainfall, "rainfall_pnt.shp")

plot(st_geometry(airports), col = "red", add = TRUE)

plot(st_geometry(county), border = "grey")
plot(st_geometry(airports), col = "red", add = TRUE)

## Auch über die Koordinaten lässt sich das bestätigen:
st_coordinates(st_transform(airports, 4326)) # WGS84 coordinates
st_coordinates(st_transform(airports, 2163)) # US National Atlas coordinates