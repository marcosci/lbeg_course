# Tobias ----
library(readxl)
library(dplyr)
library(ggplot2)
monatlich_A_2004_2011 <- read_excel("data/monatlich_A_2004_2011.xlsx")
View(monatlich_A_2004_2011)

monatlich_A_2004_2011 %>%
  select(-ID) %>%
  pivot_wider(names_from = Curve, values_from = Y)

monatlich_A_2004_2011 %>% 
  filter(Curve %in% c(2312430, 3110350)) %>% 
  ggplot(aes(X, Y)) +
   geom_point() +
   facet_wrap(vars(Curve))

# Robin ----
library(sf)
library(terra)
library(exactextractr)
library(ggplot2)
library(classInt)

bkfifty_poly <- st_read("data/BK50_Polygone.shp")
cop_hannover <- rast("data/Copernicus_VersGrad_2018_extract_Hannover.tif")
# plot(cop_hannover)

bkfifty_poly$mean_versiegelung <- exact_extract(cop_hannover, bkfifty_poly, 'mean')

breaks <- classIntervals(bkfifty_poly$mean_versiegelung, n=10, style="fixed",
                fixedBreaks=c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100))
 
bkfifty_poly$versiegelung_class <- cut(bkfifty_poly$mean_versiegelung, data.frame(breaks[2])[,1])
bkfifty_poly<-bkfifty_poly[complete.cases(bkfifty_poly$versiegelung_class),]

ggplot(bkfifty_poly, aes(fill = mean_versiegelung), lwd = 0) +
  geom_sf(size = 0.03) +
  #scale_fill_brewer(palette = "Pastel1",
  #                   name = "% Versiegelung") +
  scale_fill_viridis_c(option = "E", na.value="transparent") +
  coord_sf(crs = "EPSG:4326") +
  theme_void()

mapview::mapview(bkfifty_poly %>% select(geometry, versiegelung_class))

bkfifty_poly_union <- bkfifty_poly %>% 
  group_by(versiegelung_class) %>% 
  summarise(prozent_versiegelt = mean(mean_versiegelung))

ggplot(bkfifty_poly_union, aes(fill = versiegelung_class)) +
  geom_sf(size = 0.03) +
  scale_fill_brewer(palette = "Pastel1",
                    name = "% Versiegelung") +
  #scale_fill_viridis_d(option = "E", na.value="transparent") +
  coord_sf(crs = "EPSG:4326") +
  theme_void()

# Jan ----
library(readxl)
library(dplyr)
library(ggplot2)
verschlämmung <- read_excel("data/Sachdaten_Verschlämmung.xlsx") %>% 
  filter(OTIEF == 0)

verschla <- read_excel("data/Sachdaten_Verschlämmung.xlsx", 
                                       sheet = "VERSCHLA")

sachdaten <- left_join(verschlämmung, verschla, "HNBOD")

peine <- st_read("data/BK50_Peine.shp")

peine_verschlämmung <- left_join(peine, sachdaten, by = c("OBJECTID" = "FL_NR"))

ggplot(peine_verschlämmung, aes(fill = STUFE)) +
  geom_sf(size = 0.03) +
  scale_fill_viridis_c(option = "E", na.value="transparent") +
  coord_sf(crs = "EPSG:4326") +
  theme_minimal()


# Gabi ----
library(terra)
library(tidyverse)
bunch_of_files <- list.files("/Users/marco/Downloads/gabi/", full.names = TRUE)
qad_raster <- rast(bunch_of_files)

qad_mean <- global(qad_raster, mean, na.rm = TRUE)
qad_mean

as_tibble(qad_mean) %>% 
  mutate(row_name = row.names(qad_mean),
         year = str_sub(row_name, 4, 7),
         group = str_sub(row_name, 8)) %>% 
  ggplot(aes(year, mean, group = group, color = group)) +
    geom_line() +
    theme_minimal()

# Lena ----
library(readxl)
library(dplyr)
lena_df <- read_excel("data/Beispieldaten.xlsx")

lena_df %>% 
  group_by(GWK) %>% 
  select(-GRID_ID) %>% 
  summarise_all(mean, na.rm = TRUE)

# Tina ----
load("/Users/marco/Downloads/MKWDv_test.RData")
fao <- as_tibble(FAO_monthly) %>% head(10000)


regnie <- as_tibble(REGNIE_korr_monthly) %>% head(10000)

kwb <- fao %>% 
         left_join(regnie, by = "ID") %>% 
         left_join(XY_FAO_monthly)




library(sf)
plot(st_as_sf(as_tibble(XY_FAO_monthly), coords = c("XCOORD_CENTROID", "YCOORD_CENTROID")))

m <- as_tibble(XY_FAO_monthly) %>% 
        rename(x = XCOORD_CENTROID, y = YCOORD_CENTROID, z = ID) %>% 
        select(x,y,z)

r <- rast(m, type="xyz")

# So würde ich das Raster für die Datenbank aufbereiten:
landscapetools::util_raster2tibble(elevation_raster)

# Denise + Tina:
load("data/MKWDv_v3_red.RData")
MKWDv %>%
  group_by(ID, JAHR) %>%
  dplyr::mutate(kKWDm=cumsum(KWDm)) %>% 
  #mutate(month_after = (kKWDm + (lead(kKWDm))) / 2)
  group_split() %>% 
  map_dfr(function(year_id){
    year_id %>% 
      mutate(month_after = (kKWDm + (lead(kKWDm))) / 2)
  })



