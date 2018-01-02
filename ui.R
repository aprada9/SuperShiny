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
            numericInput("nnodes", label = "Número de nodos", 4, step = 1),
            
            # Campo en el que se selecciona el porcentaje de probabilidad que se desea que exista 
            # a la hora de dibujar conexiones entre dos nodos aleatorios.
            numericInput("conexion", value = 70, min=1, max=100, step = 1, label = "% de conexiones"),
            
            # Botón que habrá que pulsar para general el grafo cada vez que se modifiquen 
            # los parámetros de los numeric inputs
            actionButton("generate", label = "Generar grafo")
           
            
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


