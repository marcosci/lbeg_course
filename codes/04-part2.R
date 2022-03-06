library(sf)
pnt1 <- st_point(c(51.80423475315072, 10.333205574817187))

pnt1

class(pnt1)

a <- st_polygon(list(cbind(c(0,0,7.5,7.5,0),c(0,-1,-1,0,0))))

class(a)

plot(a, border = "blue", col = "#0000FF33", lwd = 2)

b <- st_polygon(list(cbind(c(0,1,2,3,4,5,6,7,7,0),c(1,0,0.5,0,0,0.5,-0.5,-0.5,1,1))))

class(b)

plot(b, border = "red", col = "#FF000033", lwd = 2)

ab <- c(a,b)
ab
plot(ab, border = "darkgreen", col = "#00FF0033", lwd = 2)

i <- st_intersection(a, b)
i
class(i)

plot(i, border = "black", col = "darkgrey", lwd = 2)


# sfc - Geometrie Spalte

pnt2 <- st_point(c(51.804957872859994, 10.333688372401111))
pnt3 <- st_point(c(48.01435815079368, 7.844758252372815))

geom <- st_sfc(pnt1, pnt2, pnt3, crs = 4326)


geom 


name = c("LBEG Hannover", "Bäckerei Biel", "Marcos Büro")
city = c("Hannover", "Hannover", "Dimona")
lines = c(4, 5, 1)
piano = c(FALSE, TRUE, FALSE)
dat = data.frame(name, city, lines, piano)
dat