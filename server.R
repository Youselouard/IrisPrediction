#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(randomForest)
library(e1071)
library(plotly)


shinyServer(function(input, output) {
    #Seting the seed to be able to reproduce the results
    set.seed(123456) 
    
    # spliting the Iris data into training and test sets 
    inTrain <- createDataPartition(y=iris$Species, p=0.8, list=FALSE)
    training <- iris[inTrain,]
    testing <- iris[-inTrain,]
    
    # Applying PCA to preprocess the data to reduce to 2 dimensions
    preProc <- preProcess(training[1:4], method="pca", pcaComp = 2)
    trainPC <- predict(preProc, training[1:4])
    trainPC$Species <- training$Species
    
    
    # Training a random forest machine learning algorithm to predict the species of an Iris
    rf <- train(Species ~ ., data = training, method="rf")
    
    #Calculating principal components of user inputs
    userIrisPC <- reactive({
        userIris <- data.frame(Sepal.Length = input$sepalLength, 
                               Sepal.Width = input$sepalWidth,
                               Petal.Length = input$petalLength, 
                               Petal.Width = input$petalWidth)
        predict(preProc, userIris)
    })
    
    userIrisPredict <- reactive({
        userIris <- data.frame(Sepal.Length = input$sepalLength, 
                               Sepal.Width = input$sepalWidth,
                               Petal.Length = input$petalLength, 
                               Petal.Width = input$petalWidth)
        predict(rf, userIris)
    })
    
    #Predicting the class of the user input
    output$prediction <- renderText(
        {
            as.character(userIrisPredict())  
        }
        )
    
    #Rendering a plot with the training data and the iris specified by the user
    output$irisPlot <- renderPlotly({

        #Generate lines to highlight user input 
        lineY <- list(
                type = "line",
                line = list(color = "blue"),
                xref = "paper",
                x0 = 0,
                x1 = 1,
                y0 = userIrisPC()$PC2,
                y1 = userIrisPC()$PC2
                )
        
        lineX <- list(
                    type = "line",
                    line = list(color = "blue"),
                    yref = "paper",
                    y0 = 0,
                    y1 = 1,
                    x0 = userIrisPC()$PC1,
                    x1 = userIrisPC()$PC1
                )
        
        lines <- list()
        lines <- c(list(lineY), list(lineX))
    
            
        
        # generate a simple scatterplot to visualize the iris points
        plot <- plot_ly(data = trainPC, x = ~PC1, y = ~PC2, mode = "markers", color = ~Species)
        plot <- layout(plot, title="Iris training data and user input", shapes = lines)
        

    })

})
