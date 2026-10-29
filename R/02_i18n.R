
# ==========================================================
# ALTERNÂNCIA DE IDIOMA PT / EN / FR — apoio do lado do R
# ----------------------------------------------------------
# A interface é traduzida no navegador por:
# www/i18n/i18n.js
#
# Este código traduz os rótulos dos gráficos estáticos
# (renderPlot), usando o dicionário central:
# www/i18n/traducoes.json
#
# Estrutura esperada para cada entrada do dicionário:
# [Português, English, Français]
#
# Idiomas suportados:
# pt = Português
# en = English
# fr = Français
# ==========================================================

i18n_dicionario <- local({
  
  ficheiro <- file.path("www", "i18n", "traducoes.json")
  
  if (!file.exists(ficheiro)) {
    warning(
      "Ficheiro de traduções não encontrado: ",
      ficheiro
    )
    return(list(pt = character(0),
                en = character(0),
                fr = character(0)))
  }
  
  dic <- tryCatch(
    jsonlite::fromJSON(
      ficheiro,
      simplifyVector = FALSE
    ),
    error = function(e) {
      warning(
        "Erro ao ler traducoes.json: ",
        conditionMessage(e)
      )
      NULL
    }
  )
  
  if (is.null(dic) || is.null(dic$entradas)) {
    return(list(pt = character(0),
                en = character(0),
                fr = character(0)))
  }
  
  entradas <- dic$entradas
  
  # Normalizar os textos para facilitar a correspondência
  normalizar <- function(x) {
    gsub("\\s+", " ", trimws(as.character(x)))
  }
  
  pt <- character(0)
  en <- character(0)
  fr <- character(0)
  
  for (entrada in entradas) {
    
    # Cada entrada deve ter:
    # [0] Português, [1] Inglês, [2] Francês
    if (!is.list(entrada) || length(entrada) < 3) {
      next
    }
    
    original <- normalizar(entrada[[1]])
    ingles   <- normalizar(entrada[[2]])
    frances  <- normalizar(entrada[[3]])
    
    if (is.na(original) || original == "") {
      next
    }
    
    pt <- c(pt, original)
    en <- c(en, ingles)
    fr <- c(fr, frances)
  }
  
  # Manter a primeira ocorrência de cada texto português
  unicos <- !duplicated(pt)
  
  pt <- pt[unicos]
  en <- en[unicos]
  fr <- fr[unicos]
  
  list(
    pt = stats::setNames(pt, pt),
    en = stats::setNames(en, pt),
    fr = stats::setNames(fr, pt)
  )
})


# ==========================================================
# FUNÇÃO DE TRADUÇÃO
# ==========================================================

i18n_tr <- function(x, idioma = NULL) {
  
  # Sem idioma definido, manter o texto original
  if (is.null(idioma) || length(idioma) == 0) {
    return(x)
  }
  
  idioma <- tolower(as.character(idioma)[1])
  
  # Português: não alterar os rótulos originais
  if (identical(idioma, "pt") || length(x) == 0) {
    return(x)
  }
  
  # Seleccionar o dicionário correspondente
  dicionario <- switch(
    idioma,
    "en" = i18n_dicionario$en,
    "fr" = i18n_dicionario$fr,
    NULL
  )
  
  # Idioma não suportado: manter o original
  if (is.null(dicionario) || length(dicionario) == 0) {
    return(x)
  }
  
  texto_original <- as.character(x)
  
  chave <- gsub(
    "\\s+",
    " ",
    trimws(texto_original)
  )
  
  traducao <- unname(dicionario[chave])
  
  # Se não existir tradução, preservar o texto original
  resultado <- ifelse(
    is.na(traducao) | traducao == "",
    texto_original,
    traducao
  )
  
  # Preservar dimensões, se existirem
  if (!is.null(dim(x))) {
    dim(resultado) <- dim(x)
  }
  
  resultado
}

