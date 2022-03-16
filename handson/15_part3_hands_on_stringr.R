library(stringr)

# Wie lange ist meine Zeichenkette?
str_length("abc")

# Vektorisiert
x <- c("abcdef", "ghifjk")
str_length(x)

# Was ist das 3. Element?
str_sub(x, 3, 3)

# Das zweite bis Vorletzte Element
str_sub(x, 2, -2)


# Mit stringr können wir Zeichenketten auch direkt verändern:
str_sub(x, 3, 3) <- "X"
x

# Leerzeichen einfügen:
x <- c("abc", "defghi")
str_pad(x, 10)

# Pad macht Zeichenketten niemals kürzer:
x <- c("Short", "This is a long string")

x %>% 
  str_trunc(10) %>% 
  str_pad(10, "right")

# Das Gegenteil zu Pad:
x <- c("  a   ", "b   ",  "   c")
str_trim(x)

# Wir können Zeichenketten auch sortieren:
x <- c("y", "i", "k")
str_order(x)


# Wie oft kommt ein Zeichen vor?
str_count(x, "y")
#lengths(regmatches(x, gregexpr("y", x)))

# Pattern Matching:
my_string <- "xxxx10yyyy"
my_expression <- "[0-9]+"
str_locate(my_string, my_expression)
str_extract(my_string, my_expression)

my_expression <- "10"
str_locate(my_string, my_expression)
str_extract(my_string, my_expression)
