# Bundeswahlleiterin
# Seminar session: 2024-11-14
# ==============================================================================

# Source: https://www.bundeswahlleiterin.de/bundestagswahlen/2021/ergebnisse/opendata.html 

library(dplyr)
library(readr)

# Import results from Bundeswahlleiter ------------------------------------

bwl_results_raw <- read_csv2("data_raw/bwl_btw_2021/kerg.csv", 
                             skip = 5,
                             col_names = FALSE)

bwl_results <- bwl_results_raw %>%
  select(district_num = X1,
         district_name = X2,
         state = X3,
         n_eligible = X4,
         voters = X8) %>%
  filter(!is.na(state) & state != 99) %>%
  mutate(turnout = (voters / n_eligible) * 100,
         district_num = as.numeric(district_num),
         state = as.numeric(state),
         state = case_when(state == 1 ~ "SH",
                           state == 2 ~ "HH",
                           state == 3 ~ "NI",
                           state == 4 ~ "HB",
                           state == 5 ~ "NW",
                           state == 6 ~ "HE",
                           state == 7 ~ "RP",
                           state == 8 ~ "BW",
                           state == 9 ~ "BY",
                           state == 10 ~ "SL",
                           state == 11 ~ "BE",
                           state == 12 ~ "BB",
                           state == 13 ~ "MV",
                           state == 14 ~ "SN",
                           state == 15 ~ "ST",
                           state == 16 ~ "TH"),
         state = factor(state),
         region = case_when(state == "BE" ~ "Berlin",
                            state %in% c("BB", "MV", "SN", "ST", "TH") ~ "East",
                            TRUE ~ "West"),
         region = factor(region, levels = c("West", "East", "Berlin"))) %>%
  select(state,
         region,
         district_num,
         district_name,
         turnout)


# Import structure data ---------------------------------------------------

bwl_str_raw <- read_csv2("data_raw/bwl_btw_2021/btw21_strukturdaten.csv", 
                             skip = 8)

bwl_str <- bwl_str_raw %>%
  select(district_num = `Wahlkreis-Nr.`,
         gdp = `Bruttoinlandsprodukt 2018 (EUR je EW)`,
         income = `Verfügbares Einkommen der privaten Haushalte 2018 (EUR je EW)`,
         unemp = `Arbeitslosenquote Februar 2021 - insgesamt`) %>%
  mutate(district_num = as.numeric(district_num),
         gdp = gdp / 1000,
         income = income / 1000)
  

# Merge data --------------------------------------------------------------

bwl <- bwl_results %>%
  left_join(bwl_str)


# Add variable labels -----------------------------------------------------

attr(bwl$state, "label") <- "Federal state"
attr(bwl$region, "label") <- "Region"
attr(bwl$district_num, "label") <- "Electoral district number"
attr(bwl$district_name, "label") <- "Electoral district name"
attr(bwl$turnout, "label") <- "Voter turnout"
attr(bwl$gdp, "label") <- "GDP per capita 2018 (x1000 EUR)"
attr(bwl$income, "label") <- "Available household income (x1000 EUR)"
attr(bwl$unemp, "label") <- "Unemployment rate Feb 2021"

# Save data ---------------------------------------------------------------

saveRDS(bwl, file = "data/2024-11-14_bwl.rds")
