#install.packages("polars", repos = "https://community.r-multiverse.org")
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyFiles)
library(tidyverse)
library(sf)
library(dplyr)
library(mapview)
library(leaflet)
library(fontawesome)
library(purrr)
library(leaflet.extras)
library(leaflet.extras2)
library(leaflet.esri)
library(htmltools)
library(stringr)
library(plotly)
library(stringi)
library(stringr)
library(sf)
library(mapview)
library(leaflet)
library(fontawesome)
library(purrr)
library(DT)
library(bslib)
library(here)
library(hereR)


options(shiny.host = "0.0.0.0")
options(shiny.port = 5000)

# Load the dataset

options(timeout = 6000000000)





# Define UI for application that draws a histogram
ui <- fluidPage(
  theme= bslib::bs_theme(bootswatch = "flatly"),
  tags$head(
    tags$link(rel = "stylesheet",
              href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"),
    
    tags$style(HTML("
      .custom-title   {
      font-family: 'Times New Roman'; /* Change to your desired font */
      font-size: 50px; /* Adjust font size */
      color: darkred; /* Change to your desired color */
      font-weight: bold; /* Make the text bold */
      }
      .custom-titles   {
      font-family: 'Ariel'; /* Change to your desired font */
      font-size: 30px; /* Adjust font size */
      color: indigo; /* Change to your desired color */
      font-weight: bold; /* Make the text bold */
      }
      /* Default style for all tabs */
      .nav-tabs > li > a {
        background-color: indigo;  /* Background color for tabs */
        color: lightgrey;              /* Default text color */
        font-family: 'Times New Roman';         /* Font style */
        font-size: 16px;              /* Font size */
        font-weight: bold;            /* Bold text */
        border-radius: 5px 5px 0 0;   /* Rounded corners for tabs */
        padding: 10px;                /* Padding inside the tabs */
      }
      
      /* Style for active (selected) tab */
      .nav-tabs > li.active > a, 
      .nav-tabs > li.active > a:focus, 
      .nav-tabs > li.active > a:hover {
        background-color: lightgrey;    /* Background color for active tab */
        color: lightgrey;                 /* Text color for active tab */
        border-color: lightcoral;        /* Border color */
      }
      
      /* Hover effect for tabs */
      .nav-tabs > li > a:hover {
        background-color:lightgrey ; /* Background color on hover */
        color: indigo;                 /* Text color on hover */
        border-color: darkblue; 
      }
      
       .navbar-nav > li > a {
        background-color: indigo;
        color: lightgrey !important;
        font-family: 'Times New Roman';
        font-size: 16px;
        font-weight: bold;
        border-radius: 5px 5px 0 0;
        padding: 10px;
      }
      .navbar-nav > li > a:hover {
        background-color: lightgrey;
        color: indigo !important;
        border-color: darkblue;
      }
      .navbar-nav > li.active > a,
      .navbar-nav > li.active > a:focus,
      .navbar-nav > li.active > a:hover {
        background-color: lightgrey;
        color: indigo !important;
        border-color: lightcoral;
      }
      
      .nav-tabs > li {
        margin-right: 30px;  /* Adjust this value for spacing between tabs */
      }
      
    body {
        background-color: lightgrey;
      }
      .container-fluid {
        background-color: lightgrey;
      }
      /* Customize output color */
      .shiny-text-output {
        border-color:Darkbrown;
        color: indigo;
      }
       .spinner {
        font-size: 40px;
        color: #3498db; /* Change the color if needed */
      }
      .spinner.fa-spin {
        animation: spin 2s infinite linear;
      }
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
     
    ")),
    tags$script(HTML("
    $(document).on('shiny:connected', function() {
      // Start the spinner on shiny:connected
      $('#file').on('change', function() {
        // Add spinner class when file input changes
        $('.spinner').addClass('fa-spin');
        
        // Stop the spinner after 30 seconds (30000 milliseconds)
        setTimeout(function() {
          $('.spinner').removeClass('fa-spin');
        }, 30000);
      });
    });
  "))
  ),useShinyjs(),
  fluidRow(
    column(width = 1,
           style = "background-color: lightgrey;",  # Light red background
           titlePanel(imageOutput("image1", height = "62")
           )
    ), 
    column(width = 10,
           style = "background-color: lightgrey;", titlePanel(title = div("Medical Facilities Geolocation", class = "custom-title")
           )
    ),
    column(width = 1,
           style = "background-color: lightgrey;",  # Light red background
           titlePanel(imageOutput("image2", height = "62")
           )
    ),
    tabsetPanel(tabPanel("Home",icon = icon("home", class = "btn-sm btn-info"),
                         titlePanel(title = div("Find Hospitals Across Nigeria", class = "custom-titles")),
                         titlePanel(title = div("Discover healthcare facilities near you and explore insights on health services across the nation.", class = "custom-titles")),
                         leafletOutput("map", height="1000px"), textOutput("text"),
                         fluidRow(
                           column(8, plotlyOutput("plot", height="600px")
                           ),
                           column(4, textOutput("text1")
                           )
                         ),
                         textOutput("blank"),
                         fluidRow(
                           column(4, textOutput("text2")
                           ),
                           column(8, plotlyOutput("plot1", height="600px")
                           )
                         ),
    ),
    tabPanel("ViewMap",icon = icon("globe", class = "btn-lg btn-info"),
             navbarPage(div("Hospital Locations", class = "custom-titles"),
                        navlistPanel(
                          tabPanel("Esri_WorldMap", icon= icon("location-dot", class = "btn-sm btn-success"),
                                   leafletOutput("map1", height = "1000px")
                          ),
                          tabPanel("Street WorldMap", icon= icon("location", class = "btn-sm btn-success"),
                                   leafletOutput("map2", height = "1000px")
                          ),
                          tabPanel("Locate Hospital", icon= icon("magnifying-glass-location", class = "btn-sm btn-success"),
                                   selectInput("facility", 
                                               "Select Hospital:", 
                                               choices = c("All", unique(hospitals1$facility_name)), 
                                               selected = "All"), submitButton("confam", icon = icon("check-square", class = "btn-sm btn-info") ),
                                   leafletOutput("map3")
                          )
                        )
             )
    ),
    tabPanel("Visualization",icon= icon("area-chart", class = "btn-sm btn-success"),
             fluidRow(
               column(4, selectInput("variables","Select Variable Column", choices = names(hospitals1)[c(2,3,4,5,7,8,9,17,18,19,20,21,22,23,24,25)], selected = "facility_type_display" ),
                      selectInput("variables1","Select Variable Column", choices = names(hospitals1)[c(2,3,4,5,7,8,9,17,18,19,20,21,22,23,24,25)], selected = "management" ),
                      submitButton("comot work", icon = icon("check-square", class = "btn-sm btn-info") )),
               column(8, plotlyOutput("plota", height= "600px", width= "100%"))),
             fluidRow(
               column(4, textOutput("texta")), column(8, dataTableOutput("tablea"))
             ),
             fluidRow(
               column(4, selectInput("variables2","Select Variable Column", choices = names(hospitals1)[c(2,3,4,5,7,8,9,17,18,19,20,21,22,23,24,25)], selected = "facility_type_display" ),
                      selectInput("variables3","Select Variable Column", choices = names(hospitals1)[c(2,3,4,5,7,8,9,17,18,19,20,21,22,23,24,25)], selected = "management" ),
                      selectInput("variables3x","Select Variable Column", choices = names(hospitals1)[c(6,10,11,12)], selected = "management" ),
                      submitButton("check am", icon = icon("check-square", class = "btn-sm btn-info") )),
               column(8, plotlyOutput("plot1a", height= "600px", width= "100%"))),
             fluidRow(
               column(4, textOutput("text1a")), column(8, dataTableOutput("table1a"))
             ),
             fluidRow(
               column(4, selectInput("variables4","Select Variable Column", choices = names(hospitals1)[c(2,3,4,5,7,8,9,17,18,19,20,21,22,23,24,25)], selected = "management" ),
                      submitButton("May We See", icon = icon("check-square", class = "btn-sm btn-info") )),
               column(8, plotlyOutput("plot2a", height= "600px", width= "100%"))),
             fluidRow(
               column(4, textOutput("text2a")), column(8, dataTableOutput("table2a"))
             ),
             fluidRow(
               column(4, selectInput("variables5","Select Variable Column", choices = names(hospitals1)[c(2,3,4,5,7,8,9,17,18,19,20,21,22,23,24,25)], selected = "management" ),
                      selectInput("variables5x","Select Variable Column", choices = names(hospitals1)[c(6,10,11,12)], selected = "management" ),
                      submitButton("Show person", icon = icon("check-square", class = "btn-sm btn-info") )),
               column(8, plotlyOutput("plot3a", height= "600px", width= "100%"))),
             fluidRow(
               column(4, textOutput("text3a")), column(8, dataTableOutput("table3a"))
             ),
    )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  
  hospitals <- reactive({
    
    hospitals <- read.csv(here("https://raw.githubusercontent.com/Pharouq-Sulaiman/geomap.R/refs/heads/main/healthmopupandbaselinenmisfacility.csv"))
    return(hospitals)
  })
  

  output$image1 <- renderImage({
    list(src = "medical_logo.jpg", height = 70, width = 100)
  }, deleteFile = FALSE)
  
  output$image2 <- renderImage({
    list(src = "coat_of_arm.jpg", height = 70, width = 100)
  }, deleteFile = FALSE)
  output$map <- renderLeaflet({
    mapview::mapview(hospitals())@map
  })
  
 
}

options(shiny.maxRequestSize = 10000 * 1024^2)
shinyApp(ui = ui, server = server)

