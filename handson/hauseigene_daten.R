# Tobias ----
library(readxl)
library(dplyr)
monatlich_A_2004_2011 <- read_excel("~/Downloads/monatlich_A_2004_2011.xlsx")
View(monatlich_A_2004_2011)

monatlich_A_2004_2011 %>%
  select(-ID) %>%
  pivot_wider(names_from = Curve, values_from = Y) %>% 
  View()

# Robin ----
library(sf)
library(terra)
library(exactextractr)
library(ggplot2)
library(classInt)

bkfifty_poly <- st_read("~/Downloads/Versiegelungsdaten/BK50_Polygone.shp")
cop_hannover <- rast("~/Downloads/Versiegelungsdaten/Copernicus_VersGrad_2018_extract_Hannover.tif")

bkfifty_poly$mean_versiegelung <- exact_extract(cop_hannover, bkfifty_poly, 'mean')

breaks <- classIntervals(bkfifty_poly$mean_versiegelung, n=10, style="fixed",
               fixedBreaks=c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100))

bkfifty_poly$versiegelung_class <- cut(bkfifty_poly$mean_versiegelung, data.frame(breaks[2])[,1])
bkfifty_poly<-bkfifty_poly[complete.cases(bkfifty_poly$versiegelung_class),]

ggplot(bkfifty_poly, aes(fill = versiegelung_class), lwd = 0) +
  geom_sf(size = 0.03) +
  scale_fill_brewer(palette = "Pastel1",
                     name = "% Versiegelung") +
  #scale_fill_viridis_d(option = "E", na.value="transparent") +
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
verschlämmung <- read_excel("~/Downloads/Marco/Sachdaten_Verschlämmung.xlsx")
View(verschlämmung)
names(verschlämmung)
peine <- st_read("~/Downloads/Marco/BK50_Peine.shp")

peine_verschlämmung <- left_join(peine, verschlämmung, by = c("OBJECTID" = "FL_NR"))

ggplot(peine_verschlämmung, aes(fill = OTIEF)) +
  geom_sf(size = 0.03) +
  scale_fill_viridis_c(option = "E", na.value="transparent") +
  coord_sf(crs = "EPSG:4326") +
  theme_minimal()
