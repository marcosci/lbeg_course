library(terra)
# Lies die Datei raster/nlcd.tif aus dem Paket spDataLarge ein. 
# Welche Art von Informationen kannst du über die Eigenschaften dieser Datei erhalten?
nlcd_file = system.file("raster/nlcd.tif", package = "spDataLarge")
"data/dgm.tif"
nlcd_rast = rast(nlcd_file)
nlcd_rast

nlyr(nlcd_rast)
res(nlcd_rast)
dim(nlcd_rast)
ras_bbox <- ext(nlcd_rast)
plot(nlcd_rast)

# Erstelle ein neues Raster mit neun Zeilen und Spalten und einer Auflösung von 0,5 Dezimalgrad (WGS84). 
# Fülle es mit Zufallszahlen. Extrahiere die Werte der vier Eckzellen.
install.packages("spDataLarge", repos = "https://geocompr.r-universe.dev")

# Plotte ein Histogramm und Boxplot der Datei dem.tif aus dem Paket spDataLarge 
# (system.file("raster/dem.tif", package = "spDataLarge")).

# NDVI berechnen
multi_raster_file <- system.file("raster/landsat.tif", package = "spDataLarge")
multi_rast <- rast(multi_raster_file)

ndvi_fun <- function(nir, red){
  (nir - red) / (nir + red)
}

# lapp = map im terra context
ndvi_rast <- lapp(multi_rast[[c(4, 3)]], fun = ndvi_fun)
plot(ndvi_rast)

# Berechne den Normalized Difference Water Index (NDWI; (green - nir)/(green + nir)) 
# aus dem Landsat Bild.

# Lese das srtm.tif in R ein (srtm = rast(system.file("raster/srtm.tif", package = "spDataLarge"))). 
# Das Raster hat eine Auflösung von 0.00083 by 0.00083 Grad.
# Ändere die Auflösung zu 0.01 x 0.01 Grad (mit mehreren Methoden). 
# Plotte die  Ergebnisse. 
# Fallen dir unterschiede auf?
srtm <- rast(system.file("raster/srtm.tif", package = "spDataLarge"))
res(srtm)

rast_template <- rast(ext(srtm), res = 0.01)

srtm_resampl1 <- resample(srtm, y = rast_template, method = "bilinear")
srtm_resampl2 <- resample(srtm, y = rast_template, method = "near")
srtm_resampl3 <- resample(srtm, y = rast_template, method = "cubic")
srtm_resampl4 <- resample(srtm, y = rast_template, method = "cubicspline")
srtm_resampl5 <- resample(srtm, y = rast_template, method = "lanczos")

srtm_resampl_all <- c(srtm_resampl1, srtm_resampl2, srtm_resampl3,
                     srtm_resampl4, srtm_resampl5)
plot(srtm_resampl_all)

# differences
plot(srtm_resampl_all - srtm_resampl1, range = c(-300, 300))
plot(srtm_resampl_all - srtm_resampl2, range = c(-300, 300))
plot(srtm_resampl_all - srtm_resampl3, range = c(-300, 300))
plot(srtm_resampl_all - srtm_resampl4, range = c(-300, 300))
plot(srtm_resampl_all - srtm_resampl5, range = c(-300, 300))

# Zusatzaufgabe, falls man schnell durch kommt:
# Auf StackOverflow gibt es einen Post, der zeigt wie man die Distanz zur Küste
# in Rastern berechnet:
# https://stackoverflow.com/questions/35555709/global-raster-of-geographic-distances
#
# Versuche den gleichen Ansatz statt mit dem Paket Raster 
# mit dem Paket terra -> terra::distance().
# Downloade ein Digitales Geländemodell mit:
# geodata::elevation_30s())
# Wandle die Distanz in Kilometer um. 
# Hinweis: Je nach ausgewählten Land am besten die Auflösung verringern



## LÖSUNGEN ----
nlcd = rast(system.file("raster/nlcd.tif", package = "spDataLarge"))
dim(nlcd) 
res(nlcd) 
ext(nlcd) 
nlyr(nlcd)

r <- rast(nrow = 9,
         ncol = 9, 
         res = 0.5, 
         xmin = 0, 
         xmax = 4.5, 
         ymin = 0, 
         ymax = 4.5, 
         vals = rnorm(81))

# using cell IDs
r[c(1, 9, 81 - 9 + 1, 81)]
r[c(1, nrow(r)), c(1, ncol(r))]

dem <- rast(system.file("raster/dem.tif", package = "spDataLarge"))
hist(dem, breaks = c(100, 500, 1000, 1200))
boxplot(dem)

library(ggplot2)
ggplot(as.data.frame(dem), aes(dem)) + geom_histogram()
ggplot(as.data.frame(dem), aes(dem)) + geom_boxplot()

ndwi_fun = function(green, nir){
  (green - nir) / (green + nir)
}
ndwi_rast = lapp(multi_rast[[c(2, 4)]], fun = ndwi_fun)
plot(ndwi_rast)


# Fetch the DEM data for Spain
germany_dem <- geodata::elevation_30s(country = "Germany", path = ".", mask = FALSE)
plot(germany_dem)

# Reduce the resolution by a factor of 20 to speed up calculations
germany_dem <- aggregate(germany_dem, fact = 20)

# According to the documentation, terra::distance() will calculate distance
# for all cells that are NA to the nearest cell that are not NA. To calculate
# distance to the coast, we need a raster that has NA values over land and any
# other value over water
water_mask <- is.na(germany_dem)
water_mask[water_mask == 0] = NA

# Use the distance() function on this mask to get distance to the coast
distance_to_coast <- distance(water_mask)
# convert distance into km
distance_to_coast_km <- distance_to_coast / 1000

# Plot the result
plot(distance_to_coast_km, main = "Distance to the coast (km)")
