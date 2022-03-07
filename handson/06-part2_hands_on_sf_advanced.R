library(sf)
library(tidyverse)
library(tidygeocoder)
library(patchwork)
library(rdwd)

##### Geometry Operations
# Wir laden Deutschland als Vektordaten
load(system.file("extdata/DEU.rda", package="rdwd"))
germany <- st_as_sf(DEU)

ggplot(germany) +
  geom_sf() +
  theme_void()

# Erzeugt vereinfachte Versionen des germany-Datensatzes und
# stellt diese dar. Experimentiert mit verschiedenen Werten 
# für dTolerance (von 100 bis 100.000) von st_simplify().
# 
# 1. Bei welchem Wert bricht die Form des Ergebnisses bei jeder Methode
#    zusammen, so dass Neuseeland nicht mehr erkennbar ist?

# Findet das geographische Zentroid von Deutschland. Wie weit ist es von
# von dem geographischen Zentroid von Niedersachen und Baden-Württemberg
# entfernt? Hinweis: st_union

# Berechnet die Länge der Grenzlinien der Bundesländer in Metern. 
# Welches Land hat die längste Grenze und welches die kürzeste?
# Hinweis: st_length() + MULTILINESTRING

##### Plotting ----
# Geodaten einlesen und ersten Blick draufwerfen
seismic <- st_read("data/seismic.geojson")
glimpse(seismic)
view(seismic)

# Geodaten mit R konvertieren
dir.create("seismic")
st_write(seismic, "seismic/seismic.shp", delete_dsn = TRUE)

# Wir ändern die Projektion zu Web Mercator
seismic <- seismic %>%
  st_transform("EPSG:3857")

# Was ist die Projektion?
st_crs(seismic)

# ... und zurück zu WGS84
seismic <- seismic %>%
  st_transform("EPSG:4326")

# Was ist die Projektion?
st_crs(seismic)

# ValueRange
seismic <- seismic %>%
  mutate(ValueRange_Factor = factor(ValueRange,
                             levels = c("< 1","1 - 2","2 - 5","5 - 10","10 - 14")))

# make a map of the annual risk of experiencing a damaging quake in the continental US
p1 <- ggplot() +
  geom_sf(data = seismic,
          aes(fill = ValueRange), 
          size = 0) +
  ggtitle("Wrong:") +
  scale_fill_brewer(palette = "Reds",
                    name = "% chance") +
  coord_sf(crs = "EPSG:5070",
           default_crs = "EPSG:4326") +
  theme_void()
p1 

p2 <- ggplot() +
  geom_sf(data = seismic,
          aes(fill = ValueRange_Factor), 
          size = 0) +
  ggtitle("Correct:") +
  scale_fill_brewer(palette = "Reds",
                    name = "% chance") +
  coord_sf(crs = "EPSG:5070",
           default_crs = "EPSG:4326") +
  theme_void()
p2 

p1 / p2 
p1 + p2



##### Lösung zu Geometry Operations ----
plot(st_simplify(st_geometry(germany), dTolerance = 100))
plot(st_simplify(st_geometry(germany), dTolerance = 1000))
plot(st_simplify(st_geometry(germany), dTolerance = 10000))
plot(st_simplify(st_geometry(germany), dTolerance = 50000))
plot(st_simplify(st_geometry(germany), dTolerance = 100000))
plot(st_simplify(st_geometry(germany), dTolerance = 10000, preserveTopology = TRUE))

st_simplify(germany, dTolerance = 30000) %>% 
  filter(st_geometry_type(.) %in% c("POLYGON", "MULTIPOLYGON")) %>% 
  st_cast("POLYGON")

nds_cent = st_centroid(germany %>% filter(NUTS_NAME == "Niedersachsen"))
bw_cent = st_centroid(germany %>% filter(NUTS_NAME == "Baden-Württemberg"))
ger_cent = st_sf(st_centroid(st_union(germany)))
ger_cent$NUTS_NAME <- "Deutschland"
st_geometry(ger_cent) <- "geometry"
st_distance(rbind(nds_cent, bw_cent, ger_cent))

ggplot(germany) +
  geom_sf() +
  geom_sf(data = nds_cent, color = "orange") +
  geom_sf(data = bw_cent, color = "coral") +
  geom_sf(data = ger_cent, color = "purple") +
  theme_minimal()

germany_bor = st_cast(germany, "MULTILINESTRING")
germany_bor$borders = st_length(germany_bor)
View(arrange(germany_bor, borders))
