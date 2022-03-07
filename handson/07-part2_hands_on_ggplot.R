# Ziele:
# Kennenlernen der basic geoms: point, line, bar/col
# Durchführen einer explorativen Datenvisualisierung

# Tidyverse laden
library(tidyverse)

# Beispieldatensätze laden
data(mpg)
data(economics)

# 1. Data -----------------------------------------------------------------

# Plot outline
ggplot(data = mpg, mapping = aes(x = displ, y = hwy))

# vereinfachte schreibweise
ggplot(mpg, aes(displ, hwy))

# alternative schreibweise
p <- ggplot(mpg, aes(displ, hwy))
p

# 2. Layers ---------------------------------------------------------------

# 2.1 Geoms ---------------------------------------------------------------

# geom_point Scatterplots
ggplot(mpg, aes(displ, hwy)) + 
  geom_point()

# geom_line.. sinnvoll?
ggplot(mpg, aes(displ, hwy)) + 
  geom_line()

# geom_line
ggplot(economics, aes(date, unemploy)) + 
  geom_line()

# geom_bar() setzt die Höhe der Balken proportional zur Anzahl der Fälle in jeder Gruppe.
ggplot(mpg, aes(displ, hwy)) + 
  geom_bar()

# Balkendiagramm mit der Klasse auf der x-Achse 
ggplot(mpg) +
  geom_bar(aes(x = class))

# Darstellung der Qualität (cut) des diamond Datensatzes als Balkendiagramm
ggplot(diamonds) + 
  geom_bar(aes(x = cut))

# Soll die Höhe der Balken durch Daten auf der y-Achse repräsentiert werden kann man stat = "identity" oder geom_col() benutzen.

# geom_bar funktioniert ein bisschen anders als zunächst erwartet
ggplot(mpg, aes(class, hwy)) + 
  geom_bar()

# Mit stat = "identity" überschreiben wir den default stat = "count" von geom_bar
ggplot(mpg) + 
  geom_bar(aes(x = class, y = hwy), stat = 'identity')

# geom_col benutzt stat = "identity" als default 
ggplot(mpg, aes(class, hwy)) + 
  geom_col()

# geom_boxplot
ggplot(mpg, aes(class, hwy))+
  geom_boxplot()

# geom_area
ggplot(economics, aes(date, unemploy)) + 
  geom_area()

# 2.2 Calculated aesthetics ---------------------------------------------------------------

# Größtenteils werden die Daten direkt an aesthetics gebunden und dargestellt. Alternativ kann man aber auch 
# Variablen aus den bestehenden Daten berechenen und darstellen. 

# stat_smooth() // e.g. "auto", "lm", "glm", "gam", "loess"
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  stat_smooth()

# stat_smooth (method = "lm")
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  stat_smooth(method = "lm")

# stat_summary()
# Summarise y values at unique/binned x

ggplot(mpg, aes(drv, hwy)) +
  geom_point() +
  stat_summary(fun = "median",
               colour = "red",
               size = 3,
               geom = "point")

# geom_boxplot + stat_summary
ggplot(mpg, aes(drv, hwy)) +
  geom_boxplot() +
  stat_summary(fun = "mean",
               colour = "red",
               size = 3,
               geom = "point")


# stat_function
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
  stat_function(fun = dnorm, geom = "line")

# geom_density + stat_function
ggplot(data.frame(x = rnorm(100)), aes(x)) +
  geom_density() +
  stat_function(fun = dnorm, colour = "red")

# mehrere Funktionen in einem PLot
ggplot(data.frame(x = c(-5, 5)), aes(x)) +
  stat_function(fun = dnorm, colour = "red") +
  stat_function(fun = dt, colour = "blue", args = list(df = 1))

# Eigene Funktionen
cubeFun <- function(x) {
  x^3 * 0.5
}

ggplot(data.frame(x = c(-4, 4)), aes(x = x)) +
  stat_function(fun = cubeFun)

  
# 3. Aesthetics --------------------------------------------------------------

# Feste Werte für size und alpha ausserhalb der Daten
ggplot(mpg, aes(displ, hwy)) +
  geom_point(size= 8, alpha = 1)

# Alpha innerhalb der der Daten 
ggplot(mpg, aes(displ, hwy, alpha = class)) + 
  geom_point()

# Formen
ggplot(mpg, aes(displ, hwy, shape = class)) + 
  geom_point(size = 3)

ggplot(mpg, aes(displ, hwy, shape = class)) + 
  geom_point(size = 6)

# Farbe pro Klasse
ggplot(mpg, aes(displ, hwy, color = class)) + 
  geom_point(size = 6)

# Farbe für alle Daten
ggplot(mpg, aes(displ, hwy, color = "red")) + 
  geom_point(size = 6)

# multi aesthetics
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class, 
                 shape = drv),
             size= 4,
             alpha = 0.8) +
  geom_smooth(aes(col=class), method="lm", se=F)


# Linetypes
# 0 = blank, 1 = solid, 2 = dashed, 3 = dotted, 4 = dotdash, 5 = longdash, 6 = twodash

ggplot(economics, aes(date, unemploy)) + 
  geom_line(linetype = "dotdash")


# geom_col modifikationen
# width // alpha // colour // fill // group // linetype // size // 

ggplot(mpg, aes(class, hwy)) + 
  geom_col(width = .8)


# Multiple geoms in einem Plot --------------------------------------------
ggplot(mpg, aes(displ, hwy)) + 
  geom_line() +
  geom_point()

# Reihenfolge der Geoms ist wichtig
ggplot(mpg, aes(displ, hwy)) + 
  geom_line(size=2) +
  geom_point(color="red", size = 6)

ggplot(mpg, aes(displ, hwy)) + 
  geom_point(color="red", size = 6) +
  geom_line(size=2)


# Plots in Collage einbetten ----------------------------------------------
library(patchwork)

p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))

p1 + p2

p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

p1 + p2 + p3 + p4

p1 + p2 + p3 + p4 + plot_annotation(tag_levels = 'A')


(p1 | p2 | p3) /
  p4