####
# Einstieg Kontrollstrukturen
#### 

### Kurzer Exkurs: Eigene Funktionen ----
add_ten <- function(input, input2) {
  output <- input + 10
  return(output)
}

add_ten(0)
add_ten(10)

### For Schleifen Iteration ----
jahr      <- c(1950, 1951, 1952)
torftiefe <- c(50, 30, 70)

add_ten(x[1])
add_ten(x[2])
add_ten(x[3])

torf_results <- c()

for(zeitpunkt in seq_along(jahr)){
  torf_results[zeitpunkt] <- minus_ten(torftiefe[zeitpunkt])
}

torf_results
x

### purrr Iteration ----
library(tidyverse)
map_dbl(.x = c(1, 4, 7), 
        .f = add_ten)

# Glücklicherweise müssen wir nicht alles ausschreiben:
library(terra)

raster_index <- seq_len(nlyr(multi_rast))

raster_mean <- map_dbl(raster_index, function(index){
  
  raster <- multi_rast[[index]]
  raster_values <- values(raster)
  mean(raster_values)
  
})

# Egal welche Datenstruktur wir map übergeben, wir bekommen eine Liste zurück:
map_dbl(list(1, 4, 7), add_ten)
map(data.frame(a = 1, b = 4, c = 7), add_ten)

## purrr erlaubt den Rückgabewert selbst zu bestimmen:
map_dbl(c(1, 4, 7), add_ten) # map to a double
map_chr(c(1, 4, 7), add_ten) # map to a character

## Wir können auch einen tibble mit den alten und neuen Werten erzeugen:
map_df(c(1, 4, 7), function(x) {
  return(tibble(old_number = x, 
                new_number = add_ten(x)))
})

## tilde-dot Abkürzung für Funktionen:
map_dbl(c(1, 4, 7), ~{.x + 10})

# wir erstzen:
function(x) {
  x + 10
}

# mit:
~{.x + 10}

####
# Recap Listen & Praktische Beispiele mit purrr
#### 
library(repurrrsive)

# Wie viele Leute sind in unserem Datensatz?
length(sw_people)

# Wer ist die erste Person?
sw_people[[1]]  # Luke!

# Eine Liste in einer Liste ...
sw_people[1]

# Auf wie vielen Schiffen war jeder der Charaktere?
map(sw_people, ~ length(.x$starships))

