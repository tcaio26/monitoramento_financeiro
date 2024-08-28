library(pacman)
p_load(tidyverse, lubridate, forecast)

dados = read_csv('ultimo_download.csv') %>% mutate(across(c(5,6,9,11), as.factor), mes = floor_date(data, unit = 'months') %>% month())

serie_temporal_dinheiro_acumulado = dados %>% 
  filter(pagamento!='vale refeição') %>% group_by(data) %>% summarise(valor = sum(valor), .groups='drop') %>% mutate(fluxo = cumsum(valor)) %>% pull(fluxo) %>% ts()
serie_temporal_vale_acumulado = dados %>% 
  filter(pagamento=='vale refeição') %>% group_by(data) %>% summarise(valor = sum(valor), .groups='drop') %>% mutate(fluxo = cumsum(valor)) %>% pull(fluxo) %>% ts()

serie_temporal_dinheiro = dados %>% 
  filter(pagamento!='vale refeição') %>% group_by(data) %>% summarise(fluxo = sum(valor), .groups = 'drop') %>% pull(fluxo) %>% ts()
serie_temporal_vale = dados %>% 
  filter(pagamento=='vale refeição') %>% group_by(data) %>% summarise(fluxo = sum(valor), .groups = 'drop') %>% pull(fluxo) %>% ts()

dados_dinheiro = dados %>% filter(pagamento!='vale refeição')
dados_beneficios = dados %>% filter(pagamento=='vale refeição')

dados_dinheiro %>% filter(valor<0) %>% group_by(mes, categoria) %>% summarise(gastos = sum(valor)) %>% mutate(valor_proporcional = gastos/sum(gastos))
