# ESS 11 - Data preparation
# Seminar session: 2025-01-16
# ==============================================================================

# Intructions to import the data

# 1. Go to: https://ess.sikt.no/en/?tab=overview
# 2. Log in (top menu)
# 3. Click on ESS Rround 11 - 2023
# 4. Click on ESS11 - integrated file
# 5. Download CSV version
# 6. Unzip file

# Note: consult the questionnaire and codebook to better understand the data
#       transformation below. 


# Load packages -----------------------------------------------------------

# install.packages("readr")

library(dplyr) # Data manipulation
library(readr) # Data import (CSV)

ess_11_raw <- read_csv("data_raw/ess_11/ESS11.csv") |> 
  filter(cntry == "DE") # Select only Germany


# Select and recode variables ---------------------------------------------

ess_11 <- ess_11_raw |> 
  mutate( # Note: the next 100+ lines are a long call of the mutate function. 
    
    # Voted in last national election -------------------------------------
    vote = case_when(vote == 1 ~ "Yes",
                     vote == 2 ~ "No",
                     vote == 3 ~ "Not eligible"),
    vote = factor(vote, levels = c("No", "Yes", "Not eligible")),
    
    # Contacted politician or government official last 12 months ----------
    contact = case_when(contplt == 1 ~ "Yes",
                        contplt == 2 ~ "No"),
    contact = factor(contact, levels = c("No", "Yes")),
    
    # Signed petition last 12 months --------------------------------------
    petition = case_when(sgnptit == 1 ~ "Yes",
                         sgnptit == 2 ~ "No"),
    petition = factor(petition, levels = c("No", "Yes")),
    
    # Taken part in public demonstration last 12 months -------------------
    demo = case_when(pbldmna == 1 ~ "Yes",
                     pbldmna == 2 ~ "No"),
    demo = factor(demo, levels = c("No", "Yes")),
    
    # Boycotted certain products last 12 months ---------------------------
    boycott = case_when(bctprd  == 1 ~ "Yes",
                        bctprd  == 2 ~ "No"),
    boycott = factor(boycott, levels = c("No", "Yes")),
    
    # Gender --------------------------------------------------------------
    gender = case_when(gndr == 1 ~ "Male",
                       gndr == 2 ~ "Female"),
    gender = factor(gender, levels = c("Male", "Female")),
    
    # Age -----------------------------------------------------------------
    age = case_when(agea == 999 ~ NA_real_, # Missing code 999 treated as NA
                    TRUE ~ agea), # Keep all other values
    
    # Income --------------------------------------------------------------
    # For values in euros, see ESS country documentation for Germany, 
    # showcards: Liste 80
   income = case_when(hinctnta %in% 1:2 ~ "0 - 1,730",      # 1st quintile
                      hinctnta %in% 3:4 ~ "1,731 - 2,600", # 2nd quintile
                      hinctnta %in% 5:6 ~ "2,601 - 3,620", # 3rd quintile
                      hinctnta %in% 7:8 ~ "3,621 - 5,050", # 4th quintile
                      hinctnta %in% 9:10 ~ "5,051 or more"   # 5th quintile
                      ),
   income = as.factor(income),
   
   # Education ------------------------------------------------------------
   # Based on ISCED codes 
   edu = case_when(eisced %in% c(1:2) ~ "Low",    # less than upper secondary
                   eisced %in% c(3:5) ~ "Middle", # upper secondary / vocational
                   eisced %in% c(6:7) ~ "High"    # tertiary
                   ),
   edu = factor(edu, levels = c("Low", "Middle", "High")),
   
   
   # Union membership, currently ------------------------------------------
   union = case_when(mbtru == 1 ~ "Yes",
                     mbtru %in% 2:3 ~ "No"),
   union = factor(union, levels = c("No", "Yes")),
   

   # Left-right self-placement -------------------------------------------
   lrscale = if_else(lrscale %in% 0:10, lrscale, NA_real_),
   
   

   # Attitudes toward redistribution --------------------------------------

   proredis = case_when(gincdif %in% 1:2 ~ "Yes",
                        gincdif %in% 3:5 ~ "No"),
   proredis = factor(proredis, levels = c("No", "Yes")),
   
   
   # Region --------------------------------------------------------------
   region = if_else(region %in% c("DE3", # Berlin 
                                  "DE4", # Brandenburg
                                  "DE8", # Mecklenburg-Vorpommern
                                  "DED", # Sachsen
                                  "DEE", # Sachsen-Anhalt
                                  "DEG"  # Thueringen
   ), 
   "East", 
   "West"),
   region = factor(region, levels = c("West", "East"))
  ) |> 
  select(
    vote,
    contact,
    petition,
    demo,
    boycott,
    gender,
    age,
    income,
    edu,
    union,
    lrscale,
    proredis,
    region
  )

# Add labels --------------------------------------------------------------

attr(ess_11$vote, "label") <- "Voted last national election"
attr(ess_11$contact, "label") <- "Contacted politician or government official last 12 months"
attr(ess_11$petition, "label") <- "Signed petition last 12 months"
attr(ess_11$demo, "label") <- "Taken part in public demonstration last 12 months"
attr(ess_11$boycott, "label") <- "Boycotted certain products last 12 months"
attr(ess_11$gender, "label") <- "Gender"
attr(ess_11$age, "label") <- "Age of respondent, calculated"
attr(ess_11$income, "label") <- "Household's total net income, all sources"
attr(ess_11$edu, "label") <- "Highest level of education, ES - ISCED"
attr(ess_11$union, "label") <- "Member of trade union or similar organisation, currently"
attr(ess_11$lrscale, "label") <- "Left-right self-placement"
attr(ess_11$proredis, "label") <- "Support for economic redistribution"
attr(ess_11$region, "label") <- "West/East Germany"

# Save dataset ------------------------------------------------------------

saveRDS(ess_11, file = "data/2025-01-16_ess_11.rds")
