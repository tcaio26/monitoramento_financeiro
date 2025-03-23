#Setup
library(pacman)
p_load(tidyverse, lubridate, gghighlight, psych)


#Leitura
dados = read_csv("dados.csv", show_col_types = F) #para atualizar os dados, rode source("leitura_forms.R")


#Manipulação
dados$Valor = ifelse(dados$`Tipo do registro` == "Gasto", -1*dados$Valor, dados$Valor)
dados$data = dmy_hms(dados$data)
dados = dados |> mutate(across(c(Descricao_curta, `Destino ou fonte`), ~ tolower(gsub("_", " ", .x))))

mensal = dados |> filter(data>floor_date(today(), "months"))


#Análise mensal
mensal |> group_by(Tipo, Categoria) |> select(Valor) |> describe()
  
mensal |> filter(`Tipo do registro`!="Receita") |> group_by(Categoria) |> ggplot(aes(x=Categoria,y=-Valor))+
  geom_col(aes(fill = Subcategoria))

mensal |> ggplot(aes(x = data, y = cumsum(Valor)))+
  geom_step(aes(color = (Valor>0)), show.legend = F)+
  scale_x_datetime(date_breaks = '2 days', date_labels = "%d")

#Análise longo prazo
dados |> ggplot(aes(x = data, y = cumsum(Valor)))+
  geom_step(aes(color = (Valor>0)), show.legend = F)+
  scale_x_datetime(date_breaks = 'week')
