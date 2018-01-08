library(shiny)
library(visNetwork)
library(DiagrammeR)


shinyServer(function(input, output) {
  # Creo los storages donde guardar los inputs del UI:  
  miGrafo<- reactiveValues(grafo=NULL)
  miGrafo2 <-reactiveValues(grafo=NULL)
  n <- reactiveValues(valor=1)
  p <- reactiveValues(valor=1)
  colG <- reactiveValues(comunidad=NULL)
  algo  <- reactiveValues(name=NULL)
  # Creo el Observe para que cada vez que se pulse Generate se modifiquen los values de los storages:
  observe({
    #Cada vez que pulse, que se ejecute lo siguiente:
    input$generate
    algo$name <- isolate(input$algorithm)
    n <- isolate(as.numeric(input$nnodes))
    p <- isolate(as.numeric(input$conexion))
    
    # Defino la fórmula de Erdos Renyi
    if (algo$name == "erdos") {
      miGrafo$grafo <- {
        create_graph(directed = FALSE) %>%
          add_gnp_graph(n = n,
                        p = p / 100)
      }
    }
    # Defino la fórmula de Barabási-Albert:
    else {
      miGrafo$grafo <- {
        create_graph(directed = FALSE) %>%
          add_pa_graph(n = n,
                       p = p / 100)
      }
    }
    
    miGrafo$grafo <-isolate(miGrafo$grafo)
    
    
  })
 
  observeEvent(  
    input$centralidad1,
    isolate(
    miGrafo$grafo$nodes_df$value<-(get_betweenness(miGrafo$grafo)$betweenness)
      )
    )
  observeEvent(  
    input$centralidad2,
    isolate(
      miGrafo$grafo$nodes_df$value<-(get_authority_centrality(miGrafo$grafo)$authority_centrality)
    )
  )
  
  observeEvent(
    input$comunidad1,
    
    isolate(
      miGrafo$grafo$nodes_df$group <-(get_cmty_edge_btwns(miGrafo$grafo)$edge_btwns_group)
    )
  )
  
  observeEvent(
    input$comunidad2,
    
    isolate(
      miGrafo$grafo$nodes_df$group <-(get_cmty_walktrap(miGrafo$grafo)$walktrap_group)
    ))
  
  
  # # Llamo al grafo 
  output$grafica <- renderVisNetwork({
    
    visNetwork(miGrafo$grafo$nodes_df, miGrafo$grafo$edges_df, main = "Grafos Aleatorios") %>%
      # A continuación añado la opción de 1.añadir nodos y ejes, 2.resaltar los nodos y ejes seleccionados,
      # 3.la opción de poder clickar sobre los nodos:
      visOptions(
        manipulation = TRUE,
        highlightNearest = TRUE,
        nodesIdSelection = list(enabled = TRUE)
        
      ) %>%
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
  
  output$between <- renderText({
    paste("Betweenness centrality: ", (get_betweenness(miGrafo$grafo))[input$grafica_selected,2])
  })
  
  output$klein <- renderText({
    paste("Kleinberg authority centrality : ", (get_authority_centrality(miGrafo$grafo))[input$grafica_selected,2])
  })
  
  # Indica el número de comunidad a la que pertenece (Edge Betweeness):
  output$comun1 <- renderText({
    paste("Group Membership - Edge Betweeness: ", (get_cmty_edge_btwns(miGrafo$grafo))[input$grafica_selected,2])
  })
  
  # Indica el número de comunidad a la que pertenece (Walktrap Method):
  output$comun2 <- renderText({
    paste("Group Membership - Walktrap Method: ", (get_cmty_walktrap(miGrafo$grafo))[input$grafica_selected,2])
  })
  
  
  
})
