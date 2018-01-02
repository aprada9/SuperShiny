library(shiny)
library(visNetwork)
library(DiagrammeR)


shinyServer(function(input, output) {
  # Creo los storages donde guardar los inputs del UI:  
  miGrafo<- reactiveValues(grafo=NULL)
  n <- reactiveValues(valor=1)
  p <- reactiveValues(valor=1)
  
  # Creo el Observe para que cada vez que se pulse Generate se modifiquen los values de los storages:
  observe({
    #Cada vez que pulse, que se ejecute lo siguiente:
    input$generate
    n <- isolate(as.numeric(input$nnodes))
    p <- isolate(as.numeric(input$conexion))
    
    # Defino la fórmula de Erdos Renyi    
    miGrafo$grafo <- create_graph(
      directed = FALSE) %>%
      add_gnp_graph(
        n = n,
        p = p/100)
    
    
  })
  # Llamo al grafo 
  output$grafica<- renderVisNetwork({
    visnetwork(miGrafo$grafo) %>% 
      # A continuación añado la opción de 1.añadir nodos y ejes, 2.resaltar los nodos y ejes seleccionados, 
      # 3.la opción de poder clickar sobre los nodos:
      visOptions(manipulation = TRUE,
                 highlightNearest = TRUE,
                 nodesIdSelection = list(enabled = TRUE, selected = "1")) %>%
      # Añado la opción de exportar el grafo en PNG
      visExport() 
  })
  

  # renderText que obtiene el número de nodo clickado
  output$view_id <- renderText({
    paste("Current node selection : ", input$grafica_selected)
  })
  # la función ..._selected está predefinida en la librería visNetwork y funciona como un Click.
  
  # renderText que obtiene la centralidad del nodo clickado
  output$close <- renderText({
    paste("Closeness centrality: ", (get_closeness(miGrafo$grafo))[input$grafica_selected,2])
  })
  # Para obtener solo el dato de la centralidad selecciono la columna 2(con el dato de la centralidadl)
  # de la línea del # nodo seleccionado
    
})


