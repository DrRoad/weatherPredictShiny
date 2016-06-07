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
                        # numericInput(              # entering input
                        #         "new_lat", 
                        #         "Enter latitude between 20 and 60:", 
                        #         21
                        # ),
                        
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
        load("regression.lm.RData")
        # us_weather_df <- read.csv("./data/us_weather_df.csv") # load the data frame
        # apr <- us_weather_df$apr                            
        # lat <- us_weather_df$lat
        # df  <-  data.frame(apr,lat)
        # regression.lm <- lm(df$apr ~ df$lat)
        
        # > regression.lm
        # 
        # Call:
        #         lm(formula = df$apr ~ df$lat)
        # 
        # Coefficients:
        #         (Intercept)       df$lat  
        # 100.761       -1.204  
        
        intercept <- summary(regression.lm)$coefficients[1,1] # extract intercept
        slope     <- summary(regression.lm)$coefficients[2,1] # extract slope
        
        
        lat <- reactive({
                
                newlat  <- round(intercept + slope * input$new_lat, 2) # predict new latitude based on the linear model equation
        })
        
        
        output$table <- renderText({
                
                paste("The temperature for the chosen latitude is ' ", lat()," ' degree Farenhite.") #print the new output
        })
        
}

shinyApp(ui, server)