library(dplyr)
library(haven)

poldem_raw <- read_stata("data_raw/poldem/poldem-protest_30.dta")

saveRDS(poldem_raw, file = "data/2025-01-23_poldem.rds")