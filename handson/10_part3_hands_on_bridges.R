library(RPostgreSQL)
library(DBI)
library(sf)
library(odbc)
library(dplyr)
library(dbplyr)

# Datenbanken ------------------------------------------------------------
conn <- dbConnect(drv = PostgreSQL(), dbname = "rtafdf_zljbqm",
                 host = "db.qgiscloud.com",
                 port = "5432", user = "rtafdf_zljbqm", 
                 password = "d3290ead")

# Datenbank untersuchen:
dbListTables(conn)
dbListFields(conn, "highways")

# Einlesen in R und mit dplyr bearbeiten:
highways_db <- tbl(conn, "highways")

highways_db %>% 
  select(feature) %>% 
  filter(feature == "Principal Highway")

# dplyr Statement in SQL übersetzen
highways_db %>% select(feature) %>% show_query()

# Als Geodaten einlesen:
query = paste(
  "SELECT *",
  "FROM highways")
us_route <- st_read(conn, query = query, geom = "wkb_geometry")
us_route

plot(st_geometry(us_route))

query = paste(
  "SELECT ST_Union(ST_Buffer(wkb_geometry, 1000 * 20))::geometry",
  "FROM highways")
us_route <- st_read(conn, query = query)
us_route

plot(st_geometry(us_route))

# Verbindung schließen:
postgresqlCloseConnection(conn)

# LBEG Microsoft SQL Server ---------------------------------------------
library(rgdal)
library(sf)

# connect NIBIS_BODENKARTEN
dsn_NIBIS_BODENKARTEN <- "MSSQL:server=SQLSDEL1;database=NIBIS_BODENKARTEN;driver={SQL Server};trusted_connection=Yes"
ogrListLayers(dsn_NIBIS_BODENKARTEN)

bk50         <- st_as_sf(readOGR(dsn = dsn_NIBIS_BODENKARTEN, layer = "BK50_PLY_SHAPE"))
buek50       <- st_as_sf(readOGR(dsn = dsn_NIBIS_BODENKARTEN, layer = "BUEK50_PLY_SHAPE"))

# connect NIBIS_KLIMA
dsn_NIBIS_KLIMA <- "MSSQL:server=SQLSDEL1;database=NIBIS_KLIMA;driver={SQL Server};trusted_connection=Yes"
ogrListLayers(dsn_NIBIS_KLIMA)

DWD_STATIONEN_NDS         <- st_as_sf(readOGR(dsn = dsn_NIBIS_KLIMA, layer = "dbo.DWD_STATIONEN_NDS"))
st_crs(DWD_STATIONEN_NDS) <- 4647
DWD_STATIONEN_NDS         <- st_transform(DWD_STATIONEN_NDS, "EPSG:4647")
DWD_STATIONEN_NDS_wgs84   <- st_transform(DWD_STATIONEN_NDS, "EPSG:4326")

RASTER_1000_LBEG_KLIMAWERTE_1961_1990         <- st_as_sf(readOGR(dsn = dsn_NIBIS_KLIMA, layer ="dbo.RASTER_1000_LBEG_KLIMAWERTE_1961_1990"))
st_crs(RASTER_1000_LBEG_KLIMAWERTE_1961_1990) <- 4647
RASTER_1000_LBEG_KLIMAWERTE_1961_1990         <- st_transform(RASTER_1000_LBEG_KLIMAWERTE_1961_1990, "EPSG:4647")
RASTER_1000_LBEG_KLIMAWERTE_1961_1990_wgs84   <- st_transform(RASTER_1000_LBEG_KLIMAWERTE_1961_1990, "EPSG:4326")

plot(RASTER_1000_LBEG_KLIMAWERTE_1961_1990_wgs84[c("EVAPOTRANSPIRATION_WINTER_MM_HYDROLOGISCHES_JAHR","NIEDERSCHLAG_JAHR_MM_HYDROLOGISCHES_JAHR")])

# QGIS ------------------------------------------------------------------
library(qgisprocess)
library(terra)
qgis_providers()

# Daten einlesen:
dem <- rast(system.file("raster/dem.tif", package = "spDataLarge"))

# Terra Operationen:
dem_slope <- terrain(dem, unit = "radians")
dem_aspect <- terrain(dem, v = "aspect", unit = "radians")

plot(dem)

# Hilfe von QGIS Funktionen anzeigen:
qgis_show_help("saga:sagawetnessindex")

# Funktion ausführen und in natives R Objekt umwandeln:
dem_wetness <- qgis_run_algorithm("saga:sagawetnessindex", DEM = dem)
dem_wetness_twi <- qgis_as_terra(dem_wetness$TWI)

# Selbiges für Geomorphons:
grep("geomorphon", qgis_algo$algorithm, value = TRUE)
qgis_show_help("grass7:r.geomorphon")
dem_geomorph <- qgis_run_algorithm("grass7:r.geomorphon", elevation = dem, 
                                  `-m` = TRUE, search = 120)
dem_geomorph_terra <- qgis_as_terra(dem_geomorph$forms)


# Visualisierung mit ggplo2:
data <- stars::st_as_stars(dem_geomorph_terra)
data <- sf::st_as_sf(data)
names(data)[1] <- "geomorph"

map_geomorph <- ggplot() +
  geom_sf(data = data, 
          aes(fill = geomorph,
              color = geomorph), 
          size = 0.01) +
  scale_fill_brewer(palette = "Pastel1", name = "Geomorphon") +
  guides(color = FALSE) +
  theme_void()

data <- stars::st_as_stars(dem_wetness_twi)
data <- sf::st_as_sf(data)
names(data)[1] <- "wetness"

map_twi <- ggplot() +
  geom_sf(data = data, 
          aes(fill = wetness,
              color = wetness), 
          size = 0.01) +
  scale_fill_distiller(palette = "YlGnBu", name = "TWI", direction = 1) +
  guides(color = FALSE) +
  theme_void()

library(patchwork)
map_geomorph + map_twi

