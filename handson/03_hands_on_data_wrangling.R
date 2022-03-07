# Hhands-on: Data wrangling mit dplyr
# Ziel: kennenlernen der wichtigsten dplyr Funktionen zum bearbeiten von Datensätzen

library(tidyverse)
library(nycflights13) # enthält den datensatz

# 1. Datensatz ------------------------------------------------------------

# Der Datensatz beinhaltet alle 336776 Flüge vom Flughafen New York City in 2013 
# (source:US Bureau of Transportation Statistics )

flights 

# 2. filter() -------------------------------------------------------------

# vergleich von konkreten Werten oder Namen  

# Vergleichsoperatoren >, >=,<=, <, != , == , | , &, is.na(), between(), near()

filter(flights, month == 1, day == 1)

filter(flights, month == 11 | month == 12)

# %in% Operator in R, identifiziert ob Elemente zu einem Vektor gehören

filter(flights, month %in% c(11, 12))

# Filtern von Flügen, die unter 2 stunden delay haben bei Start oder Landung
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# Filtern zwischen zwei Werten 
filter(flights, between(arr_delay, 110, 120))

# Filtern in der Nähe eines Wertes 
filter(flights, near(air_time, 200, tol = 5))

# Filtern arrival delay größer als 200 Minuten, die Distanz darf aber 100km nicht überschreiten
filter(flights, arr_delay > 200, !distance > 100)

# 3. arrange() ------------------------------------------------------------

# Sortierung von Spalten

# Automatische aufsteigende Sortierung
arrange(flights, year, month, day)

# Absteigende Sortierung mit desc()
arrange(flights, desc(arr_delay))

# Missing values werden automatisch ans Ende sortiert
df <- tibble(x = c(5, 2, 6, 11, 700, NA))
arrange(df, x)

arrange(df, desc(x))

# 4. select() -------------------------------------------------------------

# Selektieren von spezifischen Spalten
select(flights, year, month, day)

# Selektieren von zusammenhängenden Spalten
select(flights, year:day)

# Spalten deselektieren
select(flights, -(year:day))

# Umbenennen von Spalten mit select() // neuer name = alter name
select(flights, tail_num = tailnum)

test <- select(flights, tail_num = tailnum)

# Exkurs: Umbenennen von Spalten mit rename()
rename(flights, tail_num = tailnum)

# Hilfsfunktionen für select()
select(iris, starts_with("Petal"))
select(iris, ends_with("Length"))
select(iris, contains("etal"))
select(iris, matches(".w.")) # regular expressions 

# 5. mutate() -------------------------------------------------------------

test <- mutate(flights,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)

# Beispiel: neuer datensatz erstellen mit select
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
# neue Spalten gain und speed mit mutate berechen
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

# funktioniert auch mit neu erstellen Spalten
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# 6. Gruppierte Zusammenfassungen group_by(), summarise() ----------------------------------------------------------

# Summarise über eine Spalte
summarise(flights,
          delay = mean(dep_delay, na.rm = TRUE)
)

# Erklärung: na.rm = TRUE 

summarise(flights,
          delay = mean(dep_delay, na.rm = FALSE)
)

# Sobald ein missing value im input ist wird auch der output zum missing value. 
# Alle Funktionen haben ein na.rm Argument welches missing values vor der Berechnung entfernt.

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


# 6.1 Pipe Kombinationen mit dplyr + ggplot -------------------------------

flights %>% 
  group_by(dest) %>% 
  summarise(count = n(),
            dist = mean(distance, na.rm = TRUE),
            delay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(delay, count > 20, dest != "HNL") %>% 
  ggplot(mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

mtcars %>% 
  rownames_to_column("type") %>% 
  filter(stringr::str_detect(type, 'Toyota|Mazda') )




# 7. Übungen -----------------------------------------------------------------

# a) filter()
# Wieviele Flüge mit einer Ankunftszeit über 2399 Minuten gibt es?

# b) arrange()
# Einmal den flights Datensatz nach Distanz aufsteigend und absteigend sortieren. Was ist die kürzeste bzw. längste Distanz? 

# c) select()
# Selektieren Sie alle Spalten vom typ character

# d) mutate()
# 1. Laden Sie den "mtcars" Datensatz. 
# 2. Erstellen Sie eine neue Variable "km_pro_liter" mit Hilfe der mutate() Funktion. Tip: 1mpg = 0.425 km/l

# e) group_by(), summarise()
# Finden Sie heraus welcher Startflughafen im Schnitt die größte Verspätung beim Start hat



#  7.1 Lösungen ----------------------------------------------------------------

# a)

flights %>% 
  filter(arr_time > 2399) %>% 
  count()

# b)

flights %>% 
  select(distance) %>% 
  arrange(distance)

flights %>% 
  select(distance) %>% 
  arrange(desc(distance))

# c)

flights %>% 
  select(c("carrier", "tailnum", "origin", "dest"))

# alternative
flights %>% 
  select_if(is.character)
  
# d)
mtcars %>% 
  mutate(
    km_per_litre = 0.425 * mpg
  )

# e)
flights %>% 
  group_by(origin) %>% 
  summarise(mean_delay = mean(dep_delay, na.rm = TRUE))