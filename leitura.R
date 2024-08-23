library(pacman)
p_load(tidyverse, lubridate, yaml, googlesheets4)

config = read_yaml('config.yaml')
link = config[[1]]; aba = config[[2]]

dados = read_sheet(link, sheet = aba)

write_csv(dados, 'ultimo_download.csv')
