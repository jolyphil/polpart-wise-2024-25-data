# Data transformation for the "Political Participation Research" project seminar (winter semester 2024-25)

This repository contains raw data on political participation and scripts to transform it. You are free to use this material for your research project. 

## Raw data

**European Social Survey (ESS), Round 11**

- CSV version: [`data_raw/ess_11/ESS11.csv`](data_raw/ess_11/ESS11.csv)

**Data from the Bundeswahlleiterin on the 2021 German federal election**

- Results, CSV version: [`data_raw/bwl_btw_2021/kerg.csv`](data_raw/bwl_btw_2021/kerg.csv)
- Contextual data, CSV version: [`data_raw/bwl_btw_2021/btw21_strukturdaten.csv`](data_raw/bwl_btw_2021/btw21_strukturdaten.csv)

**Country-level data from Vrablikova (2014)**

- TSV version: [`data_raw/vrablikova_2014/vrablikova_2014_appendix_a.tsv`](data_raw/vrablikova_2014/vrablikova_2014_appendix_a.tsv)


## Clean data and data transformation scripts

2024-11-07: **European Social Survey (ESS)**, Round 11, Germany

- Clean data: [`data/2024-11-07_ess_11.rds`](data/2024-11-07_ess_11.rds)
- Script: [`data_raw/ess_11/2024-11-07_ess_11_data_preparation.R`](data_raw/ess_11/2024-11-07_ess_11_data_preparation.R)

2024-11-14: **Bundeswahlleiterin**, 2021 German federal election

- Clean data: [`data/2024-11-14_bwl.rds`](data/2024-11-14_bwl.rds)
- Script: [`data_raw/bwl_btw_2021/2024-11-14_bwl.R`](data_raw/bwl_btw_2021/2024-11-14_bwl.R)

2024-11-14: **Vrablikova (2018)**, country-level data

- Clean data: [`data/2024-11-14_vrablikova_2014.rds`](data/2024-11-14_vrablikova_2014.rds)
- Script: [`data_raw/vrablikova_2014/2024-11-14_vrablikova_2014_data_preparation.R`](data_raw/vrablikova_2014/2024-11-14_vrablikova_2014_data_preparation.R)
