library(countrycode) # Harmonize country codes for merge
library(dplyr)
library(readxl)

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
  mutate(iso3c = countrycode(country,
                             origin = "country.name",
                             destination = "iso3c")) |> 
  relocate(iso3c, .after = country) |> 
  filter(!is.na(turnout) & year >= 2014)


# Import V-Dem Data -------------------------------------------------------

vdem_raw <- readRDS("data_raw/vdem/V-Dem-CY-Full+Others-v14.rds")

vdem <- vdem_raw |>
  filter(year >= 2014) |> 
  select(iso3c = country_text_id, 
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
         
         voting_age = factor(voting_age, levels = c("16", "17", "18")),
         
         elect_system = case_when(elect_system == 0 ~ "Majoritarian",
                                  elect_system == 1 ~ "Proportional",
                                  elect_system == 2 ~ "Mixed"),
         elect_system = factor(elect_system, levels = c("Majoritarian",
                                                        "Proportional",
                                                        "Mixed")),
         
         compul_voting = case_when(compul_voting == 0 ~ "No",
                                   compul_voting %in% 2:4 ~ "Yes",
                                   iso3c == "ARG" ~ "Yes",
                                   iso3c == "CRI" ~ "No",
                                   iso3c == "GRC" ~ "No",
                                   iso3c == "PAN" ~ "No"
                                   ),
         compul_voting = factor(compul_voting))

# Merge datasets ----------------------------------------------------------

main <- idea |>
  left_join(vdem, by = c("iso3c", "year")) |>
  # Keep only observations for electoral and liberal democracies
  filter(regime == "Electoral democracy" | regime == "Liberal democracy") |>
  select(-c(regime)) 

# Add variable labels -----------------------------------------------------

attr(main$country, "label") <- "Country"
attr(main$iso3c, "label") <- "Country code (ISO-3C)"
attr(main$year, "label") <- "Year"
attr(main$turnout, "label") <- "Voter turnout (based on registered voters)"

# Save data ---------------------------------------------------------------

saveRDS(main, "data/2025-01-23_idea.rds")

