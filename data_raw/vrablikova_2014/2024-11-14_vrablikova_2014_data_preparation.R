library(dplyr)
library(readr)

raw_data_file <- "data_raw/vrablikova_2014/vrablikova_2014_appendix_a.tsv"

vrablikova_2014 <- read_delim(raw_data_file, 
                              delim = "\t", 
                              escape_double = FALSE, 
                              col_names = c("country",
                                            "nep",
                                            "ter_decent",
                                            "hor_decent",
                                            "n_parties",
                                            "gdp",
                                            "postcommunist"), 
                              trim_ws = TRUE) |> 
  mutate(postcommunist = if_else(postcommunist == 1, "Postcommunist", "Not postcommunist"),
         postcommunist = factor(postcommunist))

saveRDS(vrablikova_2014, "data/2024-11-14_vrablikova_2014.rds")
