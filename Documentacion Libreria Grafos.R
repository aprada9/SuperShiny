visDocumentation()
vignette("Introduction-to-visNetwork") # with CRAN version
# shiny ?
shiny::runApp(system.file("shiny", package = "visNetwork"))


library(statnet)
data(faux.mesa.high)
mesa <- faux.mesa.high
plot(mesa)
mesa
plot(mesa, vertex.col='Grade')
legend('bottomleft',fill=7:12,legend=paste('Grade',7:12),cex=0.75)
fauxmodel.01 <- ergm(mesa ~edges + nodematch('Grade',diff=T) + nodematch('Race',diff=T)) > summary(fauxmodel.01)


library(shiny)
library(MASS)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # En esta primera parte he definido todos los datasets que he necesitado:
  misDatos<- reactiveValues(muestra=NULL)
  polin1<- reactiveValues(valor=1)
  
  df.train <- reactiveValues(train=NULL)
  df.validate  <- reactiveValues(validacion=NULL)
  train  <- reactiveValues(train=NULL)
  polin2 <- reactiveValues(valor=1)
  polin3 <- reactiveValues(valor=1)
  
  
  observe({
    #Cada vez que pulse, que se ejecute lo siguiente:
    input$pulse 
    corr <- isolate(as.numeric(input$corr))
    # Definimos sigma ya que es necesario para la función mvrnorm que usaremos posteriormente:
    sigm <- matrix(c(1,corr,corr,1),2)
    n <- isolate(as.numeric(input$n))
    #creamos 'muestra' con mvrnorm de los parámetros introducidos en pantalla.
    misDatos$muestra <-
      as.data.frame(mvrnorm(n,c(0,0),sigm, empirical = TRUE))
    
  })
  
  
  observe({
    #Cada vez que pulse, que se ejecute lo siguiente:
    input$pulse2 
    # Con esto hago que el valor del polinomio no se modifique hasta que no se pulse el boton:
    polin1$valor <- isolate(input$polin)
    polin2$valor <- isolate(input$polin)
    polin3$valor <- isolate(input$polin)
    
    
  })
  
  observe({
    # Cada vez que pulse, que se ejecute lo siguiente:
    input$checkbox 
    # Aquí le digo que si el chekbox se pulsa, se cree el dataset de train y validate
    # en base al porcentaje de input que haya introducido el usuario en el campo de texto que se despliega,
    # y que se guarde en los datasets creados inicialmente:
    
    train$train <- sample(nrow(misDatos$muestra), (input$training/100) *nrow(misDatos$muestra))
    df.train$train <- misDatos$muestra[train$train,]
    df.validate$validacion <- misDatos$muestra[-train$train,]
    
    
  })
  
  #Hacemos que al pulsar sobre la gráfica se añada ese punto a la muestra:
  observeEvent(input$click,{
    misDatos$muestra <- 
      rbind(misDatos$muestra,c(input$click$x,input$click$y))
    
  })
  
  output$grafica<- renderPlot({
    # Le digo que si el checkbox está marcado haga lo que esta dentro de las llaves, 
    # y si no que pase a lo que está fuera:
    if (input$checkbox == 1){
      
      # La forma de superponer 2 datasets distintos en un solo plot es a través de par(new=T). 
      # A continuación le digo que si el check está marcado, me cree una gráfica con ambos datasets:
      plot(df.train$train, xlab = "", ylab = "", col=1)
      par(new=T)
      plot(df.validate$validacion, xlab = "", ylab = "",axes=F, col=2)
      par(new=F)
      # Además le digo que en el caso de pulsar el botón de orden polinómico, me dibuje las 2 líneas de cada dataset:
      if (input$pulse2) {
        abline(lm(V1~poly(V2, polin2$valor, raw=TRUE),data=df.train$train), lwd=2, col=1)
        abline(lm(V1~poly(V2, polin3$valor, raw=TRUE),data=df.validate$validacion), lwd=2, col=2)
      }
    }
    # En el caso de no estar marcado el CheckBox:
    else{
      # Píntame la gráfica con el dataset entero:
      plot(misDatos$muestra, xlab = "", ylab = "")
      # Con la siguiente línea dibujo la línea:
      if (input$pulse2) {
        abline(lm(V1~poly(V2, polin1$valor, raw=TRUE),data=misDatos$muestra), lwd=2, col="blue")
      }
    }
  })
  
  
  
  output$correlacion <-renderText({
    paste0("La correlación es: ", cor(misDatos$muestra)[1,2])
  })
})

shiny::runApp(system.file("shiny", package = "visNetwork"))


g <- create_graph(
  directed = FALSE) %>%
  add_gnp_graph(
    n = 20,
    p = 0.2)


ggg<- make_graph("Zachary")

f <- create_graph() %>%
  add_gnp_graph(n=10, p=0.1, loops = FALSE)

neighbors(f,1)

observe({
  input$download
  #isolate(miGrafo$grafo)
  #visExport(visnetwork(miGrafo$grafo))
  n <- isolate(as.numeric(input$nnodes))
  p <- isolate(as.numeric(input$conexion))
})

g<-as.matrix(g)
comunidad<- get_cmty_edge_btwns(g)
comunidad<- as.matrix(comunidad)
grafo<- as.matrix(comunidad, g)


prueba <- cbind(g$nodes_df, comunidad)

teta <- ({
  nodes <- data.frame(id = 1:15, label = paste("Label", 1:15),
                      group = sample(LETTERS[1:3], 15, replace = TRUE))
  
  edges <- data.frame(from = trunc(runif(15)*(15-1))+1,
                      to = trunc(runif(15)*(15-1))+1)
  
})


d <- make_graph(g$nodes_df,g$edges_df)
plot(d)
visNetwork(g)
##
visNetwork(g$nodes_df,g$edges_df)
colG<-get_cmty_edge_btwns(g)

grafo<-c(g$nodes_df,g$edges_df,colG$edge_btwns_group)

names(grafo) <- c("nodes", "edges", "group")

visNetwork(g$nodes_df,g$edges_df)

visNetwork(grafo)


g$nodes_df<- cbind(g$nodes_df,"group"=colG$edge_btwns_group)

View(g$nodes_df)

# Líneas para Comunidades!:
colG<-get_cmty_edge_btwns(g)
g$nodes_df<- cbind(g$nodes_df,"group"=colG$edge_btwns_group)

g$nodes_df <- cbind(g$nodes_df,"group"=get_cmty_edge_btwns(g)$edge_btwns_group)


get_cmty_edge_btwns(g)$edge_btwns_group

visNetwork(g$nodes_df, g$edges_df) %>%
  visOptions(
    manipulation = TRUE,
    highlightNearest = TRUE,
    nodesIdSelection = list(enabled = TRUE, selected = "1")
  ) %>%
  visExport()
g$nodes_df<-g$nodes_df[-4]

get_cmty_walktrap(g)

# Algoritmo Small World
s <- sample_smallworld(2, 3, 5, 0.05)
visIgraph(s)
i
gs <- smallworld(g)
visIgraph(gs)
smallworld(s)

# En small world no selecciono el numero de nodos, las variables cambian. habria que hacer que cambien los inputs al seleccionar un algoritmo u otro.

# Algortimo Barabasi:
b <- sample_pa(3,algorithm = "psumtree")
visNetwork(b)

b <- create_graph(
  directed = FALSE) %>%
  add_pa_graph(
    n = 20,
    p = 0.2)

visNetwork(b$nodes_df, b$edges_df)

rnorm(20, 10)
isolate(miGrafo$grafo$edges_df$value) <- rnorm(4, 10)


g$nodes_df$group<-get_betweenness(b)