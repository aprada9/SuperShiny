
library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel("GRAFOS"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      
      # Campo para introducir la correlación de la muestra (máximo valor que puede tomar es 1 porque si no da error y se cierra:
      numericInput   ("nnodes", label = "Número de nodos", 2,step = 1),
      
      textInput("arista", value=1, label = "% de arista", placeholder = "Introducir % de arista" ),
      
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