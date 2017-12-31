library(shinydashboard)
library(shiny)
library(visNetwork)
library(igraph)
library(statnet)

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
            selectInput(inputId="algorithm", label="Algoritmo", choices = c("Random network model (Erdős-Rényi)" = "erdos",
                                                                            "Small world (Watts-Strogatz)" = "watts",
                                                                            "Scale free network (Barabási-Albert)"= "albert"
            )),
            # Campo editable con el número de nodos que se quiere para el grafo aleatrio.
            numericInput("nnodes", label = "Número de nodos", 2, step = 1),
            
            # Campo en el que se selecciona el porcentaje de probabilidad que se desea que exista 
            # a la hora de dibujar conexiones entre dos nodos aleatorios.
            textInput(
              "conexion",
              value = 1,
              label = "Porcentaje de conexiones"
            ),
            
            actionButton("generate", label = "Generar grafo"),
            actionButton("download", label = "Descargar grafo")
            
            
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
            #Output de la gráfica y verbatim:
            visNetworkOutput("grafica"),
            verbatimTextOutput("distancia"),
            verbatimTextOutput("centroide")
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



