# D:\NID_App\app.R
library(shiny)
library(tidyverse)
library(leaflet)
library(maps)
library(scales)
source("D:/R/theme_USACE.r")

# Load data in global scope (runs once when app starts)
setwd("D:/")
NID_data <- read.csv("/NID_App/data/nation.csv",skip = 1,header=T)

# Haz Classes
haz_levels <-c("Low", "Significant","High", "Undetermined")
hazard_classes <- factor(unique(NID_data$Hazard.Potential.Classification),levels = haz_levels)
states <- sort(unique(NID_data$State))

# Set Up nice breaks
maj_brks <- c(0,1,10,100,1000,10000,100000,1000000,10000000)
min_brks <- c(
  seq(2,9,1),
  seq(20,90,10),
  seq(200,900,100),
  seq(2000,9000,1000),
  seq(20000,90000,10000),
  seq(200000,900000,100000),
  seq(2000000,9000000,1000000),
  seq(20000000,90000000,10000000))

ui <- fluidPage(
  titlePanel("NID Drainage Area ECDFs"),
  sidebarLayout(
    sidebarPanel(
      selectInput("hazard", "Select Hazard Potential:", choices = levels(hazard_classes)),
      selectizeInput("states", "Select States (Multiple):", choices = states, multiple = TRUE)
    ),
    mainPanel(
      plotOutput("ecdf_plot")
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    NID_data %>%
      filter(Hazard.Potential.Classification == input$hazard)
  })
  
  state_filtered_data <- reactive({
    if (length(input$states) > 0) {
      NID_data %>%
        filter(Hazard.Potential.Classification == input$hazard, State %in% input$states)
    } else {
      NULL
    }
  })
  
  output$ecdf_plot <- renderPlot({
    p <- ggplot(filtered_data(), aes(x = `Drainage.Area..Sq.Miles.`)) +
      stat_ecdf(geom = "step", color = "black", linewidth = 1) + # National ECDF
      scale_x_log10(breaks=maj_brks,minor_breaks = min_brks,labels = comma) +
      labs(
        title = paste0("ECDF of ",input$hazard," Hazard Dam Drainage Areas"),
        x = "Drainage Area (Square Miles)",
        y = "Percentile") +
      theme_bw() + 
      theme(axis.text = element_text(size=12))+
      theme(axis.title = element_text(size=16))
    
    if (!is.null(state_filtered_data())) {
      p <- p +
        stat_ecdf(data = state_filtered_data(), aes(color = State), geom = "step") + # State ECDFs
        scale_color_discrete(name = "States")
    }
    
    p
  })
}

shinyApp(ui, server)
