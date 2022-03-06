# Hands-on RStudio

# Pakete installieren
install.packages("sf")
install.packages("spData")

# Mit Strg + Enter können Zeilen aus dem Editor
# in der Konsole evaluiert werden
print("Hallo LBEG")

# Bitte das epitools Paket laden
library(spData)
data(world)

# Die Hilfe nutzen
?spData::world
?sf::st_read

# Ein paar Vorschläge, um RStudio kennenzulernen:
# - Einmal im Environment Tab auf die Variable world klicken
# - Pakete Tab finden und Autoverstollständing testen
# - Unter Hilfe finden sich Cheatsheets
# - In den Einstellungen Look & Feel von RStudio personalisieren
# - Einmal vier Gedankenstriche (-) hinter ein Kommentar  machen und die Veränderung in der IDE beobachten


# Der erste Plot
library(tidyverse)
View(mpg)
ggplot(mpg, aes(x = displ,
                y = hwy, 
                colour = class)) + 
  geom_point() +
  theme_minimal()

# Den Viewer kennenlernen
library(mapview)
library(sf)

franconia %>%
  mutate(count = lengths(st_contains(., breweries)),
         density = count / st_area(.)) %>%
  mapview(zcol = "density", legend = FALSE)