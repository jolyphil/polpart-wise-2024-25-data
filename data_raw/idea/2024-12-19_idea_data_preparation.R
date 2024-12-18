library(countrycode)
library(dplyr)
library(readxl)
library(wbstats) # Import World Bank Data

# Download raw data -------------------------------------------------------

# https://www.idea.int/data-tools/data/advanced-search?tid=293

# Select database (and questions) > Voter Turnout Database > Parliamentary > Voter Turnout
# Select the geographic scope > Alphabetically > Select all
# Time options > Most recent election
# Export

idea_raw <- read_xls("data_raw/idea/idea_parliamentary_turnout.xls",
                     skip = 1,
                     na = "-",
                     col_types = c("text", "text", "text", "text", "numeric"))

idea <- idea_raw |>
  mutate(year = substr(Date, 1, 4), # Extracts first 4 characters of Date
         year = as.numeric(year)) |> 
  select(country = Country,
         year,
         turnout = `Parliamentary>Voter Turnout`) |> 
  mutate(ccode = countrycode(country,
                             origin = "country.name",
                             destination = "iso3c")) |> 
  relocate(ccode, .after = country) |> 
  filter(!is.na(turnout) & year >= 2014)


# Import V-Dem Data -------------------------------------------------------

# v2x_polyarchy: Electoral democracy index
# v2x_corr: Corruption index

vdem_raw <- readRDS("data_raw/vdem/V-Dem-CY-Full+Others-v14.rds")

vdem <- vdem_raw |>
  filter(year >= 2014) |> 
  select(ccode = country_text_id, 
         year, 
         democracy = v2x_polyarchy, 
         corruption = v2x_corr,
         voting_age = v2elage,
         compul_voting = v2elcomvot,
         elect_system = v2elparlel,
         regime = v2x_regime) |> 
  mutate(regime = case_when(regime == 0 ~ "Closed autocracy",
                            regime == 1 ~ "Electoral autocracy",
                            regime == 2 ~ "Electoral democracy",
                            regime == 3 ~ "Liberal democracy"),
         regime = factor(regime, levels = c("Closed autocracy",
                                            "Electoral autocracy",
                                            "Electoral democracy",
                                            "Liberal democracy")),
         
         voting_age = factor(voting_age),
         
         elect_system = case_when(elect_system == 0 ~ "Majoritarian",
                                  elect_system == 1 ~ "Proportional",
                                  elect_system == 2 ~ "Mixed"),
         elect_system = factor(elect_system, levels = c("Majoritarian",
                                                        "Proportional",
                                                        "Mixed",
                                                        "Other")),
         
         compul_voting = case_when(compul_voting == 0 ~ "No",
                                   compul_voting %in% 2:4 ~ "Yes",
                                   ccode == "ARG" ~ "Yes",
                                   ccode == "CRI" ~ "No",
                                   ccode == "GRC" ~ "No",
                                   ccode == "PAN" ~ "No"
                                   ),
         compul_voting = factor(compul_voting))

# Import World Bank Data --------------------------------------------------

# Note: Look for indicators with wb_search()

indicators <- c(
  "NY.GDP.PCAP.PP.KD",   # GDP per capita, PPP (constant 2017 international $)
  "SL.UEM.TOTL.ZS",      # Unemployment, total (% of total labor force)
  "IT.NET.USER.ZS",      # Individuals using the Internet (% of population)
  "SP.POP.TOTL"
)

wb_raw <- wb_data(indicator = indicators, 
                  start_date = 2014,
                  end_date = 2024)

wb <- wb_raw |>
  select(ccode = iso3c, 
         year = date, 
         gdp = NY.GDP.PCAP.PP.KD, 
         unemp = SL.UEM.TOTL.ZS, 
         intuse = IT.NET.USER.ZS,
         population = SP.POP.TOTL
  ) |>
  mutate(gdp = gdp / 1000,
         population = population / 1000000)


# Load SWIID data ---------------------------------------------------------

temp_env <- new.env()  # Create a temporary environment
load("data_raw/swiid/swiid9_7.rda", envir = temp_env)

# Access the specific object
swiid_raw <- temp_env$swiid_summary

swiid <- swiid_raw |> 
  mutate(ccode = countrycode(country,
                             origin = "country.name",
                             destination = "iso3c")) |> 
  select(ccode, 
         year,
         gini = gini_disp)

# Merge datasets ----------------------------------------------------------

main <- idea |>
  left_join(vdem, by = c("ccode", "year")) |>
  # Keep only observations for electoral and liberal democracies
  filter(regime == "Electoral democracy" | regime == "Liberal democracy") |>
  select(-c(regime)) |>
  left_join(wb, by = c("ccode", "year")) |> 
  left_join(swiid, by = c("ccode", "year"))

# Add variable labels -----------------------------------------------------

attr(main$country, "label") <- "Country"
attr(main$ccode, "label") <- "Country code (ISO-3C)"
attr(main$year, "label") <- "Year"
attr(main$turnout, "label") <- "Voter turnout (based on registered voters)"
attr(main$democracy, "label") <- "Electoral democracy index"
attr(main$corruption, "label") <- "Corruption index"
attr(main$voting_age, "label") <- "Voting age"
attr(main$compul_voting, "label") <- "Compulsory voting"
attr(main$elect_system, "label") <- "Electoral system"
attr(main$gdp, "label") <- "GDP per capita, PPP (in thousands of dollars)"
attr(main$unemp, "label") <- "Unemployment, total (% of total labor force)"
attr(main$intuse, "label") <- "Individuals using Internet (% of population)"
attr(main$population, "label") <- "Total population (in millions)"
attr(main$gini, "label") <- "Gini index (SWIID estimate)"

# Save data ---------------------------------------------------------------

saveRDS(main, "data/2024-12-19_idea.rds")

