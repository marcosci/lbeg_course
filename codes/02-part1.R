####
# Lernziele:
# 1. Begriffe verstehen wie: object, assign, call, function, arguments
# 2. Wie man Werte Objekten zuweist
# 3. Wie man Objekte benennt
# 4. Kommentare sinnvoll nutzt
# 5. Wie man Funktionen nutzt und deren Standardeinstellungen ändert.
# 6. Wie man Vektoren erzeugt, indiziert und manipuliert.
# 7. Wie man mit fehlenden Werten (NA) umgeht. 
# 8. Tibbles erzeugen, indizieren und manipulieren.
# 9. Listen erzeugen, indizieren und manipulieren.

### Einstieg ----

## Man kann mit R Output generieren, indem man die Konsole als Taschenrechner nutzt ----
3 + 5
12 / 7

## Um etwas sinnvolleres zu machen, müssen wir Werte Objekten zuweisen ----
soil_depth <- 73
soil_depth

# Tastenkobination für Zuweisungsoperator: Alt + - 

## R printet bei einer Zuweisung nichts in die Konsole, das kann umgangen werden mit: ----
(soil_depth <- 73)

## Jetzt, da wir die Bodentiefe in cm im Zwischenspeicher haben, können wir damit rechnen: ----
soil_depth * 0.5

# Achtung: Da wir die Operation nicht dem Objekt zuordnen, ist der Effekt der Berechnung nur temporär:
soil_depth

## Um das Ergebnis zu speichen, müssen wir das Objekt selbst zwischenspeichern: ----
halbierte_tiefe <- soil_depth * 0.5

## Kommentare werden als # gekennzeichnet ----

# Die Einheit der Bodentiefe ist cm
boden_tiefe <- 73

# ... vs:
boden_tiefe <- 73 # Einheit: cm

# Tastenkombination für das Einfügen von Kommentaren am Zeilenanfang Ctrl + Shift + C:
boden_tiefe <- 73

# ... funktioniert auch, wenn man mehrere Zeilen markiert:
boden_tiefe <- 73
boden_ph    <- 3
boden_nässe <- 44

## Funktionen nehmen in R Argumente entgegen, um Berechnungen durchzuführen ----
# Siehe eine Liste an oft genutzten Funktionen am Ende dieses Skripts

# Funktionen können einzelne Zahlen als Argumente nehmen:
round(3.14159)

# ... sie können Objekte als Argumente nehmen:
test_zahl <- 3.14159
round(test_zahl)

# ... Oft haben Funktionen mehrere Argumente, diese finden wir mit:
args(round)
?round # Das sollte die präferierte Option sein, da wesentlich detaillierter (F1 ist der Shortcut für die Hilfe)

# ... also nutzen wir das zweite Argument:
round(3.14159, digits = 2)

# Wie könnt ihr euch folgendes erklären? 
round(digits = 2, x = 3.14159)
round(2, 3.14159)

### Vektoren ---

## Vektoren erzeugen wir in R mit der combine (c) Funktion ----
soil_depth <- c(73, 38, 8, 56)

# Vektoren können ganz verschiedene Datentypen speichern:
soil_depth <- c("dreiundsiebzig",
                "achtunddreißig",
                "acht",
                "sechsundfünzig")

# Was ist an der folgenden Zeile ein eventuelles Problem?
soil_depth <- c("dreiundsiebzig", 73)
class(soil_depth)

# ... vergleiche mit:
soil_depth <- c(73, 73)
class(soil_depth)

# In R nennt sich dieses Feature class coercion - gerne googlen, passiert sehr häufig auch unwissentlich in R.

# Einmal laufen lassen, dann testen, wie R die verschiedenen Datentypen hier "coerced":
c(1, FALSE)
c("a", 1)
c(TRUE, 1L)

# Wir können Vektoren mit c() auch beliebig erweitern:
(soil_depth <- c(soil_depth, 89))

## Nützliche Funktionen um Vektoren zu untersuchen sind:
soil_depth <- c(73, 38, 8, 56)

length(soil_depth)
class(soil_depth)
typeof(soil_depth)
str(soil_depth)
summary(soil_depth)

## Vektor subsetting ----
land_bedeckung <- c("brach", "see", "feld", "wald")

land_bedeckung[2]
land_bedeckung[2:3]
land_bedeckung[c(2,3)]

land_bedeckung[4:3] # Die Vektorerzeugung mit : erzeugt ebenfalls rückwärtslaufende Sequenzen
land_bedeckung[c(4,2,1,3,4,2,3,1)] # wir können auch mehrere Elemente wiederholen

land_bedeckung[c(FALSE, FALSE, TRUE, FALSE)] # conditional subsetting

# Unser Bodentiefevektor soll nun gefiltert werden nach Werten, die kleiner als 50 sind:
soil_depth 
soil_depth < 50
soil_depth[soil_depth < 50]
# ... das dürfte in etwa die Variante sein, wie man sie wohl am meisten in R nutzen wird.
# Gerne hier also auch mit den folgenden Operatoren ausprobieren!

## Kurzer Exkurs in die Operatoren von R: ----

# Relationelle Operatoren:
#  <:	Less than
#  >:	Greater than
# <=:	Less than or equal to
# >=:	Greater than or equal to
# ==:	Equal to
# !=:	Not equal to

# Logische Operatoren:
#  !:	Logical NOT
#  &:	Element-wise logical AND
# &&:	Logical AND
#  |:	Element-wise logical OR
# ||:	Logical OR

# Warum evaluiert folgende Zeile zu TRUE?
"vier" > "fünf"

### Fehlende Werte ----
## Fehlende Werte in R werden als NA repräsentiert.
soil_depth <- c(2, 4, 4, NA, 6)
mean(soil_depth)
max(soil_depth)
mean(soil_depth, na.rm = TRUE)
max(soil_depth, na.rm = TRUE)

## Erzeuge ein Subset, mit den Werten die NICHT NA sind ----
soil_depth[!is.na(soil_depth)]

## Verwerfe die NA in unserem Bodentiefevektor
na.omit(soil_depth)

## Erzeuge einen logischen Vektor, in denen NA als FALSE deklariert wird.
complete.cases(soil_depth)
soil_depth[complete.cases(soil_depth)] #kann wie gewohnt sehr gut zum subsetten genutzt werden

### Data frames ----

# Wir laden unseren wnv Datensatz und machen uns direkt die Vorteile von tibbles zu nutze
library(epitools)
library(tidyverse)
data(wnv)
head(wnv)
(wnv <- as_tibble(wnv))

## Nutzen wir direkt einmal RStudios integrierten Data frame Viewer: ----
View(wnv)

## Wenn wir einen tibble printen sehen wir die Datentypen der Spalten zwar bereits,
## aber mit str() können wir das auch für künftige Programmieraufgaben lösen:
str(wnv)

## Untersuchen wir unseren Data frame: ----

# Größe:
dim(wnv)
?dim

nrow(wnv)
?nrow

ncol(wnv)
?ncol

# Inhalt:
head(wnv)
tibble::glimpse(wnv)
tail(wnv)
skimr::skim(wnv)

# Namen:
names(wnv)
rownames(wnv)

## Subsetting von Data frames ----

# ... das erste Element in der ersten Spalte und der ersten Reihe:
wnv[1, 1]   

# ... in der ersten Reihe und der vierten Spalte:
wnv[1, 6]   

# ... die erste Spalte des Data frames: 
wnv[, 1]    

# ... die ersten drei Reihen der siebten Spalte:
wnv[1:3, 7] 

# ... die komplette dritte Reihe:
wnv[3, ]    

# Man kann dataframes/tibbles auch mit dem $ subsetten
wnv$syndrome

# RStudio hilft, indem es die Spaltennamen in einem Drilldownmenü anzeigt
# Hier einmal wnv$ eintippen:
 

### Listen ----
## Listen werden in R mit list() erzeugt ----
x <- list(1:3,                       # erstes Listenelement
          "a",                       # zweites Listenelement
          c(TRUE, FALSE, TRUE),      # drittes Listenelement
          c(2.3, 5.9))               # viertes Listenelement

# Mit der str() Funktion können wir uns unsere Liste anschauen und deren Struktur verstehen:
str(x)

## Listen können in R auch rekursiv sein:
x <- list(list(list(list())))
str(x)

# hatten wir Recht?
is.recursive(x)

## R coerced auch Datenstrukturen - hier zum Beispiel den Vektor zu einer Liste, um die Datentypen in einer Liste zu vereinen:
x <- list(list(1, 2), c(3, 4))
y <- c(list(1, 2), c(3, 4))
str(x)
str(y)

## Listen Subsetting ----
x <- list(1:3, list("a", "b"), c(TRUE, FALSE, TRUE), c(2.3, 5.9))               

# Wie von den Vektoren und tibbles bekannt mit Square Brackets:
x[1]
x[3]

# ... wir können bei Vektoren aber noch tiefer subsetten:
x[[1]]

# Was ist der Unterschied zwischen x[1] und x[[1]]?
# Tipp: class()

## Wir können auch noch tiefer subsetten:
x[2]

x[[2]][1]
x[[2]][2]

x[[2]][[1]]
x[[2]][[2]]

# Regel: x[ntes listenelement][nter subset auf jeweilige struktur in liste]

## Listenelement Namen:
names(x) <- c("Monat",
              "Matrix", 
              "Misc",
              "Gewicht")

# Subsetting funktioniert nun auch über den $ Operator:
x$Monat

## Element an Liste anhängen:
x[5] <- "ich bin neu"
str(x)

# Kennt ihr noch einen weiteren Weg, um ein Element der Liste hinzuzufügen? (Tipp: Ein wenig hochscrollen.)

## Mit der gleichen Methode kann man Elemente aus der Liste löschen:
x[5] <- NULL
str(x)

## Oder Listenelemente updaten:
x[3] <- "updated"
str(x)


### R Vokabular zum Eingewöhnen ----

# Wichtige Operatoren
%in%, match
$, [, [[, head, tail
        
# Variablen vergleichen 
all.equal, identical
!=, ==, >, >=, <, <=
  is.na, complete.cases
is.finite

# Grundlegende Mathematik
*, +, -, /, ^, %%, %/%
abs, sign
acos, asin, atan, atan2
sin, cos, tan
ceiling, floor, round, trunc, signif
exp, log, log10, log2, sqrt

max, min, prod, sum
cummax, cummin, cumprod, cumsum, diff
pmax, pmin
range
mean, median, cor, sd, var

# Logicals & sets 
&, |, !, xor
all, any
intersect, union, setdiff, setequal
which

# Vektoren
c
# automatic coercion rules character > numeric > logical
length, dim, ncol, nrow
cbind, rbind
names, colnames, rownames
t
diag
sweep
as.matrix, data.matrix

# Vektoren erstellen
c
rep, rep_len
seq, seq_len, seq_along
rev
sample
choose, factorial, combn
(is/as).(character/numeric/logical/...)

# Listen & data.frames 
list, unlist
tibble, as.tibble
expand.grid

# Kontrollstrukturen
if, &&, || 
for, while
next, break
ifelse