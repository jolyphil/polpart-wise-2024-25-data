library(dplyr)
library(haven)

# Create function to recode organizational membership vars to 0-1
recode_mem <- function(var){
  newvar <- NA_real_
  newvar[var == 1] <- 1 # Participated last year
  newvar[var == 2] <- 0 # Not participated last year
  newvar
}

imges_raw <- read_sav("data_raw/imges/ZA7495_en_v2-0-0.sav", encoding = "latin1")

imges <- imges_raw |> 
  mutate(
    turnout = case_when(turnout == 1 ~ "Yes",
                        turnout == 2 ~ "No"),,
    turnout = factor(turnout, levels = c("No", "Yes")),
    
    gender = case_when(gender == 1 ~ "Male",
                       gender == 2 ~ "Female"),
    gender = factor(gender, levels = c("Male", "Female")),
    
    age = 2017 - birthyear,
    age = as.numeric(age),
    age2 = age^2,
    
    edu = case_when(landschool == 1 & degree %in% c(1, 2, 9) ~ "Low",
                    landschool == 2 & foreignschool_years1 < 10  ~ "Low",
                    
                    landschool == 1 & degree == 3 ~ "Medium",
                    landschool == 2 & foreignschool_years1 %in% c(10, 11) ~ "Medium",
                    
                    landschool == 1 & degree %in% c(4, 5) ~ "High",
                    landschool == 2 & foreignschool_years1 >= 12 ~ "High"),
    edu = factor(edu, levels = c("Low", "Medium", "High")), 
    
    income = log10(netinc_hh_cat) / (hhsize^2),
    income = as.numeric(income),
    
    cohabit = case_when(maritstat %in% c(1, 3) ~ "Cohabitation",
                        partner == 2 ~ "Cohabitation",
                        partner %in% c(1, 3) ~ "No cohabitation"),
    cohabit = factor(cohabit, levels = c("No cohabitation", "Cohabitation")), 
    
    west = if_else(bula %in% 1:10, "West", "East"),
    west = factor(west, levels = c("East", "West")),
    
    orgmem = across(c(part_union, part_employ, part_relgroup, part_sport, part_party),
                    recode_mem),
    orgmem = part_union + part_employ + part_relgroup + part_sport + part_party,
    
    satdem = (-1) * demsat + 5, # reverse scale
    
    partyid = case_when(partyident %in% 1:24 ~ "Yes",
                        partyident == 25 ~ "No"),
    partyid = factor(partyid, levels = c("No", "Yes")),
    
    polinter = (-1) * polint + 6,
    
    efficacy = (-1) * polatt_unders + 6,
    
    soctrust = as.numeric(soctrust)
    
  ) |> 
  filter(age >= 18) |> 
  select(turnout,
         gender,
         age,
         age2,
         edu,
         income,
         cohabit,
         west,
         orgmem,
         satdem,
         partyid,
         polinter,
         efficacy,
         soctrust
         )

# Save dataset ------------------------------------------------------------

saveRDS(imges, file = "data/2025-01-09_imges.rds")
