#Setup
library(pacman)
p_load(tidyverse, lubridate, gghighlight)


#Leitura
dados = read_csv("dados.csv", show_col_types = F) #para atualizar os dados, rode source("leitura_forms.R")


#Manipulação
dados$Valor = ifelse(dados$`Tipo do registro` == "Gasto", -1*dados$Valor, dados$Valor)
dados$data = dmy_hms(dados$data)
dados = dados |> mutate(across(c(Descricao_curta, `Destino ou fonte`), ~ tolower(gsub("_", " ", .x))))

mensal = dados |> filter(data>floor_date(today(), "months"))


#Análise mensal
mensal |> filter(`Tipo do registro`!="Receita") |> group_by(Categoria) |> ggplot(aes(x=Categoria,y=-Valor))+
  geom_col(aes(fill = Subcategoria))

#Análise longo prazo
dados |> ggplot(aes(x = data, y = cumsum(Valor)))+
  geom_step(aes(color = (Valor>0)), show.legend = F)
