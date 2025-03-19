library(pacman)
p_load(tidyverse, lubridate, yaml, googlesheets4)

dados = read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vT1HuMhv4dJpNJZK5cMim_jLMbZ0TRahAXLYDV3Pgdv3UlEZa-G0gKtPXmRK1TaYnoih-qR_J0SFbMd/pub?gid=487223849&single=true&output=csv")[,-24]

dados = dados |> mutate(Valor = coalesce(Valor...3, Valor...8), .keep = "unused", .after = "Tipo do registro")

dados = dados |> mutate(Descricao_curta = coalesce(Descricao_curta...4, Descricao_curta...9),
                        .keep = "unused", .after = "Valor")

dados = dados |> mutate(Tipo = coalesce(Tipo...6, Tipo...10), .keep = "unused", .after = "Descricao_curta")

dados = dados |> mutate(Subcategoria = coalesce(Subcategoria...11, Subcategoria...12, Subcategoria...13,
                                                Subcategoria...14, Subcategoria...15, Subcategoria...16,
                                                Subcategoria...17, Subcategoria...18, Subcategoria...19),
                        .keep = "unused", .after = "Categoria")

dados = dados |> mutate(Categoria = ifelse(is.na(Categoria), `Tipo do registro`, Categoria), 
                        Quantidade = replace_na(Quantidade, 0))
