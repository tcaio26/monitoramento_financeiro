library(pacman)
p_load(tidyverse, lubridate, yaml, googlesheets4)

config = read_yaml("config.yaml")

print("Lendo dados...")

dados = suppressWarnings(suppressMessages(read_csv(config$link, show_col_types = F, progress = F)))
dados = select(dados, select = -c(Sub)) |> rename(correcao_data = `Correção de data`) #remove aquela coluna que vem toda NA

comparacao = nrow(read_csv("dados.csv", show_col_types = F, progress = F))

print(glue::glue("Leitura concluída, {nrow(dados)-comparacao} novas observações, formatando..."))

dados = dados |> mutate(Valor = coalesce(Valor...3, Valor...8), .keep = "unused", .after = "Tipo do registro")

dados = dados |> mutate(Descricao_curta = coalesce(Descricao_curta...4, Descricao_curta...9),
                        .keep = "unused", .after = "Valor")

dados = dados |> mutate(Tipo = coalesce(Tipo...6, Tipo...10), .keep = "unused", .after = "Descricao_curta")

dados = dados |> mutate(Subcategoria = coalesce(Subcategoria...11, Subcategoria...12, Subcategoria...13,
                                                Subcategoria...14, Subcategoria...15, Subcategoria...16,
                                                Subcategoria...17, Subcategoria...18, Subcategoria...19,
                                                Subcategoria...24),
                        .keep = "unused", .after = "Categoria")

dados = dados |> mutate(Categoria = ifelse(is.na(Categoria), `Tipo do registro`, Categoria), 
                        Quantidade = replace_na(Quantidade, 0))

dados = dados |> mutate(correcao_data = ifelse(
  nchar(as.character(correcao_data))==7,
  paste0('0',as.character(correcao_data)),
  as.character(correcao_data)) |> dmy())

dados = rename(dados, data = `Carimbo de data/hora`)

dados = dados |> mutate(data = dmy(str_extract(data, '^[\\S]+')))
dados = dados |> mutate(data = ifelse(is.na(correcao_data), data, correcao_data) |> as_date())

print("Salvando dados em dados.csv")

write_csv(dados, "dados.csv")
