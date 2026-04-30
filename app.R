# ==============================
# 3. Login fixo
# ==============================
# users <- data.frame(
#   user = c("admin"),
#   password = c("senha123"),
#   stringsAsFactors = FALSE
# )

credentials <- reactiveValues(authenticated = FALSE)

# ==============================
# 4. UI: Overview
# ==============================
ui_overview <- tabPanel("📈 Overview",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(
                              "distritoInputGeral", 
                              "Escolha o Distrito:", 
                              choices = c("Todos", unique(Perfil_Abrindo_C2_2026$Distrito)), 
                              selected = "Todos"
                            ),
                            selectInput(
                              "comunidadeInputGeral", 
                              "Escolha a Comunidade:", 
                              choices = c("Todos", unique(Perfil_Abrindo_C2_2026$Comunidade)), 
                              selected = "Todos"
                            )
                          ),
                          mainPanel(
                            uiOutput("texto_resumo"),
                            div(
                              class = "value-box-container",
                              
                              div(class = "value-box blue",
                                  textOutput("total_part"),
                                  div("Total de Participantes")),
                              
                              div(class = "value-box green",
                                  textOutput("total_mul"),
                                  div("Mulheres")),
                              
                              div(class = "value-box orange",
                                  textOutput("total_hom"),
                                  div("Homens"))
                            ),
                            
                            br(),
                            fluidRow(
                              column(6,
                                  
                                     # downloadButton("download_inscritos", "📥 Baixar Inscritos", icon = icon("download")),
                                     uiOutput("texto_ativos"),
                                     br(),
                                     withSpinner(plotlyOutput("grafico_ativos"))
                              ),
                              
                              column(6,
                                    
                                     # downloadButton("download_excel", "📥 Baixar Lista"),
                                     uiOutput("texto_escolaridade"),
                                     br(),
                                     withSpinner(plotlyOutput("Nivel_Escolaridade"))
                              )
                            ),
                            br(),
                            fluidRow(
                              column(6,
                                     div(
                                       style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                                       tags$p(
                                         style = "margin: 0; text-align: justify;",
                                         tags$b("Participantes selecionados para o programa: "),
                                         "O gráfico abaixo mostra o número total de participantes ",
                                         tags$strong("selecionados"),
                                         " para o programa, desagregados por sexo e por distrito ou comunidade conforme os filtros aplicados."
                                       )
                                     ),
                                     # downloadButton("download_inscritos", "📥 Baixar Inscritos", icon = icon("download")),
                                     withSpinner(plotlyOutput("deslocados"))
                              ),
                              
                              column(6,
                                     div(
                                       style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                                       tags$p(
                                         style = "margin: 0; text-align: justify;",
                                         tags$b("Participantes selecionados para o programa: "),
                                         "O gráfico abaixo mostra o número total de participantes ",
                                         tags$strong("selecionados"),
                                         " para o programa, desagregados por sexo e por distrito ou comunidade conforme os filtros aplicados."
                                       )
                                     ),
                                     # uiOutput("texto_totais"),
                                     # downloadButton("download_excel", "📥 Baixar Lista"),
                                     withSpinner(plotlyOutput("Negocio"))
                              )
                            ),
                            br(),
                             fluidRow(
                               # div(
                               #   style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                               #   tags$p(
                               #     style = "margin: 0; text-align: justify;",
                               #     tags$b("Participantes selecionados para o programa: "),
                               #     "O gráfico abaixo mostra o número total de participantes ",
                               #     tags$strong("selecionados"),
                               #     " para o programa, desagregados por sexo e por distrito ou comunidade conforme os filtros aplicados."
                               #   )
                               # ),
                            # downloadButton("download_excel", "📥 Baixar Lista"),
                            # withSpinner(plotlyOutput("desistentesInput"))
                          )
                            # Texto e gráfico adicional abaixo
                            # tags$p(
                            #   list(
                            #     "O gráfico a seguir mostra o número de participantes que mudaram de distrito ou comunidade ao longo do programa, permitindo acompanhar a mobilidade durante o período de formação."
                            #   )
                            # ),
                            # withSpinner(leafletOutput("mapaParticipantes", height = "600px"))
                            # Caso queira adicionar a tabela abaixo depois
                            # br(),
                            # fluidRow(
                            #   column(12, DTOutput("tabela_overview"))
                            # )
                          )
                        )
)

# ==============================
# 5. UI: Presenças
# ==============================
ui_presencas <- tabPanel("📋 Presenças_PI",
                         tabsetPanel(
                           tabPanel("Gerais",
                                    sidebarLayout(
                                      sidebarPanel(
                                        selectInput("distritoInput_namp_pi", "Escolha o Distrito:",
                                                    choices = c("TODOS", unique(Presencas_PI$Distrito)),
                                                    selected = "TODOS"),
                                        selectInput("comunidadeInput_namp_pi", "Escolha a Comunidade:",
                                                    choices = c("TODAS", unique(Presencas_PI$Comunidade)),
                                                    selected = "TODAS"),
                                        conditionalPanel(
                                          condition = "input.comunidadeInput_namp_pi != 'TODAS'", 
                                          selectInput("facilitadorInput_namp_pi", "Selecione Facilitador/a:",
                                                      choices = c("TODOS"),  # Será preenchido dinamicamente
                                                      selected = "TODOS")
                                        )
                                      ),
                                      mainPanel(
                                        div(
                                          style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                                          tags$h4(
                                            style = "margin: 0; text-align: justify;",
                                            "O gráfico a seguir ilustra o número de participantes presentes em cada uma das sessões de PI. ",
                                            "A linha roxa representa o total previsto de participantes por sessão."
                                          )
                                        ),
                                        
                                        downloadButton("baixarBasePresencasExcel", "Baixar_Presenças"),
                                        withSpinner(
                                          plotlyOutput("graficoParticipacaoGlobal", height = "500px"),
                                          type = 6,         # Tipo do spinner (opcional)
                                          color = "#9442d4" # Cor do spinner opcional
                                        ),
                                        br(), br(),
                                        div(
                                          style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                                          tags$h4(
                                            style = "margin: 0; text-align: justify;",
                                            "O gráfico mostra a proporção de participação por sessão, separada por sexo. Cada linha indica a porcentagem de participantes presentes em relação ao total previsto, permitindo comparar o engajamento de participantes femininos e masculinos ao longo das sessões."
                                          )
                                        ),
                                        withSpinner(plotlyOutput("graficoParticipacaoSexo", height = "400px"))
                                      )
                                    )
                           ),
                           tabPanel("Acompanhamento",
                                    sidebarLayout(
                                      sidebarPanel(
                                        selectInput("distritoInput", "Selecione o Distrito:",
                                                    choices = c("TODOS", unique(Presencas_PI$Distrito)),
                                                    selected = "TODOS"),
                                        
                                        selectInput("comunidadeAcompanhamento", "Selecione a Comunidade:",
                                                    choices = c("TODAS", unique(Presencas_PI$Comunidade)),
                                                    selected = "TODAS"),
                                        
                                        selectInput("facilitadorInput", "Selecione Facilitador/a:",
                                                    choices = c("TODOS", unique(Presencas_PI$Facilitador)),
                                                    selected = "TODOS")
                                      ),
                                      mainPanel(
                                        uiOutput("textoPresencas"),
                                        uiOutput("pontosPresenca"),
                                        br(),
                                        # ⚠️ ALERTA (opcional M&E que criámos)
                                        uiOutput("facilitadores_criticos"),
                                        br(),
                                        downloadButton("downloadPresencas", "📥 Baixar Presenças"),
                                        br(), br(),
                                        dataTableOutput("tabelaPresencas")
                                      )
                                    )
                           )
                         )
)   

# ==============================
# 6. UI: Qualidade Da Sessão e Indiretos
# ==============================
ui_Qualidade <- tabPanel("🔍 Avaliação_PI",
                         tabsetPanel(
                           
                           tabPanel("Qualidade_Sessões",
                                    fluidPage(
                                      h4("Tabela de Avaliação das Sessões"),
                                      DTOutput("tabela_qualidade")
                                    )
                           )
                           
                           # tabPanel("Beneficiários_Indirectos",
                           #          fluidPage(
                           #            h3("Resumo dos Beneficiários Indiretos"),
                           #            
                           #            # Filtro por Distrito
                           #            selectInput(
                           #              inputId = "distrito_facet",
                           #              label = "Escolha o Distrito:",
                           #              choices = c("Todos", unique(Beneficiario_Indirectos$Distrito)),
                           #              selected = "Todos"
                           #            ),
                           #            
                           #            # Linha com gráfico e tabela resumo
                           #            fluidRow(
                           #              downloadButton(
                           #                outputId = "download_excel_benef",
                           #                label = "Baixar dados"
                           #              ),
                           #              column(6, DTOutput("resumo_benef")),
                           #              column(6, plotlyOutput("grafico_benef"))
                           #            ),
                           #            
                           #            h3("Tabela Completa"),
                           #            downloadButton(
                           #              outputId = "download_beneficiarios",
                           #              label = "Baixar tabela"
                           #            ),
                           #            DTOutput("beneficiarios_output")
                           #          )
                           # )
                           
                         )
)


# ==============================
# 8. UI: Boas Práticas
# ==============================
# ui_boaspraticas <- tabPanel("🌱 Boas Práticas",
#                             fluidPage(
#                               sidebarLayout(
#                                 sidebarPanel(
#                                   conditionalPanel(
#                                     condition = "input.tabSelected == 'Geral'",
#                                     selectInput("distritoInputboaspraticas", "Escolha o Distrito:",
#                                                 choices = c("Todos", unique(Presencas_BPA$Distrito)),
#                                                 selected = "Todos"),
#                                     selectInput("comunidadeInputboaspraticas", "Escolha a Comunidade:",
#                                                 choices = c("Todos", unique(Presencas_BPA$Comunidade)),
#                                                 selected = "Todos")
#                                   ),
#                                   
#                                   conditionalPanel(
#                                     condition = "input.tabSelected == 'Presenças'",
#                                     selectInput("distrito_presencas", "Escolha o Distrito:",
#                                                 choices = c("Todos", unique(Presencas_BPA$Distrito)),
#                                                 selected = "Todos"),
#                                     selectInput("comunidade_presencas", "Escolha a Comunidade:",
#                                                 choices = c("Todos", unique(Presencas_BPA$Comunidade)),
#                                                 selected = "Todos")
#                                   ),
#                                   
#                                   conditionalPanel(
#                                     condition = "input.tabSelected == 'Acompanhamento'",
#                                     selectInput("distrito_acompanhamento", "Escolha o Distrito:",
#                                                 choices = c("Todos", unique(Presencas_BPA$Distrito)),
#                                                 selected = "Todos"),
#                                     selectInput("comunidade_acompanhamento", "Escolha a Comunidade:",
#                                                 choices = c("Todos", unique(Presencas_BPA$Comunidade)),
#                                                 selected = "Todos"),
#                                     selectInput("facilitador_acompanhamento", "Escolha o Facilitador:",
#                                                 choices = c("Todos", unique(Presencas_BPA$Facilitador)),
#                                                 selected = "Todos")
#                                   )
#                                 ),
#                                 
#                                 mainPanel(
#                                   tabsetPanel(
#                                     id = "tabSelected",
#                                     
#                                     tabPanel("Geral",
#                                              fluidRow(
#                                                column(6, withSpinner(plotlyOutput("registradosboaspraticas"))),
#                                                column(6, withSpinner(plotOutput("desistentes")))
#                                              )
#                                     ),
#                                     
#                                     tabPanel("Presenças",
#                                              fluidRow(
#                                                column(12, withSpinner(plotlyOutput("grafic")))
#                                              )
#                                     ),
#                                     
#                                     tabPanel("Acompanhamento",
#                                              fluidRow(
#                                                tags$h6("A tabela abaixo apresenta os dados sobre a participação individual nas Sessões e os pontos roxos indicam a presença dos participantes em cada sessão, enquanto os pontos vermelhos indicam a ausência."),
#                                                uiOutput("PontosPresencas"),
#                                                column(12, dataTableOutput("Individual")))
#                                     )
#                                   )
#                                 )
#                               )
#                             )
# )
# ==============================
# 7. UI: Poupança
# ==============================
# ==============================
# 6.1. UI: Poupança (com fluidRow)
# ==============================
# ui_poupanca <- tabPanel("💰 Poupança",
#                         tabsetPanel(
#                           
#                           # ---------------- TAB 1 - GRUPOS ----------------
#                           tabPanel("📊 Grupos",
#                                    sidebarLayout(
#                                      sidebarPanel(
#                                        selectInput("filtro_poupanca", "Selecione o Distrito:",
#                                                    choices = c("Todos", unique(Grupos_Poupanca$Distrito)),
#                                                    selected = "Todos"),
#                                        
#                                        selectInput("filtro_comunidade", "Selecione a Comunidade:",
#                                                    choices = "Todos",
#                                                    selected = "Todos"),
#                                        
#                                        selectInput("filtro_grupo", "Selecione o Grupo:",
#                                                    choices = "Todos",
#                                                    selected = "Todos")
#                                      ),
#                                      mainPanel(
#                                        # Value boxes
#                                        fluidRow(
#                                          column(3,
#                                                 div(style = "background-color:#6f42c1; color:white; padding:15px; border-radius:12px; text-align:center;",
#                                                     h5("Total de Grupos"),
#                                                     h3(textOutput("total_grupos"))
#                                                 )
#                                          ),
#                                          column(3,
#                                                 div(style = "background-color:#20c997; color:white; padding:15px; border-radius:12px; text-align:center;",
#                                                     h5("Total de Participantes"),
#                                                     h3(textOutput("total_participantes"))
#                                                 )
#                                          )     
#                                        ),
#                                        br(),
#                                        fluidRow(
#                                          column(6, plotlyOutput("grafico_Participantes")),
#                                          column(6, plotOutput("grafico_emprestimo"))
#                                        ),
#                                        DTOutput("tabela_poupanca")
#                                      )
#                                    )
#                           ),
#                           
#                           # ---------------- TAB 2 - VALORES POUPADOS ----------------
#                           tabPanel("💵 Valores Poupados",
#                                    sidebarLayout(
#                                      sidebarPanel(
#                                        selectInput("filtro_distrito_valores", "Selecione o Distrito:",
#                                                    choices = c("Todos", unique(Geral_Poupanca$Distrito)),
#                                                    selected = "Todos"),
#                                        
#                                        selectInput("filtro_comunidade_valores", "Selecione a Comunidade:",
#                                                    choices = "Todos",
#                                                    selected = "Todos"),
#                                        
#                                        selectInput("filtro_grupo_valores", "Selecione o Grupo:",
#                                                    choices = "Todos",
#                                                    selected = "Todos")
#                                      ),
#                                      mainPanel(
#                                        fluidRow(
#                                          column(3,
#                                                 div(style = "background-color:#5cd6c7; color:white; padding:15px; border-radius:12px; text-align:center;",
#                                                     h5("Poupança Acumulada"),
#                                                     h3(textOutput("total_poupanca"))
#                                                 )
#                                          ),
#                                          column(3,
#                                                 div(style = "background-color:#F77333; color:white; padding:15px; border-radius:12px; text-align:center;",
#                                                     h5("Empréstimo Acumulado"),
#                                                     h3(textOutput("total_emprestimo"))
#                                                 )
#                                          ),
#                                          column(3,
#                                                 div(style = "background-color:#9942D4; color:white; padding:15px; border-radius:12px; text-align:center;",
#                                                     h5("Fundo Social"),
#                                                     h3(textOutput("total_Fundo_Social"))
#                                                 )
#                                          )
#                                          # ,
#                                          # column(3,
#                                          #        div(style = "background-color:#0d6efd; color:white; padding:15px; border-radius:12px; text-align:center;",
#                                          #            h5("Dívida Acumulada"),
#                                          #            h3(textOutput("valores_divida_acumulada"))
#                                          #        )
#                                          # )
#                                        ),
#                                        br(),
#                                        # Primeiro gráfico em linha completa
#                                        fluidRow(
#                                          column(12, plotlyOutput("grafico_valores"))
#                                        ),
#                                        
#                                        br(),
#                                        fluidRow(
#                                          column(12, plotOutput("grafico_valores_poupanca"))
#                                        ),
#                                        
#                                        br(),
#                                        
#                                        # Segundo gráfico em linha completa
#                                        fluidRow(
#                                          column(12, plotOutput("grafico_valores_emprestimo"))
#                                        ),
#                                        
#                                        br(),
#                                        # DTOutput("tabela_valores_poupanca")
#                                      )
#                                    )
#                           )
#                           
#                         )
# )

# ui_Mentoria <- tabPanel(
#   "Mentoria",
#   sidebarLayout(
#     
#     # Sidebar com filtros
#     sidebarPanel(
#       width = 3,
#       h4("Filtros"),
#       
#       selectInput(
#         inputId = "filtro_distrito_ment",
#         label = "Distrito:",
#         choices = c("Todos", unique(Lista_Mentoria_Abrindo$Distrito)),
#         selected = "Todos"
#       ),
#       
#       selectInput(
#         inputId = "filtro_comunidade_ment",
#         label = "Comunidade:",
#         choices = c("Todos", unique(Lista_Mentoria_Abrindo$Comunidade)),
#         selected = "Todos"
#       )
#     ),
#     
#     # Main panel
#     mainPanel(
#       width = 9,
#       
#       # h3("Mentoria"),
#       br(),
#       
#       fluidRow(
#         column(
#           width = 6,
#           h4("Participantes Na Mentoria"),
#           plotlyOutput("grafico_mentoria_1", height = "320px")
#         ),
#         
#         column(
#           width = 6,
#           h4("Distribuição De Participantes Com Negócio"),
#           plotlyOutput("grafico_mentoria_2", height = "320px")
#         )
#       ),
#       br(),
#       
#       h4("Tabela Completa"),
#       DTOutput("tabela_mentoria")
#     )
#   )
# )


# ==============================
# 📦 CONFIGURAÇÃO
# ==============================
log_path <- "log_acoes.csv"

# Estado global da atualização
update_status <- reactiveVal("idle")

# ==============================
# 🧩 UI ADMIN
# ==============================
ui_admin <- tabPanel(
  "🛠️ ADMIN",
  uiOutput("admin_ui")
)

# ==============================
# 9. UI Principal
# ==============================
ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  # ------------------ CSS Customizado ------------------
  tags$head(
    tags$style(HTML("
      /* Navbar */
      .navbar {
        background-color: #8054A2 !important;
        border-color: #9442d4 !important;
      }

      .navbar-default .navbar-nav > li > a { 
        color: white !important; 
        font-weight: bold; 
      }

      .navbar-default .navbar-nav > li > a:hover { 
        color: #5cd6c7 !important; 
      }

      .navbar-default .navbar-brand { 
        color: white !important; 
        font-weight: bold; 
      }

      /* Hover no título */
      .navbar-default .navbar-brand:hover {
        color: #5cd6c7 !important;
        cursor: pointer;
      }

      /* Corpo da dashboard */
      .tab-content {
        background: linear-gradient(to bottom, #ffffff, #ffffff);
        padding: 15px;
        border-radius: 10px;
      }

      /* Value boxes */
      .value-box-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 15px;
      }

      .value-box { 
        flex: 1 1 calc(20% - 20px);
        min-width: 150px;
        max-width: 220px;
        margin: 8px;
        padding: 15px;
        border-radius: 12px;
        color: white;
        font-weight: bold;
        text-align: center;
        box-shadow: 2px 2px 6px rgba(0,0,0,0.2);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
      }

      .value-box:hover {
        transform: scale(1.05);
        box-shadow: 4px 4px 12px rgba(0,0,0,0.3);
      }

      /* Paleta de cores */
      .blue   { background-color: #6a1b9a; }
      .green  { background-color: #5cd6c7; }
      .orange { background-color: #f77333; }
      .yellow { background-color: #f9a825; }
      .purple { background-color: #004c91; }

      .value-title { font-size: 14px; margin-top: 5px; }
      .value-number { font-size: 15px; }

      @media (max-width: 768px) {
        .value-box { flex: 1 1 calc(18% - 20px); }
      }

      @media (max-width: 380px) {
        .value-box { flex: 1 1 100%; }
      }
    "))
  ),
  
  # ------------------ NAVBAR ------------------
  navbarPage(
    title = "Abrindo_Oportunidades_CIII",
    
    ui_overview,
    ui_presencas,
    ui_Qualidade,
    # ui_boaspraticas,
    # ui_poupanca,
    # ui_Mentoria, 
    ui_admin
  )
)


# server.R
server <- function(input, output, session) {
  
  #################### VISAO GERAL ####################
  # ================================
  # 🔁 OBSERVER: Comunidade por Distrito
  # ================================
  observeEvent(input$distritoInputGeral, {
    
    if (!is.null(input$distritoInputGeral) && input$distritoInputGeral != "Todos") {
      
      comunidades <- Perfil_Abrindo_C2 %>%
        dplyr::filter(Distrito == input$distritoInputGeral) %>%
        dplyr::pull(Comunidade) %>%
        unique() %>%
        sort()
      
    } else {
      
      comunidades <- sort(unique(Perfil_Abrindo_C2$Comunidade))
    }
    
    updateSelectInput(
      session,
      "comunidadeInputGeral",
      choices = c("Todos", comunidades),
      selected = "Todos"
    )
  })
  
  # ================================
  # 📊 REACTIVE: DADOS FILTRADOS
  # ================================
  dados_filtrado <- reactive({
    
    df <- Perfil_Abrindo_C2
    
    if (!is.null(input$distritoInputGeral) && input$distritoInputGeral != "Todos") {
      df <- df %>% dplyr::filter(Distrito == input$distritoInputGeral)
    }
    
    if (!is.null(input$comunidadeInputGeral) && input$comunidadeInputGeral != "Todos") {
      df <- df %>% dplyr::filter(Comunidade == input$comunidadeInputGeral)
    }
    
    df
  })
  
  # ================================
  # 📦 KPI
  # ================================
  output$total_part <- renderText({
    nrow(dados_filtrado())
  })
  
  output$total_mul <- renderText({
    sum(dados_filtrado()$Sexo == "Feminino", na.rm = TRUE)
  })
  
  output$total_hom <- renderText({
    sum(dados_filtrado()$Sexo == "Masculino", na.rm = TRUE)
  })
  
  # ================================
  # 🧠 TEXTO RESUMO
  # ================================
  output$texto_resumo <- renderUI({
    
    df <- dados_filtrado()
    
    total <- nrow(df)
    mulheres <- sum(df$Sexo == "Feminino", na.rm = TRUE)
    homens <- sum(df$Sexo == "Masculino", na.rm = TRUE)
    
    distrito_sel <- input$distritoInputGeral
    
    # ================================
    # 📊 RESUMO POR DISTRITO
    # ================================
    resumo_distritos <- Perfil_Abrindo_C2 %>%
      dplyr::group_by(Distrito) %>%
      dplyr::summarise(
        total = n(),
        mulheres = sum(Sexo == "Feminino", na.rm = TRUE),
        homens = sum(Sexo == "Masculino", na.rm = TRUE),
        .groups = "drop"
      )
    
    texto_distritos <- resumo_distritos %>%
      dplyr::mutate(
        texto = paste0(
          "No distrito de <b>", Distrito, "</b>, registam-se ",
          "<b>", total, "</b> participantes (",
          "<b>", mulheres, "</b> mulheres e ",
          "<b>", homens, "</b> homens)."
        )
      ) %>%
      dplyr::pull(texto) %>%
      paste(collapse = " ")
    
    # ================================
    # 🎯 TEXTO FINAL
    # ================================
    if (distrito_sel == "Todos") {
      
      texto_final <- paste0(
        "<b>Abrindo Oportunidades:</b> ",
        "O projeto visa o fortalecimento dos sistemas alimentares, criando oportunidades de emprego para jovens e oferecendo uma resposta transformadora às barreiras estruturais que limitam o acesso ao rendimento e à inclusão económica sustentável.",
        "<br><br>",
        
        "No total, foram selecionados <b>", total, "</b> participantes, dos quais ",
        "<b>", mulheres, "</b> são mulheres e <b>", homens, "</b> homens. ",
        
        texto_distritos
      )
      
    } else {
      
      texto_final <- paste0(
        "<b>Abrindo Oportunidades:</b> ",
        "O projeto visa o fortalecimento dos sistemas alimentares, criando oportunidades de emprego para jovens e oferecendo uma resposta transformadora às barreiras estruturais que limitam o acesso ao rendimento e à inclusão económica sustentável.",
        "<br><br>",
        
        "No distrito de <b>", distrito_sel, "</b>, foram selecionados ",
        "<b>", total, "</b> participantes, dos quais ",
        "<b>", mulheres, "</b> são mulheres e <b>", homens, "</b> homens."
      )
    }
    
    div(
      style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
      HTML(texto_final)
    )
  })
  # Gráfico de inscritos por distrito ou comunidade e sexo
    # 
    # # =========================
    # # 📌 BASE REATIVA FILTRADA
    # # =========================
    # dados_filtrados <- reactive({
    #   
    #   df <- Perfil_Abrindo_C2_2026
    #   
    #   # filtro distrito
    #   if (!is.null(input$distritoInputGeral) && input$distritoInputGeral != "Todos") {
    #     df <- df %>% dplyr::filter(Distrito == input$distritoInputGeral)
    #   }
    #   
    #   # filtro comunidade
    #   if (!is.null(input$comunidadeInputGeral) && input$comunidadeInputGeral != "Todos") {
    #     df <- df %>% dplyr::filter(Comunidade == input$comunidadeInputGeral)
    #   }
    #   
    #   df
    # })
    # 
    # 
    # # =========================
    # # 📌 UPDATE COMUNIDADE
    # # =========================
    # observe({
    #   
    #   df <- Perfil_Abrindo_C2_2026
    #   
    #   if (input$distritoInputGeral != "Todos") {
    #     df <- df %>% filter(Distrito == input$distritoInputGeral)
    #   }
    #   
    #   updateSelectInput(
    #     session,
    #     "comunidadeInputGeral",
    #     choices = c("Todos", unique(df$Comunidade)),
    #     selected = "Todos"
    #   )
    # })
    # 
    # 
    # # =========================
    # # 📊 REGISTRADOS POR PROVÍNCIA
    # # =========================
    # output$registradosPorProvincia <- renderPlotly({
    #   
    #   dados <- dados_filtrados()
    #   req(nrow(dados) > 0)
    #   
    #   eixo_x_var <- ifelse(input$comunidadeInputGeral != "Todos", "Comunidade", "Distrito")
    #   
    #   dados_agrupados <- dados %>%
    #     dplyr::group_by(.data[[eixo_x_var]], Sexo) %>%
    #     dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    #     dplyr::group_by(.data[[eixo_x_var]]) %>%
    #     dplyr::mutate(
    #       percent = round(n / sum(n) * 100, 1),
    #       label_text = paste0(n, " (", percent, "%)")
    #     ) %>%
    #     dplyr::ungroup()
    #   
    #   total_inscritos <- nrow(dados)
    #   
    #   plot_ly(
    #     data = dados_agrupados,
    #     x = ~.data[[eixo_x_var]],
    #     y = ~n,
    #     color = ~Sexo,
    #     colors = c("Feminino" = "#8054A2", "Masculino" = "#F37238"),
    #     type = "bar",
    #     text = ~label_text,
    #     textposition = "outside"
    #   ) %>%
    #     layout(
    #       title = paste0("Participantes Selecionad@s (Total: ", total_inscritos, ")"),
    #       barmode = "group",
    #       paper_bgcolor = "#f5f3f4",
    #       plot_bgcolor = "#f5f3f4",
    #       xaxis = list(title = eixo_x_var),
    #       yaxis = list(
    #         title = "Total de Inscritos",
    #         range = c(0, max(dados_agrupados$n, na.rm = TRUE) * 1.1)
    #       )
    #     )
    # })
    
  # =========================
  # 📦 FUNÇÃO: PARTICIPANTES ATIVOS
  # =========================
  filtrar_participantes_ativos <- function(df, distrito = NULL, comunidade = NULL) {
    
    df_filtrado <- df
    
    # =========================
    # 📍 FILTRO DISTRITO
    # =========================
    if (!is.null(distrito) && distrito != "Todos") {
      df_filtrado <- df_filtrado %>%
        dplyr::filter(Distrito == distrito)
    }
    
    # =========================
    # 📍 FILTRO COMUNIDADE
    # =========================
    if (!is.null(comunidade) && comunidade != "Todos") {
      df_filtrado <- df_filtrado %>%
        dplyr::filter(Comunidade == comunidade)
    }
    
    # =========================
    # 📌 GARANTIR FORMATO CORRETO DAS SESSÕES
    # =========================
    df_filtrado <- df_filtrado %>%
      dplyr::mutate(
        dplyr::across(
          dplyr::starts_with("Sessao"),
          ~ tolower(as.character(.))
        )
      )
    
    # =========================
    # 📌 PARTICIPANTES ATIVOS
    # (pelo menos 1 sessão = presente)
    # =========================
    df_filtrado %>%
      dplyr::filter(
        dplyr::if_any(
          dplyr::starts_with("Sessao"),
          ~ !is.na(.) & . == "presente"
        )
      )
  }
  
  # =========================
  # 📌 BASE REATIVA
  # =========================
  dados_ativos <- reactive({
    
    filtrar_participantes_ativos(
      df = Perfil_Abrindo_C2_2026,
      distrito = input$distritoInputGeral,
      comunidade = input$comunidadeInputGeral
    )
  })
  
  # =========================
  # 🔄 UPDATE COMUNIDADE
  # =========================
  observe({
    
    df <- Perfil_Abrindo_C2_2026
    
    if (!is.null(input$distritoInputGeral) && input$distritoInputGeral != "Todos") {
      df <- df %>%
        dplyr::filter(Distrito == input$distritoInputGeral)
    }
    
    updateSelectInput(
      session,
      "comunidadeInputGeral",
      choices = c("Todos", sort(unique(df$Comunidade))),
      selected = "Todos"
    )
  })
  
  # =========================
  # 📊 GRÁFICO (ATIVOS)
  # =========================
  output$grafico_ativos <- plotly::renderPlotly({
    
    dados <- dados_ativos()
    req(nrow(dados) > 0)
    
    eixo_x <- ifelse(
      input$comunidadeInputGeral != "Todos",
      "Comunidade",
      "Distrito"
    )
    
    dados_agrupados <- dados %>%
      dplyr::group_by(.data[[eixo_x]], Sexo) %>%
      dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
      dplyr::group_by(.data[[eixo_x]]) %>%
      dplyr::mutate(
        percent = round(n / sum(n) * 100, 1),
        label_text = paste0(n, " (", percent, "%)")
      ) %>%
      dplyr::ungroup()
    
    total <- nrow(dados)
    
    plotly::plot_ly(
      data = dados_agrupados,
      x = ~.data[[eixo_x]],
      y = ~n,
      color = ~Sexo,
      colors = c("Feminino" = "#8054A2", "Masculino" = "#F37238"),
      type = "bar",
      text = ~label_text,
      textposition = "outside"
    ) %>%
      plotly::layout(
        title = paste0("Participantes que iniciaram a formação (Total: ", total, ")"),
        barmode = "group",
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor = "#f5f3f4",
        xaxis = list(title = eixo_x),
        yaxis = list(
          title = "Número de Participantes",
          range = c(0, max(dados_agrupados$n, na.rm = TRUE) * 1.1)
        )
      )
  })
  
  # =========================
  # 🧠 TEXTO DINÂMICO
  # =========================
  output$texto_ativos <- renderUI({
    
    df <- dados_ativos()
    
    total <- nrow(df)
    mulheres <- sum(df$Sexo == "Feminino", na.rm = TRUE)
    homens <- sum(df$Sexo == "Masculino", na.rm = TRUE)
    
    perc_mul <- ifelse(total > 0, round(mulheres / total * 100, 1), 0)
    perc_hom <- ifelse(total > 0, round(homens / total * 100, 1), 0)
    
    distrito_sel <- input$distritoInputGeral
    
    div(
      style = "background-color:#f5f3f4; padding:12px; border-radius:6px;",
      
      tags$p(
        style = "margin:0; text-align:justify;",
        
        tags$b("Distribuição por sexo: "),
        
        if (distrito_sel == "Todos") {
          
          tagList(
            "O gráfico apresenta participantes que participaram em pelo menos uma sessão. ",
            "No total existem ", tags$b(total), " participantes que iniciaram a formação, dos quais ",
            tags$b(mulheres), " (", tags$b(paste0(perc_mul, "%")), ") são mulheres e ",
            tags$b(homens), " (", tags$b(paste0(perc_hom, "%")), ") homens."
          )
          
        } else {
          
          tagList(
            "No distrito de ", tags$b(distrito_sel), ", existem ",
            tags$b(total), " participantes que iniciaram a formação, dos quais ",
            tags$b(mulheres), " (", tags$b(paste0(perc_mul, "%")), ") são mulheres e ",
            tags$b(homens), " (", tags$b(paste0(perc_hom, "%")), ") homens."
          )
        }
      )
    )
  })
    
  # =========================
  # 📚 ESCOLARIDADE
  # =========================
  output$Nivel_Escolaridade <- plotly::renderPlotly({
    
    dados <- dados_ativos()
    
    # =========================
    # 📌 LIMPEZA + AGRUPAMENTO
    # =========================
    df <- dados %>%
      dplyr::filter(!is.na(Nivel_Educacao), Nivel_Educacao != "") %>%
      dplyr::count(Nivel_Educacao, name = "n") %>%
      dplyr::mutate(
        perc = round(n / sum(n) * 100, 1),
        label = paste0(n, " (", perc, "%)")
      )
    
    # =========================
    # ⚠️ CASO SEM DADOS
    # =========================
    if (nrow(df) == 0) {
      return(
        plotly::plot_ly() %>%
          plotly::layout(
            title = "Sem dados de escolaridade para o filtro selecionado.",
            paper_bgcolor = "#f5f3f4",
            plot_bgcolor = "#f5f3f4"
          )
      )
    }
    
    # =========================
    # 📊 GRÁFICO
    # =========================
    plotly::plot_ly(
      data = df,
      x = ~n,
      y = ~reorder(Nivel_Educacao, n),
      type = "bar",
      orientation = "h",
      text = ~label,
      textposition = "inside",
      marker = list(color = "#69C7BE")
    ) %>%
      plotly::layout(
        title = "Escolaridade dos Participantes Que Iniciaram a Formação",
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor = "#f5f3f4",
        xaxis = list(title = "Número de Participantes"),
        yaxis = list(title = "")
      )
  })
    
  # =========================
  # 🧠 TEXTO DINÂMICO - ESCOLARIDADE
  # =========================
  output$texto_escolaridade <- renderUI({
    
    dados <- dados_ativos()
    
    total <- nrow(dados)
    
    # =========================
    # 📌 DISTRIBUIÇÃO ESCOLARIDADE
    # =========================
    df <- dados %>%
      dplyr::filter(!is.na(Nivel_Educacao), Nivel_Educacao != "") %>%
      dplyr::count(Nivel_Educacao, name = "n") %>%
      dplyr::mutate(
        perc = round(n / sum(n) * 100, 1)
      )
    
    # =========================
    # ⚠️ SEM DADOS
    # =========================
    if (nrow(df) == 0 || total == 0) {
      return(
        div(
          style = "background-color:#f5f3f4; padding:12px; border-radius:6px;",
          tags$p("Não existem dados de escolaridade para o filtro selecionado.")
        )
      )
    }
    
    # =========================
    # 📊 NIVEL MAIS FREQUENTE
    # =========================
    nivel_top <- df %>%
      dplyr::arrange(desc(n)) %>%
      dplyr::slice(1)
    
    # =========================
    # 🧠 TEXTO
    # =========================
    div(
      style = "background-color:#f5f3f4; padding:12px; border-radius:6px;",
      
      tags$p(
        style = "margin:0; text-align:justify;",
        
        tags$b("Nível de escolaridade dos participantes que iniciaram a formação: "),
        
        "Foram analisados ", tags$b(total), " participantes que iniciaram a formação. ",
        
        "O nível de escolaridade mais frequente é ",
        tags$b(nivel_top$Nivel_Educacao), 
        " com ", tags$b(nivel_top$n), 
        " participantes (", tags$b(paste0(nivel_top$perc, "%")), "). ",
        
        "A distribuição mostra variação entre diferentes níveis de formação, refletindo a heterogeneidade do grupo de participantes."
      )
    )
  })
  
    # =========================
    # 🚚 DESLOCADOS
    # =========================
    output$deslocados <- renderPlotly({
      
      dados <- dados_ativos()
      
      df <- dados %>%
        filter(!is.na(Deslocado), !is.na(Distrito)) %>%
        count(Distrito, Deslocado) %>%
        tidyr::complete(Distrito, Deslocado, fill = list(n = 0)) %>%
        group_by(Distrito) %>%
        mutate(
          perc = round(n / sum(n) * 100, 1),
          label = paste0(n, " (", perc, "%)")
        ) %>%
        ungroup()
      
      plot_ly(
        data = df,
        x = ~Distrito,
        y = ~perc,
        color = ~Deslocado,
        colors = c("Sim" = "#8054A2", "Não" = "#F37238"),
        type = "bar",
        text = ~label,
        textposition = "outside"
      ) %>%
        layout(
          title = "Deslocados por Distrito (%)",
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          barmode = "group"
        )
    })
    
    
    # =========================
    # 🏢 NEGÓCIO
    # =========================
    output$Negocio <- renderPlotly({
      
      dados <- dados_ativos()
      
      df <- dados %>%
        filter(!is.na(Act_negocio), !is.na(Distrito)) %>%
        count(Distrito, Act_negocio) %>%
        tidyr::complete(Distrito, Act_negocio, fill = list(n = 0)) %>%
        group_by(Distrito) %>%
        mutate(
          perc = round(n / sum(n) * 100, 1),
          label = paste0(n, " (", perc, "%)")
        ) %>%
        ungroup()
      
      plot_ly(
        data = df,
        x = ~Distrito,
        y = ~perc,
        color = ~Act_negocio,
        colors = c("Sim" = "#8054A2", "Não" = "#F37238"),
        type = "bar",
        text = ~label,
        textposition = "outside"
      ) %>%
        layout(
          title = "Participantes com Negócio por Distrito (%)",
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          barmode = "group"
        )
    })
    
  
  # output$registradosPorProvincia <- renderPlot({
  #   dados <- dadosFiltrados()
  #   
  #   if (nrow(dados) > 0) {
  #     
  #     dados_agrupados <- dados %>%
  #       group_by(Sexo) %>%
  #       summarise(n = n(), .groups = "drop") %>%
  #       mutate(percent = n / sum(n) * 100)
  #     
  #     total_inscritos <- nrow(dados)
  #     
  #     ggplot(dados_agrupados, aes(x = 2, y = n, fill = Sexo)) +
  #       geom_col(color = "white", width = 1) +
  #       coord_polar(theta = "y") +
  #       
  #       # Cria o buraco (donut)
  #       xlim(0.5, 2.5) +
  #       
  #       scale_fill_manual(values = c(Feminino = "#9942D4", Masculino = "#F77333")) +
  #       
  #       geom_text(
  #         aes(label = paste0(n, " (", round(percent, 1), "%)")),
  #         position = position_stack(vjust = 0.5),
  #         color = "white",
  #         size = 5,
  #         fontface = "bold"
  #       ) +
  #       labs(
  #         title = paste0("Participantes Selecionad@s por Sexo (Total: ", total_inscritos, ")"),
  #         x = NULL,
  #         y = NULL
  #       ) +
  #       theme_void() +
  #       theme(
  #         plot.title = element_text(hjust = 0.5, face = "bold", size = 16)
  #       )
  #   } else {
  #     ggplot() +
  #       labs(title = "Não há dados disponíveis para o filtro selecionado.") +
  #       theme_void()
  #   }
  # })
  
  
  
  # Download dos dados filtrados em Excel
  output$download_inscritos <- downloadHandler(
    filename = function() {
      paste("inscritos_", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      dados <- dadosFiltrados()
      
      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "Dados Filtrados")
      
      if (nrow(dados) > 0) {
        openxlsx::writeData(wb, sheet = 1, dados)
      } else {
        openxlsx::writeData(wb, sheet = 1, "Não há dados disponíveis para o filtro selecionado.")
      }
      
      openxlsx::saveWorkbook(wb, file, overwrite = TRUE)
    }
  )
  
  
  ################## DESISTENTES ##############
  filteredData <- reactive({
    data <- Presencas_PI
    
    if (!is.null(input$distritoInputGeral) && input$distritoInputGeral != "Todos") {
      data <- data[data$Distrito == input$distritoInputGeral, ]
    }
    
    if (!is.null(input$comunidadeInputGeral) && input$comunidadeInputGeral != "Todos") {
      data <- data[data$Comunidade == input$comunidadeInputGeral, ]
    }
    
    return(data)
  })
  
  # Texto dinâmico com totais
  output$texto_totais <- renderUI({
    data <- filteredData()
    
    # Classificação
    data$status_final <- dplyr::case_when(
      data$Num_Ausencias == 12 ~ "Não Iniciou",
      data$Num_Ausencias < 5 ~ "Concluiu com Sucesso",
      data$Num_Ausencias >= 5 & data$Num_Ausencias < 7 ~ "Concluiu a Formação",
      data$Num_Ausencias > 7 & data$Num_Ausencias < 12 ~ "Desistente",
      TRUE ~ NA_character_
    )
    
    # Contar totais por categoria
    totais <- data %>%
      filter(status_final %in% c("Concluiu com Sucesso", "Concluiu a Formação", "Desistente")) %>%
      group_by(status_final) %>%
      summarise(Total = n(), .groups = "drop")
    
    # Garantir que as variáveis existam
    total_sucesso <- ifelse(length(totais$Total[totais$status_final == "Concluiu com Sucesso"]) == 0, 0,
                            totais$Total[totais$status_final == "Concluiu com Sucesso"])
    total_formacao <- ifelse(length(totais$Total[totais$status_final == "Concluiu a Formação"]) == 0, 0,
                             totais$Total[totais$status_final == "Concluiu a Formação"])
    total_desistente <- ifelse(length(totais$Total[totais$status_final == "Desistente"]) == 0, 0,
                               totais$Total[totais$status_final == "Desistente"])
    
    # Texto dinâmico
    # Usar HTML() para interpretar tags
    HTML(paste0(
      "O gráfico apresenta apenas os participantes que cumpriram pelo menos 8 das 12 sessões. ",
      "Total que <strong>Concluiram com sucesso</strong>: ", total_sucesso, ", ",
      "<strong>Concluiu a formação com mais de 4 faltas</strong>: ", total_formacao, ", ",
      "<strong>Desistiram com mais de 6 faltas</strong>: ", total_desistente, "."
    ))
  })
  
  # Gráfico
  # output$desistentesInput <- renderPlot({
  #   data <- filteredData()
  #   
  #   data$status_final <- dplyr::case_when(
  #     data$Num_Ausencias == 12 ~ "Não Iniciou",
  #     data$Num_Ausencias < 5 ~ "Concluiu com Sucesso",
  #     data$Num_Ausencias >= 5 & data$Num_Ausencias < 7 ~ "Concluiu a Formação",
  #     data$Num_Ausencias >= 7 & data$Num_Ausencias < 12 ~ "Desistente",
  #     TRUE ~ NA_character_
  #   )
  #   
  #   data_filtrada <- data %>%
  #     filter(status_final == "Concluiu com Sucesso") %>%
  #     group_by(Distrito, Sexo) %>%
  #     summarise(Total = n(), .groups = "drop")
  #   
  #   ggplot(data_filtrada, aes(x = Distrito, y = Total, fill = Sexo)) +
  #     geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.6) +
  #     geom_text(aes(label = Total),
  #               position = position_dodge(width = 0.8),
  #               vjust = 1.5,
  #               color = "white",
  #               size = 5,
  #               fontface = "bold") +
  #     scale_fill_manual(values = c(
  #       "Feminino" = "#9942D4",
  #       "Masculino" = "#F77333"
  #     )) +
  #     labs(
  #       title = "Participantes que Concluíram com Sucesso",
  #       x = "Distrito",
  #       y = "Número de Participantes",
  #       fill = "Sexo"
  #     ) +
  #     theme_stata(base_size = 12)
  # })
  output$desistentesInput <- renderPlotly({
    
    data <- filteredData()
    
    # Filtra ausências completas
    data <- data %>% filter(Num_Ausencias != 12)
    
    # Criação do status final
    data <- data %>%
      mutate(
        status_final = case_when(
          Num_Ausencias < 5 ~ "Concluiu com Sucesso",
          Num_Ausencias >= 5 & Num_Ausencias < 7 ~ "Concluiu a Formação",
          Num_Ausencias >= 7 & Num_Ausencias < 12 ~ "Desistente",
          TRUE ~ NA_character_
        )
      )
    
    # Filtra apenas quem concluiu com sucesso
    data_filtrada <- data %>%
      filter(status_final == "Concluiu com Sucesso") %>%
      group_by(Distrito, Sexo) %>%
      summarise(Total = n(), .groups = "drop") %>%
      mutate(label_text = paste0(Total))  # Texto que aparecerá nas barras
    
    # Plotly
    plot_ly(
      data = data_filtrada,
      x = ~Distrito,
      y = ~Total,
      color = ~Sexo,
      colors = c("Feminino" = "#8054A2", "Masculino" = "#F37238"),
      type = "bar",
      text = ~label_text,
      textposition = "outside"
    ) %>%
      layout(
        title = "Participantes que Concluíram com Sucesso",
        showlegend = TRUE,
        barmode = "group",
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor = "#f5f3f4",
        xaxis = list(title = "Distrito"),
        yaxis = list(title = "Número de Participantes")
      )
    
  })
  
  # Download Excel
  output$download_excel <- downloadHandler(
    filename = function() {
      paste0("Participantes_Formacao_Concluiu_com_Sucesso_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      data <- filteredData()
      
      # Classificação
      data$status_final <- dplyr::case_when(
        data$Num_Ausencias == 12 ~ "Não Iniciou",
        data$Num_Ausencias < 5 ~ "Concluiu com Sucesso",
        data$Num_Ausencias >= 5 & data$Num_Ausencias < 7 ~ "Concluiu a Formação",
        data$Num_Ausencias >= 7 & data$Num_Ausencias < 12 ~ "Desistente",
        TRUE ~ NA_character_
      )
      
      # 🔹 Filtrar apenas "Concluiu com Sucesso"
      data <- data %>%
        dplyr::filter(status_final == "Concluiu com Sucesso")
      
      # Exportar Excel
      writexl::write_xlsx(data, path = file)
    }
  )
  
  # # Download Excel
  # output$download_excel <- downloadHandler(
  #   filename = function() {
  #     paste0("Participantes_Formacao_", Sys.Date(), ".xlsx")
  #   },
  #   content = function(file) {
  #     data <- filteredData()
  #     
  #     # Classificação
  #     data$status_final <- dplyr::case_when(
  #       data$Num_Ausencias == 12 ~ "Não Iniciou",
  #       data$Num_Ausencias < 5 ~ "Concluiu com Sucesso",
  #       data$Num_Ausencias >= 5 & data$Num_Ausencias < 7 ~ "Concluiu a Formação",
  #       data$Num_Ausencias >= 7 & data$Num_Ausencias < 12 ~ "Desistente",
  #       TRUE ~ NA_character_
  #     )
  #     
  #     # Garantir ordem das categorias
  #     categorias <- c("Concluiu com Sucesso", "Concluiu a Formação", "Desistente", "Não Iniciou")
  #     data$status_final <- factor(data$status_final, levels = categorias)
  #     
  #     writexl::write_xlsx(data, path = file)
  #   }
  # )
  # 
  ################ MAPA PINOS ################ 
  # # Atualizar comunidades dinamicamente quando o distrito mudar
  # observeEvent(input$distritoInputGeral, {
  #   if (input$distritoInputGeral == "Todos") {
  #     updateSelectInput(session, "comunidadeInputGeral",
  #                       choices = c("Todos", unique(Presencas_PI$Comunidade)),
  #                       selected = "Todos")
  #   } else {
  #     comunidades_distrito <- Presencas_PI %>%
  #       filter(Distrito == input$distritoInputGeral) %>%
  #       pull(Comunidade) %>% unique()
  #     
  #     updateSelectInput(session, "comunidadeInputGeral",
  #                       choices = c("Todos", comunidades_distrito),
  #                       selected = "Todos")
  #   }
  # })
  # 
  # # Reactive com base filtrada
  # dados_filtrados_mapa <- reactive({
  #   df <- Presencas_PI
  #   
  #   if (input$distritoInputGeral != "Todos") {
  #     df <- df %>% filter(Distrito == input$distritoInputGeral)
  #   }
  #   if (input$comunidadeInputGeral != "Todos") {
  #     df <- df %>% filter(Comunidade == input$comunidadeInputGeral)
  #   }
  #   df
  # })
  # 
  # # Renderizar o mapa (um pino por comunidade, com contagem de participantes)
  # output$mapaParticipantes <- renderLeaflet({
  #   df <- dados_filtrados_mapa()
  #   
  #   # Juntar com coordenadas
  #   df_geo <- df %>%
  #     left_join(dicionario_comunidades, by = c("Distrito", "Comunidade"))
  #   
  #   # Contar participantes por comunidade
  #   df_resumo <- df_geo %>%
  #     group_by(Distrito, Comunidade, lat, long) %>%
  #     summarise(Total = n(), .groups = "drop")
  #   
  #   leaflet(df_resumo) %>%
  #     addTiles() %>%
  #     addCircleMarkers(~long, ~lat,
  #                      radius = ~sqrt(Total),  # círculo proporcional ao nº de participantes
  #                      popup = ~paste0("<b>", Comunidade, "</b><br>",
  #                                      "Distrito: ", Distrito, "<br>",
  #                                      "Participantes: ", Total))
  # })
  
  
  ######################## PRESENCAS GERAIS ################
  
  # Atualiza comunidades com base no distrito selecionado
  observe({
    req(input$distritoInput_namp_pi)
    
    df <- Presencas_PI
    
    if (input$distritoInput_namp_pi != "TODOS") {
      df <- df %>% filter(Distrito == input$distritoInput_namp_pi)
    }
    
    comunidades <- sort(unique(df$Comunidade))
    comunidades <- c("TODAS", comunidades)
    
    updateSelectInput(session, "comunidadeInput_namp_pi",
                      choices = comunidades,
                      selected = "TODAS")
  })
  
  # Atualiza facilitadores com base na comunidade selecionada
  observe({
    req(input$comunidadeInput_namp_pi)
    
    df <- Presencas_PI
    
    if (input$distritoInput_namp_pi != "TODOS") {
      df <- df %>% filter(Distrito == input$distritoInput_namp_pi)
    }
    
    if (input$comunidadeInput_namp_pi != "TODAS") {
      df <- df %>% filter(Comunidade == input$comunidadeInput_namp_pi)
    }
    
    facilitadores <- sort(unique(df$Facilitador))
    facilitadores <- c("TODOS", facilitadores)
    
    updateSelectInput(session, "facilitadorInput_namp_pi",
                      choices = facilitadores,
                      selected = "TODOS")
  })
  
  
  dados_filtrados_presencas <- reactive({
    df <- Presencas_PI
    
    if (input$distritoInput_namp_pi != "TODOS") {
      df <- df %>% filter(Distrito == input$distritoInput_namp_pi)
    }
    
    if (input$comunidadeInput_namp_pi != "TODAS") {
      df <- df %>% filter(Comunidade == input$comunidadeInput_namp_pi)
    }
    
    if (!is.null(input$facilitadorInput_namp_pi) && input$facilitadorInput_namp_pi != "TODOS") {
      df <- df %>% filter(Facilitador == input$facilitadorInput_namp_pi)
    }
    
    df
  })
  
  output$graficoParticipacaoGlobal <- renderPlotly({
    
    df <- dados_filtrados_presencas()
    
    if (nrow(df) == 0) {
      showNotification("Nenhum dado disponível para os filtros selecionados.", type = "warning")
      return(NULL)
    }
    
    # Transformar dados em formato long
    df_long <- df %>%
      gather(key = "Sessao", value = "Presenca", starts_with("Sessao")) %>%
      filter(Presenca == "Presente") %>%
      group_by(Sessao, Sexo) %>%
      summarise(Count = n(), .groups = "drop") %>%
      mutate(
        Count = as.numeric(Count),
        Sessao_Num = as.numeric(gsub("Sessao", "", Sessao))
      ) %>%
      arrange(Sessao_Num) %>%
      mutate(Sessao = factor(Sessao, levels = paste0("Sessao", 1:12)))
    
    # Totais por sessão
    totais_sessao <- df_long %>%
      group_by(Sessao) %>%
      summarise(total = sum(Count), .groups = "drop")
    
    # Linha de referência
    linha_referencia <- if (input$distritoInput_namp_pi == "TODOS") 1000 else 500
    
    # Calcular posição central de cada segmento empilhado
    df_long <- df_long %>%
      group_by(Sessao) %>%
      arrange(Sexo) %>%
      mutate(
        y0 = cumsum(lag(Count, default = 0)),  # base da barra
        y_center = y0 + Count / 2               # centro do segmento para annotation
      )
    
    # Criar annotations para valores dentro das barras
    annotations_segmentos <- lapply(1:nrow(df_long), function(i) {
      list(
        x = df_long$Sessao[i],
        y = df_long$y_center[i],
        text = as.character(df_long$Count[i]),
        showarrow = FALSE,
        font = list(size = 12, color = "white")
      )
    })
    
    # Criar annotations para totais no topo
    annotations_totais <- lapply(1:nrow(totais_sessao), function(i) {
      list(
        x = totais_sessao$Sessao[i],
        y = totais_sessao$total[i] + 10,  # um pouco acima da barra
        text = paste("", totais_sessao$total[i]),
        showarrow = FALSE,
        font = list(size = 12, color = "black")
      )
    })
    
    # Combinar todas as annotations
    all_annotations <- c(annotations_segmentos, annotations_totais)
    
    # Plotly
    plot_ly(
      data = df_long,
      x = ~Sessao,
      y = ~Count,
      color = ~Sexo,
      colors = c("Feminino" = "#8054A2", "Masculino" = "#F37238"),
      type = "bar",
      hovertemplate = paste(
        "%{x}<br>",
        "Sexo: %{color}<br>",
        "Presenças: %{y}<extra></extra>"
      )
    ) %>%
      layout(
        title = "Total de Participantes Presentes na Sessão",
        barmode = "stack",
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor = "#f5f3f4",
        xaxis = list(title = ""),
        yaxis = list(title = "Número de Presenças"),
        shapes = list(
          list(
            type = "line",
            x0 = 0,
            x1 = length(unique(df_long$Sessao)) + 1,
            y0 = linha_referencia,
            y1 = linha_referencia,
            line = list(color = "purple", dash = "dash", width = 2)
          )
        ),
        annotations = all_annotations
      )
  })
  
  
  output$baixarBasePresencasExcel <- downloadHandler(
    filename = function() {
      paste("Baixar_Presenças_", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      df <- dados_filtrados_presencas()
      openxlsx::write.xlsx(df, file)
    }
  )
  
  
  
  
  ###################### PARTICIPACAO POR SEXO ################## 
  output$graficoParticipacaoSexo <- renderPlotly({
    
    df <- dados_filtrados_presencas()
    
    # Filtrar participantes com menos de 12 ausências
    df <- df %>% 
      filter(Num_Ausencias < 12)
    
    total_participants <- nrow(df)
    
    if (total_participants == 0) {
      showNotification("Nenhum dado disponível para os filtros selecionados.", type = "warning")
      return(NULL)
    }
    
    # Contar participantes por sexo (previstos)
    previstos <- df %>%
      group_by(Sexo) %>%
      summarise(Previsto = n(), .groups = "drop")
    
    # Transformar dados para formato longo
    df_agg <- df %>%
      tidyr::pivot_longer(
        cols = starts_with("Sessao"),
        names_to = "Sessao",
        values_to = "Presenca"
      ) %>%
      filter(Presenca == "Presente") %>%
      group_by(Sessao, Sexo) %>%
      summarise(Count = n(), .groups = "drop") %>%
      left_join(previstos, by = "Sexo") %>%
      mutate(
        Porcentagem = (Count / Previsto) * 100
      )
    
    # Ordenar sessões corretamente
    df_agg <- df_agg %>%
      mutate(
        Sessao_Num = as.numeric(gsub("Sessao", "", Sessao)),
        Sessao = factor(Sessao, levels = paste0("Sessao", 1:13))
      ) %>%
      arrange(Sessao_Num)
    
    # Posicionamento dos textos
    df_agg <- df_agg %>%
      mutate(
        textpos = ifelse(Sexo == "Feminino", "top center", "bottom center")
      )
    
    # Cores
    cores_legenda <- c(
      "Feminino" = "#8054A2",
      "Masculino" = "#F37238"
    )
    
    # Eixo Y dinâmico (+10 de margem)
    max_y <- max(df_agg$Porcentagem, na.rm = TRUE)
    
    # Gráfico
    plot_ly(
      data = df_agg,
      x = ~Sessao,
      y = ~Porcentagem,
      type = 'scatter',
      mode = 'lines+markers+text',
      color = ~Sexo,
      colors = cores_legenda,
      text = ~paste0(round(Porcentagem, 1), "%"),
      textposition = ~textpos,
      marker = list(size = 10),
      line = list(width = 3),
      hovertemplate = "%{x}<br>Sexo: %{color}<br>Percentual: %{y:.1f}%<extra></extra>"
    ) %>%
      layout(
        title = list(text = "", font = list(size = 16)),
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor = "#f5f3f4",
        xaxis = list(
          title = "Sessão",
          tickfont = list(size = 12)
        ),
        yaxis = list(
          title = "Percentual (%)",
          range = c(0, max_y + 10),
          tickfont = list(size = 12)
        ),
        legend = list(
          title = list(text = "<b>Sexo</b>")
        )
      )
  })

  
  ################################ ACOMPANHAMENTO ##################################
  
  
  # =========================
  # 🎨 FUNÇÃO PONTOS (OBRIGATÓRIA)
  # =========================
  formatar_pontos <- function(x) {
    sapply(x, function(valor) {
      
      if (is.na(valor) || valor == "") {
        '<span style="color: grey; font-size: 40px;">&#9679;</span>'
        
      } else if (tolower(valor) == "presente") {
        '<span style="color: purple; font-size: 40px;">&#9679;</span>'
        
      } else if (tolower(valor) == "ausente") {
        '<span style="color: red; font-size: 40px;">&#9679;</span>'
        
      } else {
        '<span style="color: grey; font-size: 40px;">&#9679;</span>'
      }
    })
  }
  
  # =========================
  # 🔁 UPDATE COMUNIDADE
  # =========================
  observeEvent(input$distritoInput, {
    
    if (input$distritoInput == "TODOS") {
      comunidades <- unique(Presencas_PI$Comunidade)
    } else {
      comunidades <- unique(Presencas_PI$Comunidade[Presencas_PI$Distrito == input$distritoInput])
    }
    
    updateSelectInput(
      session,
      "comunidadeAcompanhamento",
      choices = c("TODAS", sort(comunidades)),
      selected = "TODAS"
    )
  })
  
  # =========================
  # 🔁 UPDATE FACILITADOR
  # =========================
  observeEvent(
    list(input$distritoInput, input$comunidadeAcompanhamento), {
      
      df <- Presencas_PI
      
      if (input$distritoInput != "TODOS") {
        df <- df[df$Distrito == input$distritoInput, ]
      }
      
      if (input$comunidadeAcompanhamento != "TODAS") {
        df <- df[df$Comunidade == input$comunidadeAcompanhamento, ]
      }
      
      facilitadores <- unique(df$Facilitador)
      
      updateSelectInput(
        session,
        "facilitadorInput",
        choices = c("TODOS", sort(facilitadores)),
        selected = "TODOS"
      )
    }
  )
  
  # =========================
  # 📊 DADOS FILTRADOS + QUALIDADE
  # =========================
  dados_filtered <- reactive({
    
    df <- Presencas_PI
    
    if (input$distritoInput != "TODOS") {
      df <- df[df$Distrito == input$distritoInput, ]
    }
    
    if (input$comunidadeAcompanhamento != "TODAS") {
      df <- df[df$Comunidade == input$comunidadeAcompanhamento, ]
    }
    
    if (input$facilitadorInput != "TODOS") {
      df <- df[df$Facilitador == input$facilitadorInput, ]
    }
    
    col_sessoes <- grep("^Sessao", names(df), value = TRUE)
    
    # =========================
    # 📌 QUALIDADE DE DADOS (12 SESSÕES)
    # =========================
    total_sessoes_programa <- 12
    
    df <- df %>%
      dplyr::mutate(
        
        sessoes_preenchidas = rowSums(
          dplyr::across(all_of(col_sessoes), ~ !is.na(.) & . != ""),
          na.rm = TRUE
        ),
        
        taxa_preenchimento = round((sessoes_preenchidas / total_sessoes_programa) * 100, 1),
        
        taxa_preenchimento = ifelse(taxa_preenchimento > 100, 100, taxa_preenchimento),
        
        qualidade = dplyr::case_when(
          taxa_preenchimento >= 90 ~ "Excelente",
          taxa_preenchimento >= 70 ~ "Bom",
          taxa_preenchimento >= 50 ~ "Médio",
          TRUE ~ "Crítico"
        )
      )
    
    df <- df[rowSums(df[col_sessoes] == "Presente", na.rm = TRUE) > 0, ]
    
    df
  })
  
  # =========================
  # 📌 LEGENDA
  # =========================
  output$pontosPresenca <- renderUI({
    
    HTML(paste0(
      '<span style="color: purple; font-size: 25px;">&#9679;</span> Presente &nbsp;&nbsp;',
      '<span style="color: red; font-size: 25px;">&#9679;</span> Ausente &nbsp;&nbsp;',
      '<span style="color: grey; font-size: 25px;">&#9679;</span> Não Preenchido'
    ))
  })
  
  # =========================
  # 📋 TABELA (CRÍTICOS PRIMEIRO)
  # =========================
  output$tabelaPresencas <- renderDataTable({
    
    df <- dados_filtered()
    
    col_sessoes <- grep("^Sessao", names(df), value = TRUE)
    
    df[col_sessoes] <- lapply(df[col_sessoes], as.character)
    df[col_sessoes] <- lapply(df[col_sessoes], formatar_pontos)
    
    df$qualidade <- factor(
      df$qualidade,
      levels = c("Crítico", "Médio", "Bom", "Excelente")
    )
    
    datatable(
      df[order(df$qualidade), c(
        "Distrito",
        "Comunidade",
        "Facilitador",
        "Nome_Participante",
        "taxa_preenchimento",
        "qualidade",
        col_sessoes
      )],
      
      escape = FALSE,
      rownames = FALSE,
      
      options = list(
        pageLength = 10,
        dom = 'lfrtip',
        columnDefs = list(list(className = 'dt-center', targets = "_all"))
      )
    )
  })
  
  # =========================
  # 📥 DOWNLOAD
  # =========================
  output$downloadPresencas <- downloadHandler(
    
    filename = function() {
      paste0("Presencas_PI_", Sys.Date(), ".xlsx")
    },
    
    content = function(file) {
      
      library(writexl)
      
      df <- dados_filtered()
      
      col_sessoes <- grep("^Sessao", names(df), value = TRUE)
      
      df_export <- df[, c("Distrito", "Comunidade", "Nome_Participante", col_sessoes)]
      
      write_xlsx(df_export, path = file)
    }
  )
  
  # =========================
  # 🧠 TEXTO DINÂMICO (M&E)
  # =========================
  output$textoPresencas <- renderUI({
    
    df <- dados_filtered()
    
    total <- nrow(df)
    
    media <- round(mean(df$taxa_preenchimento, na.rm = TRUE), 1)
    
    criticos <- sum(df$qualidade == "Crítico")
    excelentes <- sum(df$qualidade == "Excelente")
    
    facilitadores_criticos <- df %>%
      dplyr::group_by(Facilitador) %>%
      dplyr::summarise(media = mean(taxa_preenchimento, na.rm = TRUE), .groups = "drop") %>%
      dplyr::filter(media < 60) %>%
      dplyr::pull(Facilitador)
    
    txt_facilitadores <- if (length(facilitadores_criticos) == 0) {
      "Nenhum facilitador crítico identificado."
    } else {
      paste(facilitadores_criticos, collapse = ", ")
    }
    
    div(
      style = "background-color:#f5f3f4; padding:12px; border-radius:6px;",
      
      tags$p(
        style = "margin:0; text-align:justify;",
        
        tags$b("📊 Qualidade de Dados do PI: "),
        
        "Foram analisados ", tags$b(total), " participantes. ",
        
        "A taxa média de preenchimento é de ", tags$b(paste0(media, "%")), ". ",
        
        tags$br(), tags$br(),
        
        "✔ Excelentes: ", tags$b(excelentes), " | ",
        "🔴 Críticos: ", tags$b(criticos), ". ",
        
        tags$br(), tags$br(),
        
        tags$b("⚠️ Facilitadores com baixa qualidade: "),
        txt_facilitadores,
        
        tags$br(), tags$br(),
        
        "Este painel permite monitoria contínua da qualidade de registo das sessões PI."
      )
    )
  })
  ################# MONITORIA BPA #########################
  # 
  # dados_filtrados_boaspraticas <- reactive({
  #   dados <- Presencas_BPA
  #   
  #   if (input$distritoInputboaspraticas != "Todos") {
  #     dados <- dados %>% filter(Distrito == input$distritoInputboaspraticas)
  #   }
  #   if (input$comunidadeInputboaspraticas != "Todos") {
  #     dados <- dados %>% filter(Comunidade == input$comunidadeInputboaspraticas)
  #   }
  #   
  #   dados
  # })
  # 
  # output$registradosboaspraticas <- renderPlotly({
  #   
  #   dados <- dados_filtrados_boaspraticas()
  #   
  #   if (nrow(dados) > 0) {
  #     
  #     eixo_x_var <- ifelse(
  #       input$comunidadeInputboaspraticas != "Todos",
  #       "Comunidade",
  #       "Distrito"
  #     )
  #     
  #     dados_agrupados <- dados %>%
  #       group_by(!!sym(eixo_x_var), Sexo) %>%
  #       summarise(n = n(), .groups = "drop") %>%
  #       group_by(!!sym(eixo_x_var)) %>%
  #       mutate(
  #         percent = round(n / sum(n) * 100, 1),
  #         label_text = paste0(n, " (", percent, "%)")
  #       )
  #     
  #     total_inscritos <- nrow(dados)
  #     
  #     plot_ly(
  #       data = dados_agrupados,
  #       x = ~get(eixo_x_var),
  #       y = ~n,
  #       color = ~Sexo,
  #       colors = c(
  #         "Feminino" = "#8054A2", "Masculino" = "#F37238"
  #       ),
  #       type = "bar",
  #       text = ~label_text,
  #       textposition = "outside"
  #     ) %>%
  #       layout(
  #         title = paste0(
  #           "Participantes Selecionad@s (Total: ",
  #           total_inscritos,
  #           ")"
  #         ),
  #         showlegend = TRUE,
  #         barmode = "group",
  #         paper_bgcolor = "#f5f3f4",
  #         plot_bgcolor  = "#f5f3f4",
  #         xaxis = list(title = eixo_x_var),
  #         yaxis = list(
  #           title = "Total de Inscritos",
  #           range = c(0, max(dados_agrupados$n) * 1.1)
  #         ),
  #         legend = list(title = list(text = "<b>Sexo</b>"))
  #       )
  #     
  #   } else {
  #     
  #     plot_ly() %>%
  #       layout(
  #         title = "Não há dados disponíveis para o filtro selecionado.",
  #         paper_bgcolor = "#f5f3f4",
  #         plot_bgcolor  = "#f5f3f4",
  #         xaxis = list(showticklabels = FALSE),
  #         yaxis = list(showticklabels = FALSE)
  #       )
  #   }
  # })
  # 
  # 
  
  # ############## Presencas BPA #############
  # 
  # output$grafic <- renderPlotly({
  #   
  #   dados_filtrados <- Presencas_BPA %>%
  #     filter(
  #       (input$distrito_presencas == "Todos" | Distrito == input$distrito_presencas),
  #       (input$comunidade_presencas == "Todos" | Comunidade == input$comunidade_presencas)
  #     )
  #   
  #   if (nrow(dados_filtrados) == 0) {
  #     return(
  #       plot_ly() %>%
  #         layout(
  #           title = "Não há dados disponíveis para os filtros selecionados.",
  #           paper_bgcolor = "#f5f3f4",
  #           plot_bgcolor  = "#f5f3f4",
  #           xaxis = list(showticklabels = FALSE),
  #           yaxis = list(showticklabels = FALSE)
  #         )
  #     )
  #   }
  #   
  #   dados_long <- dados_filtrados %>%
  #     pivot_longer(
  #       cols = starts_with("Sessão"),
  #       names_to = "Sessao",
  #       values_to = "Presenca"
  #     ) %>%
  #     filter(Presenca == "Presente")
  #   
  #   dados_agrupados <- dados_long %>%
  #     group_by(Sessao, Sexo) %>%
  #     summarise(Total = n(), .groups = "drop")
  #   
  #   ordem_sessoes <- dados_agrupados %>%
  #     distinct(Sessao) %>%
  #     mutate(Sessao_Num = readr::parse_number(Sessao)) %>%
  #     arrange(Sessao_Num) %>%
  #     pull(Sessao)
  #   
  #   dados_agrupados <- dados_agrupados %>%
  #     mutate(Sessao = factor(Sessao, levels = ordem_sessoes))
  #   
  #   totais_sessao <- dados_agrupados %>%
  #     group_by(Sessao) %>%
  #     summarise(total = sum(Total), .groups = "drop")
  #   
  #   dados_agrupados <- dados_agrupados %>%
  #     group_by(Sessao) %>%
  #     arrange(Sexo) %>%
  #     mutate(
  #       y0 = cumsum(lag(Total, default = 0)),
  #       y_center = y0 + Total / 2
  #     )
  #   
  #   annotations_segmentos <- lapply(seq_len(nrow(dados_agrupados)), function(i) {
  #     list(
  #       x = dados_agrupados$Sessao[i],
  #       y = dados_agrupados$y_center[i],
  #       text = dados_agrupados$Total[i],
  #       showarrow = FALSE,
  #       font = list(size = 12, color = "white")
  #     )
  #   })
  #   
  #   annotations_totais <- lapply(seq_len(nrow(totais_sessao)), function(i) {
  #     list(
  #       x = totais_sessao$Sessao[i],
  #       y = totais_sessao$total[i] + 5,
  #       text = paste("Total:", totais_sessao$total[i]),
  #       showarrow = FALSE,
  #       font = list(size = 12, color = "black")
  #     )
  #   })
  #   
  #   all_annotations <- c(annotations_segmentos, annotations_totais)
  #   
  #   plot_ly(
  #     data = dados_agrupados,
  #     x = ~Sessao,
  #     y = ~Total,
  #     color = ~Sexo,
  #     colors = c(
  #       "Feminino" = "#8054A2", "Masculino" = "#F37238"
  #     ),
  #     type = "bar",
  #     hovertemplate = paste(
  #       "%{x}<br>",
  #       "Sexo: %{color}<br>",
  #       "Presentes: %{y}<extra></extra>"
  #     )
  #   ) %>%
  #     layout(
  #       title = "Número de Presentes em cada Sessão",
  #       barmode = "stack",
  #       paper_bgcolor = "#f5f3f4",
  #       plot_bgcolor  = "#f5f3f4",
  #       xaxis = list(title = "Sessão"),
  #       yaxis = list(title = "Número de Presentes"),
  #       legend = list(title = list(text = "<b>Sexo</b>")),
  #       annotations = all_annotations
  #     )
  # })
  
  
  
  ########################## Desistentes
  
  
  # output$desistentes <- renderPlot({
  #   
  #   data <- dados_filtrados_boaspraticas()
  #   
  #   # Criar número de ausências
  #   data <- data %>%
  #     mutate(
  #       Num_Ausencias = rowSums(
  #         across(starts_with("Sessão"), ~ .x == "Ausente"),
  #         na.rm = TRUE
  #       )
  #     )
  #   
  #   # Criar status final
  #   data <- data %>%
  #     mutate(
  #       status_final = case_when(
  #         Num_Ausencias < 5 ~ "Concluiu com Sucesso",
  #         Num_Ausencias >= 5 & Num_Ausencias < 7 ~ "Concluiu a Formação",
  #         Num_Ausencias >= 7 & Num_Ausencias < 12 ~ "Desistente",
  #         TRUE ~ NA_character_
  #       )
  #     )
  #   
  #   # Filtrar apenas quem concluiu com sucesso
  #   data_filtrada <- data %>%
  #     filter(status_final == "Concluiu com Sucesso") %>%
  #     group_by(Distrito, Sexo) %>%
  #     summarise(Total = n(), .groups = "drop")
  #   
  #   # Gráfico
  #   ggplot(data_filtrada, aes(x = Distrito, y = Total, fill = Sexo)) +
  #     geom_bar(
  #       stat = "identity",
  #       position = position_dodge(width = 0.8),
  #       width = 0.6
  #     ) +
  #     geom_text(
  #       aes(label = Total),
  #       position = position_dodge(width = 0.8),
  #       vjust = 1.5,
  #       color = "white",
  #       size = 5,
  #       fontface = "bold"
  #     ) +
  #     scale_fill_manual(values = c(
  #       "Feminino" = "#9942D4",
  #       "Masculino" = "#F77333"
  #     )) +
  #     labs(
  #       title = "Participantes que Concluíram com Sucesso",
  #       x = "Distrito",
  #       y = "Número de Participantes",
  #       fill = "Sexo"
  #     ) +
  #     theme_stata(base_size = 12)
  # })
  # 
  
  
  
  
  
  ############ Acompanhamento Individual ############
  
  # # Função para formatar os pontos coloridos
  # formatar_pontos <- function(x) {
  #   sapply(x, function(valor) {
  #     if (is.na(valor) || valor == "" || is.null(valor)) {
  #       '<span style="color: grey; font-size: 30px;">&#9679;</span>'
  #     } else if (tolower(valor) == "presente") {
  #       '<span style="color: purple; font-size: 30px;">&#9679;</span>'
  #     } else if (tolower(valor) == "ausente") {
  #       '<span style="color: red; font-size: 30px;">&#9679;</span>'
  #     } else {
  #       '<span style="color: grey; font-size: 30px;">&#9679;</span>'
  #     }
  #   })
  # }
  # 
  # # Legenda visual
  # output$PontosPresencas <- renderUI({
  #   HTML(paste0(
  #     '<span style="color: purple; font-size: 25px;">&#9679;</span> Presente &nbsp;&nbsp;',
  #     '<span style="color: red; font-size: 25px;">&#9679;</span> Ausente &nbsp;&nbsp;',
  #     '<span style="color: grey; font-size: 25px;">&#9679;</span> Não Preenchido'
  #   ))
  # })
  # 
  # # Filtros dinâmicos em cascata
  # observeEvent(input$distrito_acompanhamento, {
  #   data <- Presencas_BPA
  #   if (input$distrito_acompanhamento != "Todos") {
  #     data <- data[data$Distrito == input$distrito_acompanhamento, ]
  #   }
  #   updateSelectInput(session, "comunidade_acompanhamento",
  #                     choices = c("Todos", unique(data$Comunidade)),
  #                     selected = "Todos")
  # })
  # 
  # observeEvent(input$comunidade_acompanhamento, {
  #   data <- Presencas_BPA
  #   if (input$comunidade_acompanhamento != "Todos") {
  #     data <- data[data$Comunidade == input$comunidade_acompanhamento, ]
  #   }
  #   updateSelectInput(session, "facilitador_acompanhamento",
  #                     choices = c("Todos", unique(data$Facilitador)),
  #                     selected = "Todos")
  # })
  # 
  # # Dados filtrados
  # dados_acompanhamento <- reactive({
  #   data <- Presencas_BPA
  #   
  #   if (input$distrito_acompanhamento != "Todos") {
  #     data <- data[data$Distrito == input$distrito_acompanhamento, ]
  #   }
  #   
  #   if (input$comunidade_acompanhamento != "Todos") {
  #     data <- data[data$Comunidade == input$comunidade_acompanhamento, ]
  #   }
  #   
  #   if (input$facilitador_acompanhamento != "Todos") {
  #     data <- data[data$Facilitador == input$facilitador_acompanhamento, ]
  #   }
  #   
  #   data
  # })
  # 
  # 
  # output$Individual <- renderDataTable({
  #   df <- dados_acompanhamento()
  #   
  #   
  #   col_sessoes <- grep("^Sess", names(df), value = TRUE)
  #   
  #   col_sessoes <- col_sessoes[order(as.numeric(gsub("\\D", "", col_sessoes)))]
  #   
  #   df[col_sessoes] <- lapply(df[col_sessoes], as.character)
  #   df[col_sessoes] <- lapply(df[col_sessoes], formatar_pontos)
  #   
  #   datatable(
  #     df[, c("Facilitador", "Nome_Participante", col_sessoes)],
  #     escape = FALSE,
  #     rownames = FALSE,
  #     options = list(
  #       pageLength = 10,
  #       dom = 'lfrtip',
  #       columnDefs = list(list(className = 'dt-center', targets = "_all"))
  #     )
  #   )
  # })
  # 
  # 
  
  ################################AVALIACAO#################
  #############QUALILDADE DAS SESSOES #####
  
  output$tabela_qualidade <- renderDT({
    datatable(dados_qualidade, options = list(pageLength = 10))
  })
  
  # ################ TABELA BENEFICIARIOS INDIRECTOS #############
  # 
  # # Criar versão filtrada reativa
  # beneficiarios_filtrados <- reactive({
  #   df <- Beneficiario_Indirectos
  #   
  #   # Mantém apenas Idade >= 18
  #   df <- df %>% filter(Idade >= 18)
  #   
  #   # Criar FaixaEtaria
  #   df <- df %>%
  #     mutate(FaixaEtaria = case_when(
  #       Idade >= 18 & Idade <= 35 ~ "Youth",
  #       Idade > 35 ~ "Non-Youth"
  #     ))
  #   
  #   # Aplicar filtro por Distrito
  #   if(input$distrito_facet != "Todos"){
  #     df <- df %>% filter(Distrito == input$distrito_facet)
  #   }
  #   
  #   df
  # })
  # 
  # output$resumo_benef <- renderDataTable({
  #   df <- beneficiarios_filtrados()
  #   
  #   benef_resumo <- df %>%
  #     group_by(Mes_Referencia, Distrito, Sexo, FaixaEtaria) %>%
  #     summarise(Total = n(), .groups = "drop")
  #   
  #   total_geral <- benef_resumo %>%
  #     summarise(Distrito = "Total Geral", Sexo = "", FaixaEtaria = "", Total = sum(Total))
  #   
  #   benef_resumo_final <- bind_rows(benef_resumo, total_geral)
  #   
  #   datatable(benef_resumo_final,
  #             options = list(pageLength = 10, dom = 'lfrtip'),
  #             rownames = FALSE)
  # })
  # 
  # output$grafico_benef <- renderPlotly({
  #   
  #   df <- beneficiarios_filtrados()
  #   
  #   # -------------------- Caso sem dados --------------------
  #   if (nrow(df) == 0) {
  #     return(
  #       plot_ly() %>%
  #         layout(
  #           title = "Não há dados disponíveis para os filtros selecionados.",
  #           paper_bgcolor = "#f5f3f4",
  #           plot_bgcolor  = "#f5f3f4",
  #           xaxis = list(showticklabels = FALSE),
  #           yaxis = list(showticklabels = FALSE)
  #         )
  #     )
  #   }
  #   
  #   # -------------------- Download Excel --------------------
  #   output$download_excel_benef <- downloadHandler(
  #     filename = function() {
  #       paste0("Beneficiarios_Resumo_", Sys.Date(), ".xlsx")
  #     },
  #     content = function(file) {
  #       
  #       benef_resumo <- df %>%
  #         group_by(Mes_Referencia, Distrito, Sexo, FaixaEtaria) %>%
  #         summarise(Total = n(), .groups = "drop")
  #       
  #       total_geral <- benef_resumo %>%
  #         summarise(
  #           Mes_Referencia = "",
  #           Distrito = "Total Geral",
  #           Sexo = "",
  #           FaixaEtaria = "",
  #           Total = sum(Total)
  #         )
  #       
  #       benef_resumo_final <- bind_rows(benef_resumo, total_geral)
  #       
  #       openxlsx::write.xlsx(benef_resumo_final, file)
  #     }
  #   )
  #   
  #   # -------------------- Dados para o gráfico --------------------
  #   benef_resumo_plot <- df %>%
  #     group_by(Distrito, Sexo, FaixaEtaria) %>%
  #     summarise(Total = n(), .groups = "drop") %>%
  #     group_by(Distrito) %>%
  #     mutate(
  #       Percent = Total / sum(Total) * 100,
  #       Label = paste0(Total, " (", round(Percent, 1), "%)")
  #     ) %>%
  #     ungroup()
  #   
  #   distritos <- unique(benef_resumo_plot$Distrito)
  #   
  #   # -------------------- Criar gráficos individuais --------------------
  #   plots <- lapply(seq_along(distritos), function(i) {
  #     
  #     dist <- distritos[i]
  #     df_dist <- benef_resumo_plot %>% filter(Distrito == dist)
  #     
  #     plot_ly(
  #       data = df_dist,
  #       x = ~FaixaEtaria,
  #       y = ~Total,
  #       color = ~Sexo,
  #       colors = c(
  #         "Feminino" = "#8054A2", "Masculino" = "#F37238"
  #       ),
  #       type = "bar",
  #       text = ~Label,
  #       textposition = "outside",
  #       showlegend = (i == 1)  # legenda só no primeiro
  #     ) %>%
  #       layout(
  #         xaxis = list(title = ""),
  #         yaxis = list(range = c(0, max(benef_resumo_plot$Total) * 1.2))
  #       )
  #   })
  #   
  #   # -------------------- Layout dos facets --------------------
  #   n_plots <- length(distritos)
  #   n_cols  <- 2
  #   n_rows  <- ceiling(n_plots / n_cols)
  #   
  #   # -------------------- Annotations (Distritos) --------------------
  #   annotations <- lapply(seq_along(distritos), function(i) {
  #     
  #     list(
  #       text = paste0("<b>Distrito: </b>", distritos[i]),
  #       x = ((i - 1) %% n_cols) / n_cols + (1 / (2 * n_cols)),
  #       y = 1 - (floor((i - 1) / n_cols) / n_rows),
  #       xref = "paper",
  #       yref = "paper",
  #       showarrow = FALSE,
  #       font = list(size = 13)
  #     )
  #   })
  #   
  #   # -------------------- Subplot final --------------------
  #   subplot(
  #     plots,
  #     nrows = n_rows,
  #     shareX = TRUE,
  #     shareY = TRUE
  #   ) %>%
  #     layout(
  #       title = list(
  #         text = "<b>Beneficiários Indiretos por Distrito</b>",
  #         font = list(size = 16)
  #       ),
  #       annotations = annotations,
  #       legend = list(
  #         title = list(text = "<b>Sexo</b>"),
  #         orientation = "h",
  #         x = 0.5,
  #         xanchor = "center",
  #         y = -0.18
  #       ),
  #       paper_bgcolor = "#f5f3f4",
  #       plot_bgcolor  = "#f5f3f4",
  #       yaxis = list(title = "Total de Beneficiários"),
  #       xaxis = list(title = "")
  #     )
  # })
  # 
  # 
  # 
  # # Tabela completa
  # output$beneficiarios_output <- renderDT({
  #   df <- beneficiarios_filtrados()
  #   
  #   # Remove colunas indesejadas
  #   df_para_tabela <- df %>% select(-`Data de Registo`, -Data_Registo, -Mes_Referencia)
  #   
  #   datatable(df_para_tabela, options = list(pageLength = 10))
  # })
  # 
  # output$download_beneficiarios <- downloadHandler(
  #   filename = function() {
  #     paste0("tabela_beneficiarios_", Sys.Date(), ".xlsx")
  #   },
  #   content = function(file) {
  #     
  #     df <- beneficiarios_filtrados()
  #     
  #     df_para_excel <- df %>% 
  #       select(-`Data de Registo`, -Data_Registo, -Mes_Referencia)
  #     
  #     writexl::write_xlsx(df_para_excel, file)
  #   }
  # )
  # 
  # ################# PAGINA POUPANCA
  # 
  # Grupos_Poupanca <- Grupos_Poupanca %>%
  #   mutate(
  #     Total_Feminino = parse_number(as.character(Total_Feminino)),
  #     Total_Masculino = parse_number(as.character(Total_Masculino)),
  #     Total_Membros_grupo = parse_number(as.character(Total_Membros_grupo))
  #   )
  # 
  # # Atualiza as comunidades conforme o distrito
  # # 1️⃣ Atualiza Comunidades conforme o Distrito
  # observe({
  #   req(input$filtro_poupanca)
  #   
  #   if (input$filtro_poupanca == "Todos") {
  #     comunidades <- unique(Grupos_Poupanca$Comunidade)
  #   } else {
  #     comunidades <- unique(Grupos_Poupanca %>% 
  #                             filter(Distrito == input$filtro_poupanca) %>% 
  #                             pull(Comunidade))
  #   }
  #   
  #   updateSelectInput(session, "filtro_comunidade",
  #                     choices = c("Todos", comunidades),
  #                     selected = "Todos")
  # })
  # 
  # # 2️⃣ Atualiza Grupos conforme a Comunidade selecionada
  # observe({
  #   req(input$filtro_comunidade)
  #   
  #   df <- Grupos_Poupanca
  #   
  #   if(input$filtro_comunidade != "Todos") {
  #     df <- df %>% filter(Comunidade == input$filtro_comunidade)
  #   }
  #   if(input$filtro_poupanca != "Todos") {
  #     df <- df %>% filter(Distrito == input$filtro_poupanca)
  #   }
  #   
  #   grupos <- unique(df$Nome_do_Grupo)
  #   
  #   updateSelectInput(session, "filtro_grupo",
  #                     choices = c("Todos", grupos),
  #                     selected = "Todos")
  # })
  # 
  # 
  # # Base filtrada
  # filtered_poupanca <- reactive({
  #   df <- Grupos_Poupanca
  #   if (input$filtro_poupanca != "Todos") {
  #     df <- df %>% filter(Distrito == input$filtro_poupanca)
  #   }
  #   if (input$filtro_comunidade != "Todos") {
  #     df <- df %>% filter(Comunidade == input$filtro_comunidade)
  #   }
  #   if (input$filtro_grupo != "Todos") {
  #     df <- df %>% filter(Nome_do_Grupo == input$filtro_grupo)
  #   }
  #   df
  # })
  # 
  # 
  # 
  # # Value boxes
  # output$total_grupos <- renderText({
  #   n_distinct(filtered_poupanca()$Nome_do_Grupo)
  # })
  # 
  # output$total_participantes <- renderText({
  #   df <- filtered_poupanca()
  #   
  #   total_fem <- sum(df$Total_Feminino, na.rm = TRUE)
  #   total_masc <- sum(df$Total_Masculino, na.rm = TRUE)
  #   
  #   # Usando símbolos ♂ e ♀
  #   paste0("\u2640 ", total_fem, " | \u2642 ", total_masc)
  # })
  # 
  # output$grafico_Participantes <- renderPlotly({
  #   
  #   dados_plot <- filtered_poupanca() %>%
  #     group_by(Distrito) %>%
  #     summarise(
  #       Total_Feminino = sum(Total_Feminino, na.rm = TRUE),
  #       Total_Masculino = sum(Total_Masculino, na.rm = TRUE),
  #       Total_Membros = sum(Total_Membros_grupo, na.rm = TRUE),
  #       .groups = "drop"
  #     )
  #   
  #   if (nrow(dados_plot) == 0) {
  #     return(
  #       plot_ly() %>%
  #         layout(
  #           title = "Não há dados disponíveis para os filtros selecionados.",
  #           paper_bgcolor = "#f5f3f4",
  #           plot_bgcolor  = "#f5f3f4",
  #           xaxis = list(showticklabels = FALSE),
  #           yaxis = list(showticklabels = FALSE)
  #         )
  #     )
  #   }
  #   
  #   dados_long <- dados_plot %>%
  #     tidyr::pivot_longer(
  #       cols = c(Total_Feminino, Total_Masculino),
  #       names_to = "Sexo",
  #       values_to = "Total"
  #     ) %>%
  #     mutate(
  #       Sexo = recode(Sexo,
  #                     "Total_Feminino" = "Feminino",
  #                     "Total_Masculino" = "Masculino")
  #     )
  #   
  #   plot_ly(
  #     data = dados_long,
  #     x = ~Distrito,
  #     y = ~Total,
  #     color = ~Sexo,
  #     colors = c("Feminino" = "#8054A2", "Masculino" = "#F37238"),
  #     type = "bar",
  #     text = ~Total,
  #     textposition = "outside"
  #   ) %>%
  #     layout(
  #       title = list(
  #         text = "Participantes por Distrito",
  #         font = list(size = 16, face = "bold")
  #       ),
  #       barmode = "group",
  #       paper_bgcolor = "#f5f3f4",
  #       plot_bgcolor  = "#f5f3f4",
  #       xaxis = list(title = "Distrito"),
  #       yaxis = list(title = "Número de Participantes"),
  #       legend = list(title = list(text = "<b>Sexo</b>"))
  #     )
  # })
  # 
  # ######### Poupanças
  # 
  # 
  # filtered_valores <- reactive({
  #   df <- Geral_Poupanca
  #   
  #   # Filtro Distrito
  #   if (input$filtro_distrito_valores != "Todos") {
  #     df <- df %>% filter(Distrito == input$filtro_distrito_valores)
  #   }
  #   
  #   # Filtro Comunidade
  #   if (input$filtro_comunidade_valores != "Todos") {
  #     df <- df %>% filter(Comunidade == input$filtro_comunidade_valores)
  #   }
  #   
  #   # Filtro Grupo
  #   if (input$filtro_grupo_valores != "Todos") {
  #     df <- df %>% filter(Nome_Grupo == input$filtro_grupo_valores)
  #   }
  #   
  #   df
  # })
  # 
  # # -------------------- ATUALIZAR COMUNIDADES --------------------
  # observeEvent(input$filtro_distrito_valores, {
  #   comunidades <- Geral_Poupanca %>%
  #     filter(if (input$filtro_distrito_valores == "Todos") TRUE else Distrito == input$filtro_distrito_valores) %>%
  #     pull(Comunidade) %>% unique()
  #   
  #   updateSelectInput(session, "filtro_comunidade_valores",
  #                     choices = c("Todos", comunidades),
  #                     selected = "Todos")
  # })
  # 
  # # -------------------- ATUALIZAR GRUPOS --------------------
  # observeEvent(input$filtro_comunidade_valores, {
  #   grupos <- Geral_Poupanca %>%
  #     filter(if (input$filtro_comunidade_valores == "Todos") TRUE else Comunidade == input$filtro_comunidade_valores) %>%
  #     pull(Nome_Grupo) %>% unique()
  #   
  #   updateSelectInput(session, "filtro_grupo_valores",
  #                     choices = c("Todos", grupos),
  #                     selected = "Todos")
  # })
  # 
  # # -------------------- BOXES --------------------
  # output$total_poupanca <- renderText({
  #   sum(filtered_valores()$Poupanca_Sessao, na.rm = TRUE)
  # })
  # 
  # output$total_emprestimo <- renderText({
  #   sum(filtered_valores()$Valor_Emprestimo, na.rm = TRUE)
  # })
  # 
  # output$total_Fundo_Social <- renderText({
  #   sum(filtered_valores()$Fundo_Social, na.rm = TRUE)
  # })
  # 
  # ###################### Graficos Todas Metricas
  # 
  # # Filtra os dados de acordo com os inputs
  # filtered_valores <- reactive({
  #   df <- Geral_Poupanca
  #   
  #   if(input$filtro_distrito_valores != "Todos"){
  #     df <- df[df$Distrito == input$filtro_distrito_valores, ]
  #   }
  #   
  #   if(input$filtro_comunidade_valores != "Todos"){
  #     df <- df[df$Comunidade == input$filtro_comunidade_valores, ]
  #   }
  #   
  #   if(input$filtro_grupo_valores != "Todos"){
  #     df <- df[df$Nome_Grupo == input$filtro_grupo_valores, ]
  #   }
  #   
  #   df
  # })
  # 
  # # Atualiza opções de grupo dinamicamente quando a comunidade muda
  # observeEvent(input$filtro_comunidade_valores, {
  #   grupos <- Geral_Poupanca %>%
  #     filter(if (input$filtro_comunidade_valores == "Todos") TRUE else Comunidade == input$filtro_comunidade_valores) %>%
  #     pull(Nome_Grupo) %>% unique()
  #   
  #   updateSelectInput(session, "filtro_grupo_valores",
  #                     choices = c("Todos", grupos),
  #                     selected = "Todos")
  # })
  # 
  # output$grafico_valores <- renderPlotly({
  #   
  #   df <- filtered_valores() %>%
  #     group_by(Distrito) %>%
  #     summarise(
  #       Poupanca = sum(Poupanca_Sessao, na.rm = TRUE),
  #       Emprestimo = sum(Valor_Emprestimo, na.rm = TRUE),
  #       Fundo_Social = sum(Fundo_Social, na.rm = TRUE),
  #       .groups = "drop"
  #     ) %>%
  #     tidyr::pivot_longer(
  #       cols = c(Poupanca, Emprestimo, Fundo_Social),
  #       names_to = "Tipo",
  #       values_to = "Valor"
  #     ) %>%
  #     mutate(
  #       Tipo = factor(Tipo, levels = c("Poupanca", "Emprestimo", "Fundo_Social"))
  #     )
  #   
  #   if (nrow(df) == 0) {
  #     return(
  #       plot_ly() %>%
  #         layout(
  #           title = "Não há dados disponíveis para os filtros selecionados.",
  #           paper_bgcolor = "#f5f3f4",
  #           plot_bgcolor  = "#f5f3f4",
  #           xaxis = list(showticklabels = FALSE),
  #           yaxis = list(showticklabels = FALSE)
  #         )
  #     )
  #   }
  #   
  #   distritos <- unique(df$Distrito)
  #   
  #   plots <- lapply(distritos, function(dist) {
  #     
  #     df_dist <- df %>% filter(Distrito == dist)
  #     
  #     plot_ly(
  #       data = df_dist,
  #       x = ~Tipo,
  #       y = ~Valor,
  #       type = "bar",
  #       marker = list(color = c(
  #         "Poupanca" = "#69C7BE",
  #         "Emprestimo" = "#F37238",
  #         "Fundo_Social" = "#8054A2"
  #       )[as.character(df_dist$Tipo)]),
  #       text = ~Valor,
  #       textposition = "outside"
  #     ) %>%
  #       layout(
  #         # Adiciona o nome do Distrito como annotation no topo do gráfico
  #         annotations = list(
  #           list(
  #             x = 0.5,        # centralizado horizontalmente
  #             y = max(df_dist$Valor) * 1.05,
  #             text = dist,
  #             xref = "paper",
  #             yref = "y",
  #             showarrow = FALSE,
  #             font = list(size = 14, face = "bold"),
  #             xanchor = "center"
  #           )
  #         ),
  #         yaxis = list(range = c(0, 500000)),
  #         xaxis = list(title = ""),
  #         showlegend = FALSE
  #       )
  #   })
  #   
  #   subplot(
  #     plots,
  #     nrows = ceiling(length(plots)/2),
  #     shareX = TRUE,
  #     shareY = TRUE,
  #     titleX = TRUE,
  #     titleY = TRUE
  #   ) %>%
  #     layout(
  #       title = list(
  #         text = "Valores por Distrito",
  #         font = list(size = 16, face = "bold")
  #       ),
  #       paper_bgcolor = "#f5f3f4",
  #       plot_bgcolor  = "#f5f3f4",
  #       legend = list(title = list(text = "<b>Tipo</b>")),
  #       yaxis = list(title = "Valor (MT)"),
  #       xaxis = list(title = "Tipo")
  #     )
  # })
  # 
  # 
  # 
  # 
  # # -------------------- Gráfico Poupança com rótulos --------------------
  # output$grafico_valores_poupanca <- renderPlot({
  #   df <- filtered_valores() %>%
  #     group_by(Nome_Sessao) %>%
  #     summarise(Poupanca_Sessao = sum(Poupanca_Sessao, na.rm = TRUE)) %>%
  #     mutate(
  #       Numero_Sessao = as.numeric(gsub("\\D", "", Nome_Sessao)),  
  #       Nome_Sessao = reorder(Nome_Sessao, Numero_Sessao)         
  #     )
  #   
  #   ggplot(df, aes(x = Nome_Sessao, y = Poupanca_Sessao, group = 1)) +
  #     geom_line(color = "#69C7BE", size = 1.5) +
  #     geom_point(size = 3, color = "#69C7BE") +
  #     geom_text(aes(label = Poupanca_Sessao), vjust = -0.5, size = 5, color = "black") +
  #     labs(
  #       title = "Poupança por Sessão",
  #       x = "Sessão",
  #       y = "Valor Poupado"
  #     ) +
  #     theme_stata() +
  #     theme(
  #       axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)  
  #     )
  # })
  # 
  # 
  # # -------------------- Gráfico Empréstimos com rótulos --------------------
  # output$grafico_valores_emprestimo <- renderPlot({
  #   df <- filtered_valores() %>%
  #     group_by(Nome_Sessao) %>%
  #     summarise(Valor_Emprestimo = sum(Valor_Emprestimo, na.rm = TRUE)) %>%
  #     mutate(
  #       Numero_Sessao = as.numeric(gsub("\\D", "", Nome_Sessao)),  
  #       Nome_Sessao = reorder(Nome_Sessao, Numero_Sessao)          
  #     )
  #   
  #   ggplot(df, aes(x = Nome_Sessao, y = Valor_Emprestimo, group = 1)) +
  #     geom_line(color = "#F37238", size = 1.5) +
  #     geom_point(size = 3, color = "#F37238") +
  #     geom_text(aes(label = Valor_Emprestimo), vjust = -0.5, size = 5, color = "black") +
  #     labs(
  #       title = "Empréstimos por Sessão",
  #       x = "Sessão",
  #       y = "Valor Emprestado"
  #     ) +
  #     theme_stata() +
  #     theme(
  #       axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)  
  #     )
  # })
  # 
  # 
  # # -------------------- Tabela interativa --------------------
  # # output$tabela_valores_poupanca <- renderDT({
  # #   # usa a base filtrada
  # #   df <- filtered_valores()
  # #   
  # #   # opcional: organizar colunas importantes primeiro
  # #   df <- df %>%
  # #     select(Distrito, Comunidade, Facilitador, Nome_Sessao,
  # #            Membros_Feminino_Presentes, Membros_Masculino_Presentes,
  # #            Poupanca_Sessao, Valor_Emprestimo, Divida_Paga, Divida_Acumulada,
  # #            Poupanca_Acumulada, everything())
  # #   
  # #   datatable(df,
  # #             rownames = FALSE,
  # #             options = list(
  # #               pageLength = 10,    # linhas por página
  # #               scrollX = TRUE,     # scroll horizontal se muitas colunas
  # #               autoWidth = TRUE,   # ajustar largura automaticamente
  # #               dom = 'Bfrtip',     # botões de exportação
  # #               buttons = c('copy', 'csv', 'excel', 'pdf')
  # #             ),
  # #             extensions = 'Buttons')
  # # })
  # # 
  # ########################## MENTORIA
  # 
  # # ------------------------------
  # # Atualiza Comunidades com base no Distrito selecionado
  # # ------------------------------
  # observe({
  #   req(input$filtro_distrito_ment)  # garante que o input existe
  #   
  #   df <- Lista_Mentoria_Abrindo
  #   
  #   # Filtra Distrito se não for "Todos"
  #   if (input$filtro_distrito_ment != "Todos") {
  #     df <- df[df$Distrito == input$filtro_distrito_ment, ]
  #   }
  #   
  #   comunidades <- sort(unique(df$Comunidade))
  #   comunidades <- c("Todos", comunidades)
  #   
  #   updateSelectInput(
  #     session,
  #     "filtro_comunidade_ment",
  #     choices = comunidades,
  #     selected = "Todos"
  #   )
  # })
  # 
  # # ------------------------------
  # # Dados filtrados (reactive)
  # # ------------------------------
  # dados_filtrados_mentoria <- reactive({
  #   df <- Lista_Mentoria_Abrindo
  #   
  #   if (input$filtro_distrito_ment != "Todos") {
  #     df <- df[df$Distrito == input$filtro_distrito_ment, ]
  #   }
  #   
  #   if (input$filtro_comunidade_ment != "Todos") {
  #     df <- df[df$Comunidade == input$filtro_comunidade_ment, ]
  #   }
  #   
  #   df
  # })
  # 
  # # ------------------------------
  # # Gráfico Plotly
  # # ------------------------------
  # output$grafico_mentoria_1 <- renderPlotly({
  #   df <- dados_filtrados_mentoria()
  #   
  #   if(nrow(df) == 0){
  #     return(plot_ly() %>%
  #              layout(title = "Nenhum dado disponível para o filtro selecionado",
  #                     paper_bgcolor = "#f5f3f4",
  #                     plot_bgcolor  = "#f5f3f4",
  #                     xaxis = list(showticklabels = FALSE),
  #                     yaxis = list(showticklabels = FALSE)))
  #   }
  #   
  #   tabela <- df %>%
  #     dplyr::group_by(Distrito, Sexo) %>%
  #     dplyr::summarise(Total = n(), .groups = "drop") %>%
  #     dplyr::group_by(Distrito) %>%
  #     dplyr::mutate(
  #       Percent = round(Total / sum(Total) * 100, 1),
  #       label_text = paste0(Total, " (", Percent, "%)")
  #     )
  #   
  #   plot_ly(
  #     data = tabela,
  #     x = ~Distrito,
  #     y = ~Total,
  #     color = ~Sexo,
  #     colors = c("Feminino" = "#8054A2", "Masculino" = "#F37238"),
  #     type = "bar",
  #     text = ~label_text,
  #     textposition = "outside"
  #   ) %>%
  #     layout(
  #       title = "Participantes por Distrito",
  #       showlegend = TRUE,
  #       paper_bgcolor = "#f5f3f4",
  #       plot_bgcolor = "#f5f3f4",
  #       yaxis = list(title = "Total de Participantes", range = c(0, 200)),
  #       xaxis = list(title = ""),
  #       barmode = "group"
  #     )
  # })
  # 
  # 
  # 
  # output$grafico_mentoria_2 <- renderPlotly({
  #   
  #   df <- dados_filtrados_mentoria()
  #   
  #   # Filtra apenas quem tem negócio
  #   df <- df[df$Tem_Negocio == "Sim", ]
  #   
  #   # Tabela resumida por Distrito e Sexo
  #   tabela <- df %>%
  #     group_by(Distrito, Sexo) %>%
  #     summarise(Total = n(), .groups = "drop") %>%
  #     group_by(Distrito) %>%
  #     mutate(
  #       Percent = round(Total / sum(Total) * 100, 1),
  #       label_text = paste0(Total, " (", Percent, "%)")
  #     )
  #   
  #   # Gráfico de barras Plotly
  #   plot_ly(
  #     data = tabela,
  #     x = ~Distrito,
  #     y = ~Total,
  #     color = ~Sexo,
  #     colors = c("Feminino" = "#8054A2", "Masculino" = "#F37238"),
  #     type = "bar",
  #     text = ~label_text,
  #     textposition = "outside"
  #   ) %>% 
  #     layout(
  #       title = "",
  #       showlegend = TRUE,
  #       paper_bgcolor = "#f5f3f4",
  #       plot_bgcolor = "#f5f3f4",
  #       yaxis = list(title = "Total com Negócio", range = c(0, 200)),
  #       xaxis = list(title = ""),
  #       barmode = "group"
  #     )
  # })
  # 
  # 
  # 
  # 
  # 
  # output$tabela_mentoria <- renderDT({
  #   dados_filtrados_mentoria()
  # })
  # 
  
  #################### BOTAO ############################
  
  # ==============================
  # 🖥️ UI DINÂMICA
  # ==============================
  output$admin_ui <- renderUI({
    
    tagList(
      
      # ================= CSS =================
      tags$head(
        tags$style(HTML("
        .btn-purple {
          background-color: #6f42c1;
          color: white;
          border: none;
        }
        .btn-purple:hover {
          background-color: #5a32a3;
          color: white;
        }
      "))
      ),
      
      # ================= USER (placeholder seguro) =================
      tags$script(HTML("
      Shiny.setInputValue('user_email', 'admin@empresa.com');
    ")),
      
      # ================= LAYOUT =================
      fluidRow(
        
        column(
          4,
          p("Clique no botão abaixo para actualizar os dados do sistema."),
          actionButton(
            "botao_atualizar",
            label = HTML('<i class="fa fa-refresh"></i> Atualizar Dados'),
            class = "btn btn-purple"
          )
        ),
        
        column(
          8,
          
          verbatimTextOutput("status_atualizacao"),
          
          tags$div(
            style = "margin-top: 10px;",
            downloadButton("baixar_log", label = NULL, class = "btn btn-success"),
            tags$script(HTML("
            $(document).ready(function() {
              $('#baixar_log').html('<i class=\"fa fa-download\"></i> Baixar Log de Ações');
            });
          "))
          )
        )
      ),
      
      hr(),
      
      h4("📊 Histórico de Ações"),
      DTOutput("tabela_log")
    )
  })
  
  # ==============================
  # ⚙️ FUNÇÃO DE ATUALIZAÇÃO (ZOHO API)
  # ==============================
  atualiza_dados <- function() {
    
    tryCatch({
      
      client_id <- Sys.getenv("CLIENT_ID")
      client_secret <- Sys.getenv("CLIENT_SECRET")
      refresh_token <- Sys.getenv("REFRESH_TOKEN")
      
      access_token <- RZohoCreator::refresh_access_token(
        client_id,
        client_secret,
        refresh_token
      )$access_token
      
      Presencas_Colectivas <- RZohoCreator::get_records(
        "associacaomuva",
        "monitoria-edm",
        "lista_presencaKM",
        access_token
      )
      
      writexl::write_xlsx(Presencas_Colectivas, "Presencas_Colectivas.xlsx")
      
      Qualidade_Sessoes <- RZohoCreator::get_records(
        "associacaomuva",
        "monitoria-edm",
        "Qualidade_Sessoes_Abrindo_Report",
        access_token
      )
      
      writexl::write_xlsx(Qualidade_Sessoes, "Qualidade_Sessoes.xlsx")
      
      TRUE
      
    }, error = function(e) {
      message("Erro ao atualizar dados: ", e$message)
      FALSE
    })
  }
  
  # ==============================
  # 🧾 FUNÇÃO DE LOG (PROFISSIONAL)
  # ==============================
  write_log <- function(entry) {
    
    if (!file.exists(log_path)) {
      write.table(
        entry,
        log_path,
        sep = ",",
        row.names = FALSE,
        col.names = TRUE
      )
    } else {
      write.table(
        entry,
        log_path,
        sep = ",",
        row.names = FALSE,
        col.names = FALSE,
        append = TRUE
      )
    }
  }
  
  # ==============================
  # 🔁 EVENTO PRINCIPAL (SEM DUPLICAÇÃO)
  # ==============================
  observeEvent(input$botao_atualizar, {
    
    update_status("running")
    
    usuario <- ifelse(isTruthy(input$user_email),
                      input$user_email,
                      "desconhecido")
    
    sucesso <- atualiza_dados()
    
    log_entry <- data.frame(
      usuario = usuario,
      acao = "UPDATE_DADOS",
      resultado = ifelse(sucesso, "SUCESSO", "ERRO"),
      origem = "ADMIN_PANEL",
      timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      stringsAsFactors = FALSE
    )
    
    write_log(log_entry)
    
    update_status(ifelse(sucesso, "success", "error"))
  })
  
  # ==============================
  # 📢 STATUS (SEM REEXECUÇÃO)
  # ==============================
  output$status_atualizacao <- renderText({
    
    if (update_status() == "running") {
      "⏳ A atualizar dados..."
    } else if (update_status() == "success") {
      "✅ Dados atualizados com sucesso"
    } else if (update_status() == "error") {
      "❌ Erro ao atualizar dados"
    } else {
      "⏳ Aguardando ação..."
    }
  })
  
  # ==============================
  # 📊 LOG REATIVO (EFICIENTE)
  # ==============================
  log_data <- reactiveFileReader(
    intervalMillis = 2000,
    session = session,
    filePath = log_path,
    readFunc = function(file) {
      if (file.exists(file)) {
        read.csv(file, stringsAsFactors = FALSE)
      } else {
        data.frame()
      }
    }
  )
  
  output$tabela_log <- renderDT({
    
    datatable(
      log_data(),
      options = list(
        pageLength = 10,
        order = list(list(4, 'desc'))
      ),
      rownames = FALSE
    )
  })
  
  # ==============================
  # 📥 DOWNLOAD LOG
  # ==============================
  output$baixar_log <- downloadHandler(
    
    filename = function() {
      paste0("log_acoes_", Sys.Date(), ".csv")
    },
    
    content = function(file) {
      file.copy(log_path, file)
    }
  )
}
shinyApp(ui, server)
