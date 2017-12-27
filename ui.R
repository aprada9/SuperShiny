library(shinydashboard)
library(shiny)


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
            # Campo para introducir la correlación de la muestra (máximo valor que puede tomar es 1 porque si no da error y se cierra:
            numericInput   ("nnodes", label = "Número de nodos", 2, step = 1),
            
            textInput(
              "arista",
              value = 1,
              label = "% de arista",
              placeholder = "Introducir % de arista"
            ),
            
            actionButton("pulse", label = "Generar grafo")
            
            
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


