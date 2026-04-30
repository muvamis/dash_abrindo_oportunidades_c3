# Lista de pacotes
packages <- c(
  "readxl","readxl", "RStata", "reticulate", "shiny", "bslib", "ggthemes", "RColorBrewer", 
  "sf", "shinythemes", "lubridate", "jsonlite", "stringr", "readr", "dplyr", "ggrepel", 
  "tidyverse", "shinyjs", "plotly", "ggplot2", "DT", "shinyWidgets","terra", 
  "shinydashboard", "shinycssloaders", "cowplot", "ggmap", "ggspatial", "sf", 
  "rmarkdown", "fontawesome", "haven", "gridExtra", "scales", "Rtools",
  "writexl", "openxlsx", "kableExtra", "rlang", "formattable", "glue", "httr2"
  
)

# Verifique quais pacotes não estão instalados
install_packages <- packages[!sapply(packages, requireNamespace, quietly = TRUE)]

# Instale os pacotes que estão faltando
if (length(install_packages) > 0) {
  install.packages(install_packages)
}

# # Carregue os pacotes
lapply(packages, require, character.only = TRUE)
library(tidyr)
library(tidygeocoder)
library(dplyr)
library(openxlsx)
library(leaflet)
library(shinycssloaders)  # para o withSpinner
library(openxlsx)
library(lubridate)

 # devtools::install_github('muvamis/RZohoCreator')

############### PRESENCAS COLECTIVAS
# carrega as variaveis do ficheiro .env
dotenv::load_dot_env()

# #
# client_id <- Sys.getenv("CLIENT_ID")
# client_secret <- Sys.getenv("CLIENT_SECRET")
# refresh_token <- Sys.getenv("REFRESH_TOKEN")
# 
# access_token <- RZohoCreator::refresh_access_token(
#   client_id,
#   client_secret,
#   refresh_token
# )$access_token
# 
# Presenca <- RZohoCreator::get_records(
#   "associacaomuva",
#   "inscri-o-e-sele-o",
#   "Coordenador_Senior_das_Operacoes_Report",
#   access_token
# )
# 

Selecionados_Motivacional_Monapo_2025 <- read_excel("Selecionados_Motivacional_Monapo_2026.xlsx")
Selecionados_Motivacional_Ribaue_2025 <- read_excel("Selecionados_Motivacional_Ribaue_2026.xlsx")

Perfil_Abrindo_C2 <- rbind(Selecionados_Motivacional_Monapo_2025, Selecionados_Motivacional_Ribaue_2025)

Perfil_Abrindo_C2 <- Perfil_Abrindo_C2 %>%
  select(-c(
    1, 2,
    46,47,
    48,
    49
  ))

Presencas_Colectivas <- read_excel("Presencas_Colectivas.xlsx")

Presencas_Colectivas <- Presencas_Colectivas %>%
  select(-c(
    6,
    11,
    12
  ))

Presencas_Colectivas <- Presencas_Colectivas %>% rename(
  Data_Registo = Nome_dos_Participantes.Modified_Time,
  Facilitador = Nome_dos_Participantes.Facilitadores,
  Distrito = Nome_dos_Participantes.DISTRITO,
  Sexo = Nome_dos_Participantes.Sexo,
  Turmas = Nome_dos_Participantes.Turmas,
  Comunidade = Nome_dos_Participantes.COMUNIDADE,
  Nome_Participante = Nome_dos_Participantes.Nome_Participante
)

# # Padronização de nomes das sessões
Presencas_Colectivas <- Presencas_Colectivas %>%
  mutate(Nome_da_sessao = case_when(
    Nome_da_sessao == "1-Introdução(Apresentação do projecto e dos participantes-Facilitadores(as)" ~ "Sessao1",
    Nome_da_sessao == "2-Proatividade e reatividade" ~ "Sessao2",
    Nome_da_sessao == "3-Comunicação e gestão familiar" ~ "Sessao3",
    Nome_da_sessao == "4-Processo empreendedor" ~ "Sessao4",
    Nome_da_sessao == "5-Identificação de oportunidades de negócios" ~ "Sessao5",
    Nome_da_sessao == "6-Planejamento e definição de metas" ~ "Sessao6",
    Nome_da_sessao == "7-Contabilidade" ~ "Sessao7",
    Nome_da_sessao == "8-Conheça os seus clientes" ~ "Sessao8",
    Nome_da_sessao == "9-Como lidar com erros" ~ "Sessao9",
    Nome_da_sessao == "10-Negociação com o fornecedor" ~ "Sessao10",
    Nome_da_sessao == "11-Técnicas de resolução de problemas" ~ "Sessao11",
    Nome_da_sessao == "12-Mapeamento parte 2" ~ "Sessao12",
    TRUE ~ Nome_da_sessao
  ))


Presencas_Colectivas <- Presencas_Colectivas %>%
  pivot_wider(names_from = Nome_da_sessao, values_from = Presenca)

# Função de limpeza para valores compostos
corrigir_presenca <- function(x) {
  sapply(x, function(item) {
    if (is.character(item) && length(item) == 1) {
      return(trimws(item))
    }
    if ((is.list(item) || is.vector(item)) && length(item) > 1) {
      item <- unlist(item)
      item <- trimws(item)
      if ("Presente" %in% item) {
        return("Presente")
      } else if ("Ausente" %in% item) {
        return("Ausente")
      } else {
        return(NA)
      }
    }
    return(NA)
  })
}

# duplicados <- Presencas_Colectivas[duplicated(Presencas_Colectivas), ]
# # 
#  duplicados_Nome <- Presencas_Colectivas[duplicated(Presencas_Colectivas$Nome_Participante), ]


# Identificar colunas de sessão após pivot_wider
sessao_cols <- grep("^Sessao\\d+$", names(Presencas_Colectivas), value = TRUE)

# Aplicar a função de correção
Presencas_Colectivas[sessao_cols] <- lapply(Presencas_Colectivas[sessao_cols], corrigir_presenca)



# Substituir NULL por NA nas colunas de sessões
sessao_cols <- grep("^Sessao\\d+$", names(Presencas_Colectivas), value = TRUE)
for (col in sessao_cols) {
  Presencas_Colectivas[[col]][sapply(Presencas_Colectivas[[col]], is.null)] <- NA
}

Presencas_Colectivas <- Presencas_Colectivas %>%
  rowwise() %>%
  mutate(Num_Ausencias = sum(c_across(all_of(sessao_cols)) == "Ausente", na.rm = TRUE)) %>%
  ungroup()

Presencas_Colectivas <- Presencas_Colectivas %>%
  {
    colunas_atuais <- names(.)

    colunas_fixas <- c("Data_Registo", "Facilitador", "Distrito", "Sexo", "Turmas", "Comunidade", "Nome_Participante")
    colunas_sessoes <- str_sort(colunas_atuais[str_detect(colunas_atuais, "^Sessao\\d+$")], numeric = TRUE)
    colunas_restantes <- setdiff(colunas_atuais, c(colunas_fixas, colunas_sessoes))

    select(., all_of(c(colunas_fixas, colunas_sessoes, colunas_restantes)))
  }

############### PERFIL COM PRESENCAS MONAPO

Presencas_Monapo <- Presencas_Colectivas %>%
  filter(Distrito == "Monapo")

Presencas_Monapo_Perfil <- Presencas_Monapo %>%
  # inner_join(
  left_join(
    Selecionados_Motivacional_Monapo_2025,
    by = c("Nome_Participante", "Comunidade")
  )

Presencas_Ribaue <- Presencas_Colectivas %>%
  filter(Distrito == "Ribaue")

Presencas_Ribaue_Perfil <- Presencas_Ribaue %>%
  # inner_join(
  left_join(  
  Selecionados_Motivacional_Ribaue_2025,
    by = c("Nome_Participante", "Comunidade")
  )

Ribaue_Perfil_Nao_Enco <- Presencas_Ribaue %>%
  anti_join(
    Selecionados_Motivacional_Ribaue_2025,
    by = c("Nome_Participante", "Comunidade")
  )


Ribaue_duplicados <- Presencas_Ribaue_Perfil[duplicated(Presencas_Ribaue_Perfil), ]
#
 duplicados_Nome <- Presencas_Ribaue_Perfil[duplicated(Presencas_Ribaue_Perfil$Nome_Participante), ]

 idx <- which(Presencas_Ribaue_Perfil$Nome_Participante == "BENILDA ALBERTO")[1]
 Presencas_Ribaue_Perfil <- Presencas_Ribaue_Perfil[-idx, ]
 
 
Perfil_Abrindo_C2_2026 <- rbind(Presencas_Monapo_Perfil,Presencas_Ribaue_Perfil)

Perfil_Abrindo_C2_2026 <- Perfil_Abrindo_C2_2026 %>%
  select(-c(
  16:22,
  18,19,
  34
  ))

Perfil_Abrindo_C2_2026 <- Perfil_Abrindo_C2_2026 %>% rename(
  Distrito = Distrito.x,
  Sexo =Sexo.x
)

table(Perfil_Abrindo_C2_2026$Distrito,Perfil_Abrindo_C2_2026$Sexo)


# duplicados_Nome <- Presencas_Monapo_Perfil[duplicated(Presencas_Monapo_Perfil$Nome_Participante), ]

# Presencas_Monapo_Perfil <- Presencas_Monapo_Perfil %>%
#   distinct(Nome_Participante, .keep_all = TRUE)




# participantes_Geral <- read_excel("participantes_Geral.xlsx")
# 
# Perfil_Ribaue <- participantes_Geral %>%
#   filter(Distrito == "Ribaue")
# 
# Presencas_Ribaue <- Presencas_Colectivas %>%
#   filter(Distrito == "Ribaue")
# 
# Presencas_Ribaue_Perfil <- Presencas_Ribaue %>%
#   inner_join(Perfil_Ribaue, by = "Nome_Participante")
# 
# Ribaue_Perfil_Nao_Enco <- Presencas_Ribaue %>%
#   anti_join(Perfil_Ribaue, by = "Nome_Participante")
# 


Presencas_PI <- Presencas_Colectivas


# merge_final <- Presencas_PI %>%
#   inner_join(Perfil_Abrindo_C2, by = "Nome_Participante")
# 
# duplicados_Nome <- Presencas_Colectivas[duplicated(Presencas_Colectivas$Nome_Participante), ]
# 
# base_match <- Presencas_PI %>%
#   dplyr::inner_join(
#     Perfil_Abrindo_C2,
#     by = "Nome_Participante"
#   )
# 
# nao_encontrados <- Presencas_PI %>%
#   dplyr::anti_join(
#     Perfil_Abrindo_C2,
#     by = "Nome_Participante"
#   )


# # Adicionar a coluna 'Desistente' com base em 4 ou mais ausências
# Presencas_PI <- Presencas_PI %>%
#   mutate(Desistente = ifelse(Num_Ausencias >= 5 , "Sim", "Não"))
# 
# Presencas_PI$Comunidade <- toupper(Presencas_PI$Comunidade)
# 
# Presencas_PI$Nome_Participante <- toupper(Presencas_PI$Nome_Participante)
# 

# write_xlsx(Presenca, "Presencas_PI.xlsx")




# 1. Ler os dados
dados_qualidade <- read_excel("Qualidade_Sessoes.xlsx")

dados_qualidade <- dados_qualidade %>%
  select(-c(
    3,
    4,
    8,
    9, 13
  ))

dados_qualidade <- dados_qualidade %>% rename(
  Data_Registo = Date_field,
  Facilitador = Facilitador.Facilitador,
  Sessão = Numero_da_Sess_o,
  Comunidade = Comunidade.Comunidade
)

dados_qualidade <- dados_qualidade %>%
  relocate(Data_Registo, Distrito, Comunidade, Facilitador,Sessão)


# 2. Substituir espaços em branco ou NA por zero
dados_qualidade[is.na(dados_qualidade)] <- 0
dados_qualidade[dados_qualidade == ""] <- 0

dados_qualidade[, 6:ncol(dados_qualidade)] <- 
  lapply(dados_qualidade[, 6:ncol(dados_qualidade)], function(x) as.numeric(as.character(x)))

# Agora soma
dados_qualidade$Total <- rowSums(dados_qualidade[, 6:ncol(dados_qualidade)], na.rm = TRUE)

# 
# # write.xlsx(Presencas_PI, "Presencas_Abrindo_Oport.xlsx")
# 
# Beneficiario_Indirectos <- read_excel("BENEFICIARIOS INDIRECTOS Report.xlsx") 
# 
# # Beneficiario_Indirectos <- Beneficiario_Indirectos %>%
# #   select(-c(3, 4, 5, 6, 8))
# # 
# # 
# Beneficiario_Indirectos <- Beneficiario_Indirectos %>% rename(
#   Beneficiarios_Envolvidos = `Depois do seu envolvimento com o projecto Abrindo Oportunidades, algum jovem do seu agregado familiar ou da comunidade começou a ajudar/trabalhar ou iniciou uma nova actividade produtiva?`,
#   Outros_Beneficios_comentarios = `Descreva brevemente qualquer outro benefício ou história relevante envolvendo jovens indiretos`
# )
# 
# 
# 
# Beneficiario_Indirectos <- Beneficiario_Indirectos %>%
#   mutate(
#     Data_Registo = as.Date(`Data de Registo`),
#     Mes_Referencia = case_when(
#       day(Data_Registo) <= 15 ~ format(Data_Registo %m-% months(1), "%Y-%m"),  # dias 1 a 7 -> mês anterior
#       TRUE ~ format(Data_Registo, "%Y-%m")  # resto das datas -> mês atual
#     )
#   )
# 
# duplicados <- Beneficiario_Indirectos[duplicated(Beneficiario_Indirectos), ]
# # 
# duplicados <- Beneficiario_Indirectos[duplicated(Beneficiario_Indirectos$Nome_Beneficiario_Indirecto), ]

# # Remover duplicados
# Presencas_PI <- Presencas_PI %>% distinct(.keep_all = TRUE)



# Beneficiario_Indirectos <- Beneficiario_Indirectos %>%
#   select(-c(1))

# 
# Beneficiario_Indirectos <- Beneficiario_Indirectos %>%
#   select(
#     Nome_Beneficiario_Indirecto,
#     Sexo,
#     Idade,
#     Vinculo,
#     Tipo_de_beneficio,
#     Tipo_de_actividade_iniciada,
#     Renda,
#     Contacto_Proprio,
#     Contacto_Alternativo
#   )




# 
# ################# Base Sem Faltosos ##############
# 
# 
# # Presenca_Certificado <- Presenca %>%
# #   filter(Num_Ausencias < 5)
# # 
# # write.xlsx(Presenca_Certificado, "Participantes_Certificados.xlsx")
# 
# 
# # # Agora, você pode criar outras variáveis que apontam para a mesma base
# # Perfil_Kufungula <- Presenca
# 
# # write.xlsx(Presencas, file = "Presencas.xlsx", row.names = FALSE)
# Geral <- Presenca
# Presencas <- Geral
# # # Remover os participantes com exatamente 12 ausências
# # Presenca <- Presenca %>%
# #   filter(Num_Ausencias < 12)
# # Salvar o dataframe Presencas como arquivo Excel
# #Criar a tabela com Distrito, Comunidade, Facilitador e o número de Participantes
# # tabela_participantes <- Perfil_Kufungula %>%
# #   group_by(Distrito, Comunidade, Facilitador) %>%
# #   summarise(Numero_Participantes = n_distinct(Nome_Participante)) %>%
# #   ungroup()
# 
# PARTICIPANTES_Report_Report <- read_excel("PARTICIPANTES_Report Report.xlsx") 
# 
# PARTICIPANTES_Report_Report <- PARTICIPANTES_Report_Report %>% rename(
#   Distrito = DISTRITO,
#   Comunidade = COMUNIDADE,
#   Facilitador = Facilitadores
#   )
# # # Obter os participantes que estão no PARTICIPANTES_Report_Report mas não no Perfil_Kufungula
# # participantes_exclusivos <- anti_join(PARTICIPANTES_Report_Report, Perfil_Kufungula, by = "Nome_Participante")
# 
# # # Criar a tabela com Distrito, Comunidade, Facilitador e número de participantes
# # tabela_participantes_exclusivos <- participantes_exclusivos %>%
# #   group_by(Distrito, Comunidade, Facilitador) %>%
# #   summarise(Numero_Participantes = n_distinct(Nome_Participante)) %>%
# #   ungroup()
# 
# #################################### LIMPEZA NEGOCIOS ############################################
# 
# Negocios_Monapo <- read_excel("Negocios_Monapo.xlsx")
# Negocios_Ribáuè <- read_excel("Levantamento Negocios Ribáuè - C.xlsx")
# 
# # Função para transformar texto: maiúsculas, sem acentos, e sem espaços extras
# clean_names <- function(x) {
#   x <- toupper(x)                                # Converter para maiúsculas
#   x <- stri_trans_general(x, "Latin-ASCII")      # Remover acentos
#   x <- str_trim(x)                               # Remover espaços extras
#   return(x)
# }
# 
# # Aplicar a função na coluna 'Nome_Participante' de cada dataframe
# Negocios_Monapo$Nome_Participante <- clean_names(Negocios_Monapo$Nome_Participante)
# Negocios_Ribáuè$Nome_Participante <- clean_names(Negocios_Ribáuè$Nome_Participante)
# Geral$Nome_Participante <-  clean_names(Geral$Nome_Participante)
# Geral$Comunidade <-  clean_names(Geral$Comunidade)
# 
# Negocios <- bind_rows(Negocios_Monapo, Negocios_Ribáuè)
# 
# 
# #Fazer o merge mantendo apenas os registros que aparecem nas duas bases (apenas pelo nome)
# Negocios_Merged <- Negocios %>%
#   inner_join(Geral, by = "Nome_Participante")
# 
# 
# # Verificar e filtrar todos os dados duplicados com base no Nome_Participante
# dados_duplicados <-  Negocios_Merged[duplicated(Negocios_Merged), ]
# 
# # Renomear a variável 'Sexo' para 'Genero' e ajustar os valores
# Negocios_Merged<- Negocios_Merged %>%
#   rename(Sexo = Sexo.x) %>%  # Renomeia 'Sexo.x' para 'Sexo'
#   mutate(
#     Sexo = case_when(
#       Sexo == "F" ~ "Feminino",
#       Sexo == "M" ~ "Masculino",
#       TRUE ~ Sexo  # Mantém qualquer outro valor inalterado, se houver
#     ),
#     Tem_Negocio = toupper(Tem_Negocio)  # Converte 'Tem_Negocio' para maiúsculas
#   )
# 
# # Filtrando os registros para excluir os que têm 12 ausências
# Negocios_Merged <- Negocios_Merged %>%
#   filter(Num_Ausencias != 12)
# 
# Negocios_Merged <- Negocios_Merged %>% rename(
#   Distrito = Distrito.x,
#   Comunidade = Comunidade.x
#   
# )
# 
# 
# 
# ######################## LIMPEZA POUPANCA #######################
# 
# Grupos_Poupanca <- read_excel("Grupos_Poupanca.xlsx")
# 
# Grupos_Poupanca <- Grupos_Poupanca %>%
#   select(-c(3))
# 
# 
# # Participantes_Monapo_PI_e_GPEs <- read_excel("Participantes_Monapo_PI e GPEs.xlsx")
# # Participantes_Ribaue_PI_GPEs <- read_excel("Participantes_Ribaue_ PI_GPEs.xlsx")
# # 
# Geral_Poupanca <- read_excel("Geral_Poupanca.xlsx")
# 
# Geral_Poupanca <- Geral_Poupanca %>%
#   select(-c(9, 10, 22))
# 
# # Reorganizar colunas na ordem desejada
# Geral_Poupanca <- Geral_Poupanca %>%
#   select(
#     Data, Distrito, Comunidade, Facilitador, Nome_Sessao,Nome_do_Grupo.Nome_do_Grupo, 
#     Membros_Feminino_Presentes, Membros_Masculino_Presentes,
#     
#     # 3. Valores sem acumulado (por sessão)
#     Poupanca_Sessao, Valor_Emprestimo, Divida_Paga, 
#     Valor_de_Juros_Pago_na_Sess_o,Fundo_Social, Motivo_Gasto,
#     Valor_Gasto_de_Fundo_Social, Poupanca_Acumulada, Emprestimo_Acumulado,
#     Divida_Acumulada, Valor_de_Fundo_Social_Acumulado,
#     Participacao
#   )
# 
# # 3. Corrigir formatos das variáveis
# Geral_Poupanca <- Geral_Poupanca %>%
#   mutate(
#     # Data em formato Date
#     Data = as.Date(Data, format = "%d-%b-%Y"),
#     
#     # # Sessão em número
#     # sessao_num = as.numeric(gsub("[^0-9]", "", nome_sessao)),
#     
#     # Variáveis numéricas (garantir que estão em numeric)
#     Poupanca_Sessao = as.numeric(Poupanca_Sessao),
#     Fundo_Social = as.numeric(Fundo_Social),
#     Valor_Emprestimo = as.numeric(Valor_Emprestimo)
#     # Emprestimo_acumulado = as.numeric(Emprestimo_acumulado),
#     # Divida_paga = as.numeric(Divida_paga),
#     # Divida_acumulada = as.numeric(Divida_acumulada),
#     # Valor_de_fundo_social_acumulado = as.numeric(Valor_de_fundo_social_acumulado),
#     # Valor_de_juros_pago_na_sess_o = as.numeric(Valor_de_juros_pago_na_sess_o),
#     # Valor_gasto_de_fundo_social = as.numeric(Valor_gasto_de_fundo_social)
#   )
# 
# Geral_Poupanca <- Geral_Poupanca%>% rename(
#   Nome_Grupo = Nome_do_Grupo.Nome_do_Grupo
# )
# 
# 
# # ######################### Sessões de Agricultura #################################
# # 
# Presencas_BPA <- read_excel("Presencas_BPA.xlsx")
# 
# # # # RENAME
# Presencas_BPA <- Presencas_BPA %>% rename(
#   Data_Registo = Nome_De_Participante.Modified_Time ,
#   Distrito = Nome_De_Participante.Distrito,
#   Sexo = Nome_De_Participante.Sexo,
#   Presenca = Presen_a,
#   Comunidade = Nome_De_Participante.Comunidade,
#   Nome_Sessao = Nome_da_Sess_o,
#   Nome_Participante = Nome_De_Participante.Nome_Participante,
#   Facilitador = Nome_De_Participante.Facilitador
# )
# 
# Presencas_BPA <- Presencas_BPA %>%
#   select(-c(7, 9, 10))
# # 
# # Pivotando e removendo duplicações de sessão
# Presencas_BPA <- Presencas_BPA %>%
#   pivot_wider(
#     names_from = Nome_Sessao,
#     values_from = Presenca,
#     values_fn = first
#   )
# 
# # Identificar colunas "Sessão X"
# sessao_cols <- names(Presencas_BPA)[grepl("^Sessão\\s\\d+$", names(Presencas_BPA))]
# 
# # Ordená-las numericamemte
# sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão ", "", sessao_cols)))]
# 
# # Reordenar a base
# Presencas_BPA <- Presencas_BPA %>%
#   select(
#     Distrito,
#     Data_Registo,
#     Comunidade,
#     Sexo,
#     Nome_Participante,
#     Facilitador,
#     all_of(sessao_cols_ordenadas)
#   )
# 
# ################# MENTORIA
# 
# 
# Lista_Mentoria_Ribaue <- read_excel("Lista_Mentoria_Ribaue.xlsx")
# 
# Lista_Mentoria_Monapo <- read_excel("Lista_Mentoria_Monapo.xlsx")
# 
# 
# 
# Lista_Mentoria_Abrindo <- rbind(Lista_Mentoria_Monapo,Lista_Mentoria_Ribaue)


