library(dplyr)

party <- c("SPD",
             "CDU/CSU",
             "Bündnis 90/Die Grünen",
             "FDP",
             "AfD",
             "Die Linke",
             "BSW",
             "Other")
seat_n <- c(207,
            196,
            117,
            90,
            76,
            28,
            10,
            9)
leader <- c("Rolf Mützenich",
            "Friedrich Merz",
            "Katharina Dröge; Britta Haßelmann",
            "Christian Dürr",
            "Alice Weidel; Tino Chrupalla",
            "Heidi Reichinnek; Sören Pellmann",
            "Sahra Wagenknecht", 
            NA)

bt <- data.frame(party, seat_n, leader) |> 
  mutate(seat_share = seat_n / sum(seat_n),
         seat_share = round(seat_share, digits = 2),
         gov = if_else(party %in% c("SPD", "Bündnis 90/Die Grünen"),
                       "Government",
                       "Opposition"),
         gov = factor(gov, levels = c("Opposition", "Government"))) |> 
  relocate(seat_share, .after = seat_n)

saveRDS(bt, "data/2024-11-28_bt.rds")
