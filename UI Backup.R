library(shinydashboard)
library(shiny)
library(visNetwork)
library(igraph)
library(statnet)
library(shinyBS)

dashboardPage(
  dashboardHeader(title = "GRAFOS"),
  # Lateral del Dashboard
  dashboardSidebar(sidebarMenu(
    menuItem(
      "Visualización Grafo",
      tabName = "part1",
      icon = icon("dashboard")
    ),
    menuItem("Contacto", tabName = "part2", icon = icon("rocket"))
  )),
  # Fin del lateral del Dashboard
  
  # Cuerpo del Dashboard
  dashboardBody(tabItems(
    # Inicio Cuerpo Pestaña 1 Dasboard
    tabItem(
      tabName = "part1",
      # Cuerpo del UI Pestaña 1
      fluidPage(
        # Application title
        titlePanel("GRAFOS"),
        
        # Sidebar with a slider input for number of bins
        sidebarLayout(
          sidebarPanel(
            # Lista desplegable con el tipo de algoritmo de generación de grafos aleatorios que se ofrecen:
            
            selectInput(inputId="algorithm", 
                        label= h4("Algoritmo",bsButton("q1", label = "", icon = icon("question"),style = "info", size = "extra-small")), 
                        choices = c("Random network model (Erdős-Rényi)" = "erdos",
                                    "Scale free network (Barabási-Albert)"= "albert"
                        )),
            
            bsPopover(id = "q1", title = "Información",
                      content = paste0("You should read the "),
                      placement = "right", 
                      trigger = "hover", 
                      options = list(container = "body")
            ),
            # Campo editable con el número de nodos que se quiere para el grafo aleatrio.
            numericInput("nnodes", 
                         label = h4("Número de nodos",
                                    bsButton("q2", label = "", icon = icon("question"),style = "info", size = "extra-small")), 
                         4, step = 1, min = 1),
            
            bsPopover(id = "q2", title = "Información",
                      content = paste0("You should read the "),
                      placement = "right", 
                      trigger = "hover", 
                      options = list(container = "body")
            ),
            
            # Campo en el que se selecciona el porcentaje de probabilidad que se desea que exista 
            # a la hora de dibujar conexiones entre dos nodos aleatorios.
            numericInput("conexion", value = 70, min=1, max=100, step = 1, 
                         label = h4("% de conexiones",
                                    bsButton("q3", label = "", icon = icon("question"),style = "info", size = "extra-small"))),
            
            bsPopover(id = "q3", title = "Información",
                      content = paste0("You should read the "),
                      placement = "right", 
                      trigger = "hover", 
                      options = list(container = "body")
            ),
            
            # Botón que habrá que pulsar para general el grafo cada vez que se modifiquen 
            # los parámetros de los numeric inputs
            
            actionButton("generate", label = "Generar grafo"),
            box(width = 15,
                title = p("Análisis de comunidades",  bsButton("q4", label = "", icon = icon("question"),
                                                               style = "info", size = "extra-small"),
                          
                          bsPopover(id = "q4", title = "Información",
                                    content = paste0("You should read the "),
                                    placement = "right", 
                                    trigger = "hover", 
                                    options = list(container = "body")
                          ),
                          actionButton("comunidad1", label = "Edge Betweeness"), 
                          
                          
                          bsButton("q5", label = "", icon = icon("question"),
                                   style = "info", size = "extra-small"),
                          bsPopover(id = "q5", title = "Información",
                                    content = paste0("You should read the "),
                                    placement = "right", 
                                    trigger = "hover", 
                                    options = list(container = "body")
                          ),
                          
                          actionButton("comunidad2", label = "Walktrap Method"),
                          bsButton("q6", label = "", icon = icon("question"),
                                   style = "info", size = "extra-small"),
                          bsPopover(id = "q6", title = "Información",
                                    content = paste0("You should read the "),
                                    placement = "right", 
                                    trigger = "hover", 
                                    options = list(container = "body")
                          ),
                          actionButton("centralidad1", label = "Centralidad 1 - Betweenness"),
                          bsButton("q7", label = "", icon = icon("question"),
                                   style = "info", size = "extra-small"),
                          bsPopover(id = "q7", title = "Información",
                                    content = paste0("You should read the "),
                                    placement = "right", 
                                    trigger = "hover", 
                                    options = list(container = "body")
                          ),
                          actionButton("centralidad2", label = "Centralidad 2 - Kleinberg"),
                          bsButton("q8", label = "", icon = icon("question"),
                                   style = "info", size = "extra-small"),
                          bsPopover(id = "q8", title = "Información",
                                    content = paste0("You should read the "),
                                    placement = "right", 
                                    trigger = "hover", 
                                    options = list(container = "body")
                          )
                )
            )
            
            
            
            
          ),
          
          # A continuación añadimos los Outputs que se verán:
          mainPanel(
            # Output del propio grafo:
            visNetworkOutput("grafica"),
            # Output de texto en el que aparecerá el # de nodo seleccionado
            tableOutput('view_id'),
            # Output de texto en el que aparecerá la centralidad del nodo seleccionado.
            tableOutput("close"),
            tableOutput("between"),
            tableOutput("klein"),
            tableOutput("comun1"),
            tableOutput("comun2")
          )
          
          
        )
      )
    ),
    # Fin Cuerpo Pestaña 1 Dashboard
    
    # Inicio Pestaña 2 Dashboard
    tabItem(tabName = "part2",
            fluidPage(
              titlePanel("Datos de contacto del autor")
            ))
    
  ))
)

