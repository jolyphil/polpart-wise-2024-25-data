# Data transformation for the "Political Participation Research" project seminar (winter semester 2024-25)

This repository contains raw data on political participation and scripts to transform it. You are free to use this material for your research project. 

## Raw data

**Bundeswahlleiterin**, data on the 2021 German federal election**

- Results, CSV version: [`data_raw/bwl_btw_2021/kerg.csv`](data_raw/bwl_btw_2021/kerg.csv)
- Contextual data, CSV version: [`data_raw/bwl_btw_2021/btw21_strukturdaten.csv`](data_raw/bwl_btw_2021/btw21_strukturdaten.csv)

**European Social Survey (ESS)**, Round 11

- CSV version: [`data_raw/ess_11/ESS11.csv`](data_raw/ess_11/ESS11.csv)

**Immigrant German Election Study (IMGES)**

- SPSS version: [`data_raw/imges/ZA7495_en_v2-0-0.sav`](data_raw/imges/ZA7495_en_v2-0-0.sav)

**International IDEA voter turnout data base**

- XLS version: [`data_raw/idea/idea_parliamentary_turnout.xls`](data_raw/idea/idea_parliamentary_turnout.xls)

**International Social Survey Programme**, Citizenship II - ISSP 2014

- Stata version: [`data_raw/issp_2014/ZA6670_v2-0-0.dta`](data_raw/issp_2014/ZA6670_v2-0-0.dta)

**Standardized World Income Inequality Database (SWIID)**

- RDA version: [`data_raw/swiid/swiid9_7.rda`](data_raw/swiid/swiid9_7.rda)

**Varieties of democracy**, Country-Year: V-Dem Full+Others

- RDS version: [`data_raw/vdem/V-Dem-CY-Full+Others-v14.rds`](data_raw/vdem/V-Dem-CY-Full+Others-v14.rds)

**Vrablikova (2014)**, country-level data

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

2024-12-12: **International Social Survey Programme: Citizenship II - ISSP 2014**, aggregated at the country level and combined with indicators from the World Bank and the V-Dem Institute

- Clean data: [`data/2024-12-12_issp.rds`](data/2024-12-12_issp.rds)
- Script: [`data_raw/issp_2014/2024-12-12_issp_data_preparation.R`](data_raw/issp_2014/2024-12-12_issp_data_preparation.R)

2024-12-19: **International IDEA voter turnout data base**, combined with indicators from the V-Dem Institute, the World Bank, and the SWIID

- Clean data: [`data/2024-12-19_idea.rds`](data/2024-12-19_idea.rds)
- Script: [`data_raw/idea/2024-12-19_idea_data_preparation.R`](data_raw/idea/2024-12-19_idea_data_preparation.R)

2025-01-09: **European Social Survey (ESS)**, Round 11, Germany

- Clean data: [`data/2025-01-09_ess_11.rds`](data/2025-01-09_ess_11.rds)
- Script: [`data_raw/ess_11/2025-01-09_ess_11_data_preparation.R`](data_raw/ess_11/2025-01-09_ess_11_data_preparation.R)

2025-01-09: **Immigrant German Election Study (IMGES)**

- Clean data: [`data/2025-01-09_imges.rds`](data/2025-01-09_imges.rds)
- Script: [`data_raw/imges/2025-01-09_imges_data_preparation.R`](data_raw/imges/2025-01-09_imges_data_preparation.R)

2025-01-30: **European Social Survey (ESS)**, Round 11, Germany

- Clean data: [`data/2025-01-30_ess_11.rds`](data/2025-01-30_ess_11.rds)
- Script: [`data_raw/ess_11/2025-01-30_ess_11_data_preparation.R`](data_raw/ess_11/2025-01-30_ess_11_data_preparation.R)
