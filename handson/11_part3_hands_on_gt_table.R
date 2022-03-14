# Hands-on: Erstellen von Tabellen mit GT 
library(gt)
library(dplyr)
library(ggplot2)
library(cowplot)
library(patchwork)


# 1. Tabelle erstellen ----------------------------------------------------
tab_1 <- mpg %>%
  gt()
tab_1

#   1.1 Vorschaufunktion ----------------------------------------------------

mpg %>%
  select(model, drv, cty) %>%
  gt_preview()

# 2. Tabellenkopf hinzufügen ---------------------------------------------

# Titel und Untertitel als character
mpg %>%
  select(model, drv, displ) %>%
  slice(1:5) %>%
  gt() %>%
  tab_header(
    title = "Data listing from mpg",
    subtitle = "mpg is an R dataset"
  )

# Titel und Untertitel als markdown

mpg %>%
  select(model, drv, displ) %>%
  slice(1:5) %>%
  gt() %>%
  tab_header(
    title = md("Data listing from **mpg**"),
    subtitle = md("`mpg` is an R dataset")
  )

#   2.1 Tabellenfooter hinzufügen -------------------------------------------

mpg %>%
  select(model, drv, displ) %>%
  slice(1:5) %>%
  gt() %>%
  tab_header(
    title = md("Data listing from **mpg**"),
    subtitle = md("`mpg` is an R dataset")
  ) %>% 
  tab_source_note(
    source_note = md("Reference: EPA fuel economy data (1999-2008)")
  )

#   2.2 Fußnote einfügen ----------------------------------------------------

mpg %>%
  select(model, drv, displ) %>%
  slice(1:5) %>%
  gt() %>%
  tab_header(
    title = md("Data listing from **mpg**"),
    subtitle = md("`mpg` is an R dataset")
  ) %>% 
  tab_source_note(
    source_note = md("Reference: EPA fuel economy data (1999-2008)")
  ) %>%
  tab_footnote(
    footnote = "Hubraum in Liter",
    locations = cells_column_labels(
      columns = vars(drv))
  )

#   2.3 Spanner hinzufügen ---------------------------------------------------------------------

gtcars %>%
  select(
    -mfr, -trim, bdy_style, drivetrain,
    -drivetrain, -trsmn, -ctry_origin
  ) %>%
  slice(1:8) %>%
  gt() %>%
  tab_spanner(
    label = "performance",
    columns = vars(
      hp, hp_rpm, trq, trq_rpm,
      mpg_c, mpg_h)
  )

# 2.4 group_by() + Delimited spanner hinzufügen

iris %>%
  group_by(Species) %>%
  slice(1:4) %>%
  gt() %>%
  tab_spanner_delim(delim = ".")

#   2.5 Reihengruppierung ---------------------------------------------------

gtcars %>%
  select(model, year, hp, trq) %>%
  slice(1:8) %>%
  gt() %>%
  tab_row_group(
    group = "powerful",
    rows = hp <= 600
  ) %>%
  tab_row_group(
    group = "super powerful",
    rows = hp > 600
  )

#   2.6 Stubhead Überschrift ------------------------------------------------

# gt(rowname_col)
# The column name in the input data table to use as row captions to be placed in the display table stub.

gtcars %>%
  select(model, year, hp, trq) %>%
  slice(1:5) %>%
  gt(rowname_col = "model") %>% # rowname_col = "model"
  tab_stubhead(label = "car")


#   2.7 Tabelle stylen ------------------------------------------------------

mpg %>%
  select(model, drv, displ,cty) %>%
  slice(1:8) %>%
  gt() %>%
  tab_header(
    title = md("Data listing from **mpg**"),
    subtitle = md("`mpg` is an R dataset")
  ) %>% 
  tab_source_note(
    source_note = md("Reference: EPA fuel economy data (1999-2008)")
  ) %>%
  tab_footnote(
    footnote = "Hubraum in Liter",
    locations = cells_column_labels(
      columns = vars(displ))
  ) %>% 
  tab_style(
    style = list(
      cell_fill(color = "#8856a7"),
      cell_text(weight = "bold")
    ),
    locations = cells_body(
      columns = vars(displ),
      rows = displ > 2.0)
  ) %>%
  tab_style(
    style = list(
      cell_fill(color = "#9ebcda"),
      cell_text(style = "italic")
    ),
    locations = cells_body(
      columns = vars(cty),
      rows = cty >= 20)
  )


# 3. Formatierung ---------------------------------------------------------

#   3.1 Formatierung numerischer Werte --------------------------------------

exibble %>%
  gt() %>%
  fmt_number(
    columns = vars(num),
    decimals = 3,
    use_seps = FALSE
  )

# large number suffixing
countrypops %>%
  select(country_code_3, year, population) %>%
  filter(
    country_code_3 %in% c(
      "CHN", "IND", "USA", "PAK", "IDN")
  ) %>%
  filter(year > 1975 & year %% 5 == 0) %>%
  tidyr::pivot_wider(year, population) %>%
  arrange(desc(`2015`)) %>%
  gt(rowname_col = "country_code_3") %>%
  fmt_number(
    columns = 2:9,
    decimals = 2,
    suffixing = TRUE
  )

# scientific format
exibble %>%
  gt() %>%
  fmt_number(
    columns = vars(num),
    rows = num > 500,
    decimals = 1,
    scale_by = 1/1000,
    pattern = "{x}K" # formatting pattern, value is presented by {x}
  ) %>%
  fmt_scientific(
    columns = vars(num),
    rows = num <= 500,
    decimals = 1
  )

# format currency
exibble %>%
  gt() %>%
  fmt_currency(
    columns = vars(currency),
    currency = "EUR"
  )


#   3.2 Farbe ---------------------------------------------------------------

countrypops %>%
  filter(country_name == "Mongolia") %>%
  select(-contains("code")) %>%
  tail(10) %>%
  gt() %>%
  data_color(
    columns = vars(year),
    colors = scales::col_numeric(
      palette = c(
        "red", "orange", "green", "blue"),
      domain = c(2008, 2017))
  )

# 4. Modifizierung von Spalten -----------------------------------------------

#   4.1 Zentrierung ---------------------------------------------------------

countrypops %>%
  select(-contains("code")) %>%
  filter(country_name == "Mongolia") %>%
  tail(5) %>%
  gt() %>%
  cols_align(
    align = "center",
    columns = vars(country_name)
  )

#   4.2 Spaltenbreite -----------------------------------------------------------

countrypops %>%
  select(-contains("code")) %>%
  filter(country_name == "Mongolia") %>%
  tail(5) %>%
  gt() %>%
  cols_align(
    align = "left",
    columns = vars(population)
  ) %>% 
  cols_width(
    vars(country_name) ~ px(120),
    ends_with("r") ~ px(100),
    starts_with("pop") ~ px(120),
    TRUE ~ px(60) # alles was noch übrig bleibt
  )

#   4.4 Spaltenlabel -------------------------------------------------------

countrypops %>%
  select(-contains("code")) %>%
  filter(country_name == "Mongolia") %>%
  tail(5) %>%
  gt() %>%
  cols_align(
    align = "left",
    columns = vars(population)
  ) %>% 
  cols_width(
    vars(country_name) ~ px(120),
    ends_with("r") ~ px(100),
    starts_with("pop") ~ px(120),
    TRUE ~ px(60) # alles was noch übrig bleibt
  ) %>%
  cols_label(
    country_name = "Name",
    year = "Year",
    population = md("**Population**")
  )

#   4.5 Verschieben von Spalten ans Ende oder den Start ---------------------
 
countrypops %>%
  select(-contains("code")) %>%
  filter(country_name == "Mongolia") %>%
  tail(5) %>%
  gt() %>%
  cols_align(
    align = "left",
    columns = vars(population)
  ) %>% 
  cols_width(
    vars(country_name) ~ px(120),
    ends_with("r") ~ px(100),
    starts_with("pop") ~ px(120),
    TRUE ~ px(60) # alles was noch übrig bleibt
  ) %>%
  cols_label(
    country_name = "Name",
    year = "Year",
    population = md("**Population**")
  ) %>%
  cols_move_to_end(columns = vars(year, country_name)) # cols_move_to_end() als Gegenteil

#     4.5.1 gezieltes Verschieben von Spalten -------------------------------

countrypops %>%
  select(-contains("code")) %>%
  filter(country_name == "Mongolia") %>%
  tail(5) %>%
  gt() %>%
  cols_align(
    align = "left",
    columns = vars(population)
  ) %>% 
  cols_width(
    vars(country_name) ~ px(120),
    ends_with("r") ~ px(100),
    starts_with("pop") ~ px(120),
    TRUE ~ px(60) # alles was noch übrig bleibt
  ) %>%
  cols_label(
    country_name = "Name",
    year = "Year",
    population = md("**Population**")
  ) %>% 
  cols_move(
    columns = vars(population),
    before = vars(country_name) # alternative: before 
  )

#   4.6 Ausblenden von Spalten ----------------------------------------------

countrypops %>%
  filter(country_name == "Mongolia") %>%
  tail(5) %>%
  gt() %>%
  cols_hide(columns = vars(country_code_2, country_code_3))


#   4.7 Verbinden von Spalten -----------------------------------------------

gtcars %>%
  select(model, starts_with("mpg")) %>%
  slice(1:8) %>%
  gt() %>%
  cols_merge_range(
    col_begin = vars(mpg_c),
    col_end = vars(mpg_h)
  ) %>%
  cols_label(mpg_c = md("*MPG*"))


#     4.7.1 Verbinden von Spalten incl. Unsicherheiten ------------------------

exibble %>%
  select(currency, num) %>%
  slice(1:7) %>%
  gt() %>%
  fmt_number(
    columns = vars(num),
    decimals = 3,
    use_seps = FALSE
  ) %>%
  cols_merge_uncert(
    col_val = vars(currency),
    col_uncert = vars(num)
  ) %>%
  cols_label(currency = "value + uncert.")


# 5. Reihen hinzufügen ----------------------------------------------------

#   5.1 Gruppenweise Zusammenfassung ----------------------------------------

mpg %>% 
  filter(manufacturer == "audi") %>% 
  select(model,manufacturer, displ, cty, hwy) %>% 
  gt(rowname_col = "manufacturer", groupname_col = "model") %>% 
  summary_rows(
    groups = TRUE,
    columns = vars(displ, cty, hwy),
    fns = list(
      min = ~min(.),
      max = ~max(.),
      avg = ~mean(.)
    ),
    formatter = fmt_number,
    decimals = 1,
    use_seps = FALSE
  )


#   5.2 Komplette Zusammenfassung -------------------------------------------

mpg %>% 
  filter(manufacturer == "audi") %>% 
  select("model",manufacturer, displ, cty, hwy) %>% 
  gt(rowname_col = "manufacturer", groupname_col = "model") %>% 
  grand_summary_rows(
    columns = vars(displ, cty, hwy),
    fns = list(
      min = ~min(.),
      max = ~max(.),
      avg = ~mean(.)),
    formatter = fmt_number,
    decimals = 1,
    use_seps = FALSE
  )

# 7. Export Funktionen ----------------------------------------------------

# gtsave()
tab_1 <-
  gtcars %>%
  dplyr::select(model, year, hp, trq) %>%
  dplyr::slice(1:5) %>%
  gt(rowname_col = "model") %>%
  tab_stubhead(label = "car")

tab_1 %>% gtsave("tab_1.html")

tab_1 %>% gtsave("tab_1.pdf", path = "~")

tab_1 %>% gtsave("tab_1.png", zoom = 2.5, expand = 10)

# raw html 
tab_html <-
  gtcars %>%
  dplyr::select(mfr, model, msrp) %>%
  dplyr::slice(1:5) %>%
  gt() %>%
  tab_header(
    title = md("Data listing from **gtcars**"),
    subtitle = md("`gtcars` is an R dataset")
  ) %>%
  as_raw_html()

tab_html %>%
  substr(1, 700) %>%
  cat()

# latex file 
tab_latex <-
  gtcars %>%
  dplyr::select(mfr, model, msrp) %>%
  dplyr::slice(1:5) %>%
  gt() %>%
  tab_header(
    title = md("Data listing from **gtcars**"),
    subtitle = md("`gtcars` is an R dataset")
  ) %>%
  as_latex()

tab_latex %>%
  as.character() %>%
  cat()

summary_extracted <-
  sp500 %>%
  dplyr::filter(date >= "2015-01-05" & date <="2015-01-30") %>%
  dplyr::arrange(date) %>%
  dplyr::mutate(week = paste0("W", strftime(date, format = "%V"))) %>%
  dplyr::select(-adj_close, -volume) %>%
  gt(rowname_col = "date", groupname_col = "week") %>%
  summary_rows(
    groups = TRUE,
    columns = vars(open, high, low, close),
    fns = list(
      min = ~min(.),
      max = ~max(.),
      avg = ~mean(.)
    ),
    formatter = fmt_number,
    use_seps = FALSE
  ) %>%
  extract_summary()

summary_extracted

summary_extracted %>%
  unlist(recursive = FALSE) %>%
  dplyr::bind_rows() %>%
  gt()

p1 <- mtcars %>% 
  head(5) %>% 
  gt()

p2 <- mtcars %>% 
  head(5) %>% 
  ggplot(aes(mpg, hp)) +
    geom_point()

p1 %>%
  gtsave("p11.png")

p111 <- ggdraw() + draw_image("p11.png", scale = 0.8)

p2 / p111
