library(sf)
library(dplyr)
library(stars)
library(gstat)
library(automap)
library(purrr)
library(tictoc)

# Einlesen der Daten und jährlichen Niederschlag berechnen
rainfall <- read.csv("data/rainfall.csv")
rainfall <- rainfall %>% 
  rowwise() %>% 
  mutate(annual = sum(sep:may)) 

# Beispiel wie es in Base R aussehen würde:
#m = c("sep", "oct", "nov", "dec", "jan", "feb", "mar", "apr", "may")
#rainfall$annual = apply(rainfall[, m], 1, sum)  

# CSV in räumliches Format übersetzen:
rainfall <- st_as_sf(rainfall, coords = c("x_utm", "y_utm"), crs = 32636)

# Israels Grenzen zum clippen einlesen:
borders <- st_read("data/israel_borders.shp")
grid <- st_as_sfc(st_bbox(rainfall))
grid <- st_as_stars(grid, dx = 1000, dy = 1000)
grid <- grid[borders]

# Inverse Distance Weighting:
rainfall_idw <- idw(annual ~ 1, rainfall, newdata=grid, idp=2.0)
plot(rainfall_idw)


# Ordinary Kriging:
v_emp_ok = variogram(annual ~ 1, rainfall)
plot(v_emp_ok)


v_mod_ok <- autofitVariogram(annual ~ 1, as(rainfall, "Spatial"))
plot(v_mod_ok)

g <- gstat(formula = annual ~ 1, model = v_mod_ok$var_model, data = rainfall)
z <- predict(g, grid)

z <- z["var1.pred",,]
names(z) <- "annual"

b <- seq(0, 1200, 100)
plot(z, breaks = b, col = hcl.colors(length(b)-1, "Spectral"), reset = FALSE)
plot(st_geometry(rainfall), pch = 3, add = TRUE)
contour(z, breaks = b, add = TRUE)

# exkurs map

months <- c("sep", "oct", "nov", "dec", "jan", "feb", "mar", "apr", "may")

tic()
monthly_interpolation <- map(months, function(i){
  f <- as.formula(paste0(i, " ~ 1"))
  v <- autofitVariogram(f, as(rainfall, "Spatial"))
  g <- gstat(formula = f, model = v$var_model, data = rainfall)
  z <- predict(g, grid)
  z <- z["var1.pred",,]
})
toc()
monthly_interpolation$along = 3

result <- do.call(c, monthly_interpolation)
plot(result, breaks = "equal", col = hcl.colors(11, "Spectral"), key.pos = 4)