###############################################################################################################
# Description: This app predicts the temperature in degree F for  given latitude in the us based on the       #
#              linear regression model lm(apr ~ lat) - apr the daily average temperature for the mont of may  #
#              lat is the latitude of the location for the US mainland between 18 and 65 degrees.             #
#              Input = latitude in degree, Output = temperature in F                                          #
#                                                                                                             #
# Date:        June 2, 2016                                                                                   #
###############################################################################################################

#setwd("~/Documents/Data-Science/Shiny/weatherPredict")

library(shiny)
library(stats)

ui     <- fluidPage(
        
        h1("Coffee farm Temperature Predictor for USA"),
        sidebarLayout(
                sidebarPanel(
                       
                        sliderInput("new_lat",    # sliding input
                                    "Use the slider to select the latitude 
                                    you want to predict the Temperature for: ", 
                                    min = 18, 
                                    max = 65, 
                                    value = 21
                        )
                ),
                mainPanel(
                        textOutput("table"),
                        img(src='usWeather.JPG', align = "center", width="45%", height="45%")
                ) 
        )
)


server <- function(input, output, session) {
        load("regression.lm.RData")                           # load the predictive regression model
        
        intercept <- summary(regression.lm)$coefficients[1,1] # extract intercept coefficient
        slope     <- summary(regression.lm)$coefficients[2,1] # extract slope coefficient
        
        
        lat <- reactive({
                
                newlat  <- round(intercept + slope * input$new_lat, 2) # predict new latitude based on the linear model equation
        })
        
        
        output$table <- renderText({
                
                paste("The temperature for the chosen latitude is ' ", lat()," ' degree Farenhite.") #print updated temprature
        })
        
}

shinyApp(ui, server)