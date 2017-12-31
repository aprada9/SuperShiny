library(shiny)
library(visNetwork)
library(DiagrammeR)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  miGrafo<- reactiveValues(grafo=NULL)
  n <- reactiveValues(valor=1)
  p <- reactiveValues(valor=1)
  
  observe({
    #Cada vez que pulse, que se ejecute lo siguiente:
    input$generate
    n <- isolate(as.numeric(input$nnodes))
    # Definimos sigma ya que es necesario para la función mvrnorm que usaremos posteriormente:
    p <- isolate(as.numeric(input$conexion))
    
    miGrafo$grafo <- create_graph(
      directed = FALSE) %>%
      add_gnp_graph(
        n = n,
        p = p)
    
  })
  
  output$grafica<- renderVisNetwork({
    visnetwork(misDatos$muestra)
    
  })
})
