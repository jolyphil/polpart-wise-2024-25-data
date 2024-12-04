library(dplyr)
library(haven)

ess_raw <- read_stata("data_raw/ess_11/ESS11.dta")

ess <- ess_raw |> 
  filter(cntry == "DE")

saveRDS(ess, "data/2024-12-05_ess.rds")
