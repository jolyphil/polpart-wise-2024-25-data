library(countrycode) # Convert country codes
library(dplyr) # Data transformation
library(haven) # Import Stata files
library(wbstats) # Import World Bank Data

# Load functions ---------------------------------------------------------------

# Create function to recode political participation items
# Recode items as binary (0/1)

recode_polpart <- function(var){
  newvar <- NA_real_
  newvar[var == 1] <- 1 # Done in the last year = Done
  newvar[var %in% c(2, 3, 4)] <- 0 # Other = Not done
  newvar
}

# Political participation battery in the ISSP ----------------------------------

# V17 - Q13 Political actions: sign a petition
# V18 - Q14 Political actions: boycott certain products
# V19 - Q15 Political actions: take part in a demonstration
# V20 - Q16 Political actions: attend political meeting or rally
# V21 - Q17 Political actions: contact a politician
# V22 - Q18 Political actions: donate money or raise funds
# V23 - Q19 Political actions: contact media
# V24 - Q20 Political actions: express views on the internet

# Other variables --------------------------------------------------------------

# C_ALPHAN: country code
# DATEYR: year of the survey
# WEIGHT: weight

issp_raw <- read_dta("data_raw/issp_2014/ZA6670_v2-0-0.dta") 

issp <- issp_raw |>
  mutate(
    across(.cols = V17:V24,
           .fns = recode_polpart) # Apply recode function to all pol. part. acts
  ) |>
  rename(petition = V17,
         boycott = V18,
         demo = V19,
         meeting = V20,
         contpol = V21,
         donate = V22,
         contmed = V23,
         expint = V24, 
         ccode = C_ALPHAN,
         year = DATEYR) |>
  mutate(weight = as.numeric(WEIGHT),
         ccode = case_when(ccode == "GB-GBN" ~ "GB",
                           TRUE ~ as.character(ccode)),
         country = countrycode(ccode,
                               origin = "iso2c",
                               destination = "country.name")) |>
  group_by(country) |>
  mutate(year = round(mean(year))) |>
  summarize(
    ccode = first(ccode),
    year = first(year),
    across(
      .cols = c(petition,
                boycott,
                demo,
                meeting,
                contpol,
                donate,
                contmed,
                expint),
      .fns = ~ weighted.mean(x = .x, w = weight, na.rm = TRUE) * 100)
  ) |>
  mutate(postcommunist = if_else(country %in% c("Croatia",
                                                "Czechia",
                                                "Georgia",
                                                "Hungary",
                                                "Lithuania",
                                                "Poland",
                                                "Russia",
                                                "Slovakia",
                                                "Slovenia"),
                                 "Yes",
                                 "No"),
         postcommunist = factor(postcommunist, levels = c("No", 
                                                          "Yes")))

# Import World Bank Data --------------------------------------------------

# Note: Look for indicators with wb_search()

indicators <- c(
  "NY.GDP.PCAP.PP.KD",   # GDP per capita, PPP (constant 2017 international $)
  "SL.UEM.TOTL.ZS",      # Unemployment, total (% of total labor force)
  "SI.POV.GINI",         # Gini index (World Bank estimate)
  "IT.NET.USER.ZS"       # Individuals using the Internet (% of population)
)

wb_raw <- wb_data(indicator = indicators, 
                  start_date = 2013,
                  end_date = 2016)

wb <- wb_raw |>
  select(ccode = iso2c, 
         year = date, 
         gdp = NY.GDP.PCAP.PP.KD, 
         unemp = SL.UEM.TOTL.ZS, 
         gini = SI.POV.GINI,
         intuse = IT.NET.USER.ZS
         ) |>
  mutate(gdp = gdp / 1000)


# Import V-Dem Data -------------------------------------------------------

# v2x_polyarchy: Electoral democracy index
# v2x_corr: Corruption index

vdem_raw <- readRDS("data_raw/vdem/V-Dem-CY-Core-v14.rds")

vdem <- vdem_raw |>
  select(country_text_id, year, v2x_polyarchy, v2x_corr) |>
  rename(ccode = country_text_id,
         democracy = v2x_polyarchy,
         corruption = v2x_corr) |>
  mutate(ccode = countrycode(ccode,
                             origin = "iso3c",
                             destination = "iso2c"))

# Merge datasets ----------------------------------------------------------

master <- issp |>
  left_join(wb, by = c("ccode", "year")) |>
  left_join(vdem, by = c("ccode", "year"))


# Add variable labels -----------------------------------------------------

attr(master$country, "label") <- "Country"
attr(master$ccode, "label") <- "Country code, ISO2C"
attr(master$year, "label") <- "Year"
attr(master$petition, "label") <- "Signed petition, percent"
attr(master$boycott, "label") <- "Boycotted certain products, percent"
attr(master$demo, "label") <- "Took part in a demonstration, percent"
attr(master$meeting, "label") <- "Attended political meeting, percent"
attr(master$contpol, "label") <- "Contacted a politician, percent"
attr(master$donate, "label") <- "Donated money or raised funds, percent"
attr(master$contmed, "label") <- "Contacted media, percent"
attr(master$expint, "label") <- "Expressed views on the internet, percent"
attr(master$postcommunist, "label") <- "Postcommunist country"
attr(master$gdp, "label") <- "GDP per capita, PPP (1000$)"
attr(master$unemp, "label") <- "Unemployment, total (% of total labor force)"
attr(master$gini, "label") <- "Gini index (World Bank estimate)"
attr(master$intuse, "label") <- "Individuals using Internet (% of population)"
attr(master$democracy, "label") <- "Electoral democracy index"
attr(master$corruption, "label") <- "Corruption index"


# Save dataset ------------------------------------------------------------

saveRDS(master, "data/2024-12-12_issp.rds")
