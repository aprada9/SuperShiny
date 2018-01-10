library(shinydashboard)
library(shiny)
library(visNetwork)
library(igraph)
library(statnet)
library(shinyBS)

dashboardPage(
  dashboardHeader(title = "GRAFOS"),
  # Lateral del Dashboard
  dashboardSidebar(
    sidebarMenu(
      #sidebarPanel(
      # Lista desplegable con el tipo de algoritmo de generación de grafos aleatorios que se ofrecen:
      # los div son para poder poner el boton de dudas a la misma altura.
      div(
        div(
          style="width:80%; display:inline-block; vertical-align: top;",
          selectInput(
            inputId = "algorithm",
            label = "Algoritmo",
            choices = c(
              "Random network" = "erdos",
              "Scale free network" = "albert"
            )
            
          )
        ),
        div(
          style="display:inline-block; vertical-align: middle;",
          bsButton(
            "q1",
            label = "",
            icon = icon("question"),
            style = "info",
            size = "extra-small"
          ),
          bsPopover(
            id = "q1",
            title = "Información",
            content = paste0("Selección del algoritmo de generación de grafos aleatorio."),
            placement = "right",
            trigger = "hover",
            options = list(container = "body")
          )
        )
      ),
      
      
      # Campo editable con el número de nodos que se quiere para el grafo aleatrio.
      div(
        div(
          style="width:80%; display:inline-block; vertical-align: top;",
          numericInput(
            "nnodes",
            label = "Número de nodos",
            4,
            step = 1,
            min = 1
          )),
        div(
          style="display:inline-block; vertical-align: middle;",
          bsButton(
            "q2",
            label = "",
            icon = icon("question"),
            style = "info",
            size = "extra-small"
          ),
          bsPopover(
            id = "q2",
            title = "Información",
            content = paste0("Selecciona el número de nodos que quieres que contenga tu grafo.  ADVERTENCIA: Si se elige un número de nodos muy elevado el grafo tardará un tiempo significativo en generarse."),
            placement = "right",
            trigger = "hover",
            options = list(container = "body")
          ))),
      
      # Campo en el que se selecciona el porcentaje de probabilidad que se desea que exista
      # a la hora de dibujar conexiones entre dos nodos aleatorios.
      div(
        div(
          style="width:80%; display:inline-block; vertical-align: top;",
          numericInput(
            "conexion",
            value = 70,
            min = 1,
            max = 100,
            step = 1,
            label ="% de conexiones"
          )
        ),
        div(
          style="display:inline-block; vertical-align: middle;",
          bsButton(
            "q3",
            label = "",
            icon = icon("question"),
            style = "info",
            size = "extra-small"
          ),
          bsPopover(
            id = "q3",
            title = "Información",
            content = paste0("Elige el porcentaje de conexiones que deseas que haya entre nodos."),
            placement = "right",
            trigger = "hover",
            options = list(container = "body")
          ))
      ),
      
      # Botón que habrá que pulsar para general el grafo cada vez que se modifiquen
      # los parámetros de los numeric inputs
      
      actionButton("generate", label = "Generar grafo"),
      
      menuItem(div(
        div( style="width:80%; display:inline-block; vertical-align: middle;",
             "Análisis de comunidades"),
        div(style="display:inline-block; vertical-align: middle;",
            bsButton(
              "q9",
              label = "",
              icon = icon("question"),
              style = "info",
              size = "extra-small"
            ),
            bsPopover(
              id = "q9",
              title = "Información",
              content = paste0("El análisis de comunidades diferenciará los nodos por colores en función de la comunidad a la que pertenezcan."),
              placement = "right",
              trigger = "hover",
              options = list(container = "body")
            )
        )),
        
        
        div(
          div(style="width:80%; display:inline-block; vertical-align: middle;",
              actionButton("comunidad1", label = "Edge Betweeness", width = '100%')
          ),
          div(style="display:inline-block; vertical-align: middle;",
              bsButton(
                "q5",
                label = "",
                icon = icon("question"),
                style = "info",
                size = "extra-small"
              ),
              bsPopover(
                id = "q5",
                title = "Información",
                content = paste0("Se llevará a cabo el análisis de comunidades en base al algoritmo de Edge Betweeness"),
                placement = "right",
                trigger = "hover",
                options = list(container = "body")
              )
          )
        ),
        
        div(  
          div(style="width:80%; display:inline-block; vertical-align: middle;",
              actionButton("comunidad2", label = "Walktrap Method", width = '100%')),
          div(style="display:inline-block; vertical-align: middle;",
              bsButton(
                "q6",
                label = "",
                icon = icon("question"),
                style = "info",
                size = "extra-small"
              ),
              bsPopover(
                id = "q6",
                title = "Información",
                content = paste0("Se llevará a cabo el análisis de comunidades en base al algoritmo de Walktrap Method"),
                placement = "right",
                trigger = "hover",
                options = list(container = "body")
              )
          ))),
      
      menuItem(div(
        div(style="width:80%; display:inline-block; vertical-align: middle;",
            "Análisis de centralidad"),
        div(style="display:inline-block; vertical-align: middle;",
            bsButton(
              "q10",
              label = "",
              icon = icon("question"),
              style = "info",
              size = "extra-small"
            ),
            bsPopover(
              id = "q10",
              title = "Información",
              content = paste0("El análisis de centralidad diferenciará los nodos por tamaño en función del nivel de centralidad que posea."),
              placement = "right",
              trigger = "hover",
              options = list(container = "body")
            ))),
        div(  
          div(style="width:80%; display:inline-block; vertical-align: middle;",
              actionButton("centralidad1", label = "Betweenness", width = '100%')),
          div(style="display:inline-block; vertical-align: middle;",
              bsButton(
                "q7",
                label = "",
                icon = icon("question"),
                style = "info",
                size = "extra-small"
              ),
              bsPopover(
                id = "q7",
                title = "Información",
                content = paste0("Se llevará a cabo el análisis de centralidad en base al algoritmo de Betweenness"),
                placement = "right",
                trigger = "hover",
                options = list(container = "body")
              )
          )),
        
        div(
          div(style="width:80%; display:inline-block; vertical-align: middle;",
              actionButton("centralidad2", label = "Kleinberg", width = '100%')),
          div(style="display:inline-block; vertical-align: middle;",
              bsButton(
                "q8",
                label = "",
                icon = icon("question"),
                style = "info",
                size = "extra-small"
              ),
              bsPopover(
                id = "q8",
                title = "Información",
                content = paste0("Se llevará a cabo el análisis de centralidad en base al algoritmo de Kleinberg"),
                placement = "right",
                trigger = "hover",
                options = list(container = "body")
              ))
          # A continuación añadimos los Outputs que se verán:
          
          #)
        )))
  ),
  # Fin del lateral del Dashboard
  
  # Cuerpo del Dashboard
  dashboardBody(fluidPage(
    # Application title
    titlePanel("GRAFOS"),
    
    # Sidebar with a slider input for number of bins
    
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
    
    # Fin Cuerpo Pestaña 1 Dashboard
    # Inicio Pestaña 2 Dashboard
    
  ))
)

