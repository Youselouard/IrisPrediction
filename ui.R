#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    tags$head(tags$style("
                  #prediction{
                  display:inline;
                  font-size:25px;
                  font-style: italic;
                  font-weight: bold
                  }")),

    # Application title
    titlePanel("Predict the species of your Iris !"),

    # Sidebar with slider inputs to fix the Iris petal and sepal dimensions
    sidebarLayout(
        sidebarPanel(
            sliderInput("petalWidth",
                        "Slide to enter your petal width",
                        min = 0,
                        max = 2.5,
                        value = 1.2),
            sliderInput("petalLength",
                        "Slide to enter your petal length",
                        min = 1.0,
                        max = 7.0,
                        value = 3.8),
            sliderInput("sepalWidth",
                        "Slide to enter your sepal width",
                        min = 2.0,
                        max = 4.5,
                        value = 3),
            sliderInput("sepalLength",
                        "Slide to enter your sepal length",
                        min = 4,
                        max = 8,
                        value = 5.8),
            submitButton("Submit!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("irisPlot"),
            h3("Your Iris' predicted species is :", style="display:inline"), 
            textOutput("prediction"),
            h5("Prediction made with a random forest")
        
        )
    )
)
)