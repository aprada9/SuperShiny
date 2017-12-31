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