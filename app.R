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
library(DT)





# Load the dataset
hospitals <- read.csv("./healthmopupandbaselinenmisfacility.csv")
options(timeout = 6000)

hospitals0 <- hospitals %>%
  select(-c(num_doctors_fulltime,num_nurses_fulltime
            ,num_chews_fulltime,num_nursemidwives_fulltime))%>%
  mutate_all(~ ifelse(is.na(.), "unknown", .))

hospitals0 <- hospitals %>%
  select(c(num_doctors_fulltime,num_nurses_fulltime
            ,num_chews_fulltime,num_nursemidwives_fulltime))%>%
  mutate_all(~ ifelse(is.na(.), 0, .))



hospitals1 <-hospitals%>%
  drop_na(c(longitude, latitude))
hospitals2 <-hospitals1%>%
  st_as_sf(coords = c("longitude", "latitude"),     
           crs    = 4326   ) 

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
  ),fluidRow(
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
server <- function(input, output) {
  output$image1 <- renderImage({
    list(src = "./medical_logo.jpg", height = 70, width = 100)
  }, deleteFile = FALSE)
  
  output$image2 <- renderImage({
    list(src = "./coat_of_arm.jpg", height = 70, width = 100)
  }, deleteFile = FALSE)
  output$map <- renderLeaflet({
    mapview::mapview(hospitals2)@map
  })
  
  output$map1 <- renderLeaflet({
    iconSet <- awesomeIconList(
      HealthPost = makeAwesomeIcon(text = fa("bed-pulse"), iconColor = "blue", markerColor = "beige"),
      BasicHealthCentre = makeAwesomeIcon(text = fa("house-chimney-medical"), iconColor = "red", markerColor = "beige"),
      PrimaryHealthCentre = makeAwesomeIcon(text = fa("truck-medical"), iconColor = "green", markerColor = "beige"),
      Dispensary = makeAwesomeIcon(text = fa("square-h"), iconColor = "darkgreen", markerColor = "beige"),
      GeneralHospital = makeAwesomeIcon(text = fa("hospital-user"), iconColor = "darkred", markerColor = "beige"),
      Informationnotavailable = makeAwesomeIcon(text = fa("stethoscope"), iconColor = "darkblue", markerColor = "beige"),
      ComprehensiveHealthCentre = makeAwesomeIcon(text = fa("hospital"), iconColor = "brown", markerColor = "beige"),
      TeachingHospital = makeAwesomeIcon(text = fa("user-doctor"), iconColor = "purple", markerColor = "beige"),
      DistrictGeneralHospital = makeAwesomeIcon(text = fa("user-nurse"), iconColor = "orange", markerColor = "beige"),
      Clinic = makeAwesomeIcon(text = fa("bed"), iconColor = "black", markerColor = "lightgray"),
      PrivateFacility = makeAwesomeIcon(text = fa("house-medical"), iconColor = "cadetblue", markerColor = "beige"),
      SpecialistHospital = makeAwesomeIcon(text = fa("house-medical-flag"), iconColor = "gray", markerColor = "beige"),
      Default = makeAwesomeIcon(text = fa("circle-h"), iconColor = "pink", markerColor = "beige")
    )
    
    # Apply icons to the hospitals dataset based on facility type
    hospitals1$icon <- case_when(
      hospitals1$facility_type_display == "Health Post" ~ "HealthPost",
      hospitals1$facility_type_display == "Basic Health Centre / Primary Health Clinic" ~ "BasicHealthCentre",
      hospitals1$facility_type_display == "Primary Health Centre (PHC)" ~ "PrimaryHealthCentre",
      hospitals1$facility_type_display == "Dispensary" ~ "Dispensary",
      hospitals1$facility_type_display == "General Hospital" ~ "GeneralHospital",
      hospitals1$facility_type_display == "Information not available / Don't know" ~ "Informationnotavailable",
      hospitals1$facility_type_display == "Basic Health Centre or Primary Health Clinic" ~ "BasicHealthCentre",
      hospitals1$facility_type_display == "District Hospital / Comprehensive Health Centre" ~ "ComprehensiveHealthCentre",
      hospitals1$facility_type_display == "Teaching Hospital" ~ "TeachingHospital",
      hospitals1$facility_type_display == "District Hospital or Comprehensive Health Centre" ~ "ComprehensiveHealthCentre",
      hospitals1$facility_type_display == "Primary Health Center" ~ "PrimaryHealthCentre",
      hospitals1$facility_type_display == "District / General Hospital" ~ "DistrictGeneralHospital",
      hospitals1$facility_type_display == "Clinic" ~ "Clinic",
      hospitals1$facility_type_display == "Teaching / Specialist Hospital" ~ "TeachingHospital",
      hospitals1$facility_type_display == "Private Facility" ~ "PrivateFacility",
      hospitals1$facility_type_display == "Specialist Hospital" ~ "SpecialistHospital",
      TRUE ~ "Default"  # Default icon if none of the above matches
    )
    
    
    
    
    hospitals1 %>%
      leaflet() %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "World Imagery") %>%
      setView(lng = mean(hospitals1$longitude), lat = mean(hospitals1$latitude), zoom = 10) %>%
      addAwesomeMarkers(lng = hospitals1$longitude, 
                        lat = hospitals1$latitude,
                        icon = ~iconSet[hospitals1$icon], 
                        popup = hospitals1$facility_name,
                        clusterOptions = markerClusterOptions())  # Clustering option
    
  })
  
  output$map2 <- renderLeaflet({
    iconSet <- awesomeIconList(
      HealthPost = makeAwesomeIcon(text = fa("bed-pulse"), iconColor = "blue", markerColor = "beige"),
      BasicHealthCentre = makeAwesomeIcon(text = fa("house-chimney-medical"), iconColor = "red", markerColor = "beige"),
      PrimaryHealthCentre = makeAwesomeIcon(text = fa("truck-medical"), iconColor = "green", markerColor = "beige"),
      Dispensary = makeAwesomeIcon(text = fa("square-h"), iconColor = "darkgreen", markerColor = "beige"),
      GeneralHospital = makeAwesomeIcon(text = fa("hospital-user"), iconColor = "darkred", markerColor = "beige"),
      Informationnotavailable = makeAwesomeIcon(text = fa("stethoscope"), iconColor = "darkblue", markerColor = "beige"),
      ComprehensiveHealthCentre = makeAwesomeIcon(text = fa("hospital"), iconColor = "brown", markerColor = "beige"),
      TeachingHospital = makeAwesomeIcon(text = fa("user-doctor"), iconColor = "purple", markerColor = "beige"),
      DistrictGeneralHospital = makeAwesomeIcon(text = fa("user-nurse"), iconColor = "orange", markerColor = "beige"),
      Clinic = makeAwesomeIcon(text = fa("bed"), iconColor = "black", markerColor = "lightgray"),
      PrivateFacility = makeAwesomeIcon(text = fa("house-medical"), iconColor = "cadetblue", markerColor = "beige"),
      SpecialistHospital = makeAwesomeIcon(text = fa("house-medical-flag"), iconColor = "gray", markerColor = "beige"),
      Default = makeAwesomeIcon(text = fa("circle-h"), iconColor = "pink", markerColor = "beige")
    )
    
    # Apply icons to the hospitals dataset based on facility type
    hospitals1$icon <- case_when(
      hospitals1$facility_type_display == "Health Post" ~ "HealthPost",
      hospitals1$facility_type_display == "Basic Health Centre / Primary Health Clinic" ~ "BasicHealthCentre",
      hospitals1$facility_type_display == "Primary Health Centre (PHC)" ~ "PrimaryHealthCentre",
      hospitals1$facility_type_display == "Dispensary" ~ "Dispensary",
      hospitals1$facility_type_display == "General Hospital" ~ "GeneralHospital",
      hospitals1$facility_type_display == "Information not available / Don't know" ~ "Informationnotavailable",
      hospitals1$facility_type_display == "Basic Health Centre or Primary Health Clinic" ~ "BasicHealthCentre",
      hospitals1$facility_type_display == "District Hospital / Comprehensive Health Centre" ~ "ComprehensiveHealthCentre",
      hospitals1$facility_type_display == "Teaching Hospital" ~ "TeachingHospital",
      hospitals1$facility_type_display == "District Hospital or Comprehensive Health Centre" ~ "ComprehensiveHealthCentre",
      hospitals1$facility_type_display == "Primary Health Center" ~ "PrimaryHealthCentre",
      hospitals1$facility_type_display == "District / General Hospital" ~ "DistrictGeneralHospital",
      hospitals1$facility_type_display == "Clinic" ~ "Clinic",
      hospitals1$facility_type_display == "Teaching / Specialist Hospital" ~ "TeachingHospital",
      hospitals1$facility_type_display == "Private Facility" ~ "PrivateFacility",
      hospitals1$facility_type_display == "Specialist Hospital" ~ "SpecialistHospital",
      TRUE ~ "Default"  # Default icon if none of the above matches
    )
    
    hospitals1 %>%
      leaflet() %>%
      addTiles() %>%
      setView(lng = mean(hospitals1$longitude), lat = mean(hospitals1$latitude), zoom = 10) %>%
      addAwesomeMarkers(lng = hospitals1$longitude, 
                        lat = hospitals1$latitude,
                        icon = ~iconSet[hospitals1$icon], 
                        popup = hospitals1$facility_name,
                        clusterOptions = markerClusterOptions())  # Clustering option
    
    
    
  })
  output$text <- renderText({
    "the explanation of the map above"
    })
  output$text1 <- renderText({
    "insight on the plot on count of management"
  })
  output$plot <- renderPlotly({
    ggplotly(hospitals0%>%
               group_by(facility_type_display)%>%
               count(management)%>%
               ggplot(aes(x = facility_type_display, y = n, fill = management))+
               geom_col(show.legend =TRUE) +
               ylab("count of management") +
               xlab("facility_type") +
               coord_flip() +
               ggtitle("music penetration in terms of views")+
               theme_classic()+
               theme(axis.text.x = element_text(angle = 90, hjust = 0)))
  })
  output$text2 <- renderText({
    "insights on the plotly output on number of doctors"
  })
  
  output$blank <- renderText({
    "."
  })
  
  output$plot1 <- renderPlotly({
    hospitals%>%
      group_by(facility_type_display)%>%
      summarise(doctors= sum(num_doctors_fulltime, na.rm = TRUE))%>%
    plot_ly(labels = ~facility_type_display, values = ~doctors, type = "pie", textinfo = "label+percent", hole = 0.3) %>%
      layout(
        title = "Pie Chart of number of Doctors",
        annotations = list(text = "Data Source: Hospitals Data", showarrow = TRUE),
        legend = list(orientation = "h", x = 0.5, y = -0.1),
        margin = list(l = 0, r = 0, b = 0, t = 40),
        colors = c("jco"),  # You can customize the colors
        hoverinfo = "label+percent+name",
        hoverlabel = list(bgcolor = "lightblue", font = list(color = "red"))
      )
  })
  
  selectedFacility <- reactive({
    if (input$facility == "All") {
      hospitals1
    } else {
      hospitals1 %>% filter(facility_name == input$facility)
    }
  })
  
  # Generate the leaflet map
  output$map3 <- renderLeaflet({
    
    hospitalIconUrl <- "./hospital_plus.jpg" # Replace with the correct URL
    
    # Create a custom icon using the PNG URL
    hospitalIcon <- makeIcon(
      iconUrl = hospitalIconUrl,
      iconWidth = 30,   # Adjust based on the size of the icon
      iconHeight = 30,  # Adjust based on the size of the icon
      iconAnchorX = 30, # Set the horizontal anchor point of the icon
      iconAnchorY = 30 # Set the vertical anchor point of the icon
    )  # Clustering option
    
    leaflet() %>%
      addTiles() %>%
      setView(lng = hospitals1$longitude[1], lat = hospitals1$latitude[1], zoom = 10) %>%
      addMarkers(lng = hospitals1$longitude,
                 lat = hospitals1$latitude,
                 icon = hospitalIcon, 
                 popup = hospitals1$facility_name,
                 clusterOptions = markerClusterOptions())
  })
  
  # Observe changes in selected facility and update the map view
  observeEvent(input$facility, {
    # Filter the selected facility
    selected <- selectedFacility()
    
    # If 'All' is selected, show the entire map
    if (input$facility == "All") {
      leafletProxy("map3") %>%
        clearMarkers() %>%
        setView(lng = mean(hospitals1$longitude), lat = mean(hospitals1$latitude), zoom = 10) %>%
        addAwesomeMarkers(lng = hospitals1$longitude, 
                          lat = hospitals1$latitude,
                          icon = hospitalIcon, 
                          popup = hospitals1$facility_name,
                          clusterOptions = markerClusterOptions())
    } else {
      # For a specific facility, set the view to its coordinates
      leafletProxy("map3") %>%
        clearMarkers() %>%
        setView(lng = selected$longitude, lat = selected$latitude, zoom = 15) %>%
        addAwesomeMarkers(lng = selected$longitude, 
                          lat = selected$latitude,
                          icon = hospitalIcon, 
                          popup = selected$facility_name)
    }
  })
  
  output$plota <- renderPlotly({
    ggplotly(hospitals1 %>%
               group_by(!!sym(input$variables)) %>%
               count(!!sym(input$variables1)) %>%
               mutate(percentage = n / sum(n) * 100)%>%
               ggplot(aes_string(x = input$variables, y = "n", fill = input$variables1)) +
               geom_col(show.legend = TRUE) +
               ylab("count") +
               geom_text(aes(label = paste0(round(percentage, 1), "%, ")),position = position_stack(vjust = 0.5))+
               xlab("Variable of Interest") +
               coord_flip() +
               ggtitle("Exploring the count of a column in respect to another") +
               theme_classic() +
               theme(axis.text.x = element_text(angle = 90, hjust = 0))
    )
  })
  
  output$tablea <- renderDataTable({
    hospitals1 %>%
      group_by(!!sym(input$variables)) %>%
      count(!!sym(input$variables1)) %>%  # Count occurrences of the second selected variable
      datatable(options = list(pageLength = 25))
  })
  output$texta <- renderText({
    "In this comprehensive analysis, our primary objective is to unravel the intricate connections that exist between various variables within our extensive dataset. The methodology we employ centers around the meticulous examination of the occurrences of a specific variable, as enumerated in the second column, in relation to the corresponding values present in the first column.

To elucidate this approach, let's take a concrete example. We will focus on scrutinizing the distribution of artist countries, a variable housed in the second column, concerning the countries listed in the first column. This examination is pivotal as it enables us to derive meaningful insights into the prevalence and distribution of artist countries within the ambit of different countries. The resulting data will cast a spotlight on the nuanced relationships and patterns that underlie the interaction between these two variables.

As we embark on this analytical journey, it's essential to recognize the inherent flexibility of our methodology. The adaptability of our approach is a key feature, allowing us to extend our investigation beyond the artist country-country relationship. We can seamlessly apply this analytical framework to explore and understand the interplay between any other pair of variables present in our expansive dataset.

The fundamental step in our analysis involves the systematic tallying of occurrences. For the case of artist countries, we meticulously count and document the instances where a particular artist country is associated with each unique country in the first column. This process unveils a quantitative representation of the prevalence of artist countries within the context of individual countries, providing a robust foundation for insights.

The richness of insights derived from this analysis is not confined to a mere numerical representation. Beyond the raw counts, we delve into the qualitative aspects that accompany these associations. Factors such as cultural influences, artistic collaborations, and global trends come into play, contributing to a holistic understanding of the intricate relationships between variables.

Furthermore, the adaptability of our approach extends beyond exploring the artist country-country relationship. We can seamlessly pivot to investigating other variable pairs within our dataset. Whether it's genre preferences, listener demographics, or any other variable at our disposal, the same analytical rigor can be applied, uncovering a tapestry of connections that collectively contribute to a comprehensive understanding of our dataset.

In essence, our analytical framework is not just a methodological tool; it's a gateway to unlocking the narrative embedded within our data. It's a journey that transcends mere statistical analysis, offering a profound exploration of the multifaceted relationships that define the landscape of our dataset. As we navigate through the intricate web of variables, we are not just counting occurrences; we are deciphering a story—one that is waiting to be told through the lens of rigorous analysis and insightful interpretation.
"
  })
  output$plot1a <- renderPlotly({
    ggplotly(hospitals1%>%
               group_by(!!sym(input$variables2), !!sym(input$variables3))%>%
               summarise(views= sum(!!sym(input$variables3x), na.rm = TRUE))%>%
               mutate(percentage = views / sum(views) * 100)%>%
               ggplot(aes_string(x = input$variables2, y = "views", fill = input$variables3))+
               geom_col(show.legend =TRUE) +
               ylab(input$variables3x) +
               geom_text(aes(label = paste0(round(percentage, 1), "%, ")),position = position_stack(vjust = 0.5))+
               xlab("Column of Interest") +
               coord_flip() +
               ggtitle("music penetration in terms of views")+
               theme_classic()+
               theme(axis.text.x = element_text(angle = 90, hjust = 0))
    )
  })
  
  output$table1a <- renderDataTable({
    hospitals1%>%
      group_by(!!sym(input$variables2), !!sym(input$variables3))%>%
      summarise(views= sum(!!sym(input$variables3x), na.rm = TRUE)) %>%  # Count occurrences of the second selected variable
      datatable(options = list(pageLength = 25))
  })
  output$text1a <- renderText({
    "In the realm of data analysis, our mission is to embark on a comprehensive exploration of music penetration, unraveling the intricate relationships woven within the fabric of our dataset. Our focal point lies in understanding the distribution and prevalence of artist countries, a variable nestled in the second column, in tandem with countries listed in the first column. Through a meticulous tallying process, we endeavor to shed light on the nuanced relationships between these variables, providing a panoramic view of music penetration across different regions.

Our analytical journey commences with a meticulous examination of the counts associated with artist countries within each unique country. This process is not merely a numerical exercise; rather, it serves as a gateway to a deeper comprehension of the prevalence of artists in diverse geographical contexts. As we unravel the numerical tapestry, patterns emerge, offering glimpses into the underlying dynamics that govern the global landscape of music.

At its core, this analysis transcends numerical counts; it is an exploration into the rich tapestry of cultural influences, artistic collaborations, and global trends that shape the distribution of artists. Beyond the raw numbers, we delve into the qualitative aspects that make this relationship inherently dynamic. Understanding the prevalence of artist countries within each country is not just about quantity; it's about deciphering the qualitative dimensions that contribute to the vibrant mosaic of the music industry.

Moreover, the versatility of our methodology stands out as a key feature. While we delve into the artist country-country relationship as a focal point, the same analytical rigor can seamlessly be applied to other variables within our dataset. This adaptability ensures that our exploration is not confined to a singular facet of music penetration; rather, it serves as a comprehensive lens through which we can scrutinize various dimensions of the music landscape.

Consider, for instance, the potential to extend this analysis to genres, listener demographics, or any other variable at our disposal. The same meticulous approach can uncover hidden patterns, offering a holistic understanding of the multifaceted layers that constitute music penetration. This versatility transforms our methodology into a dynamic tool, capable of unraveling diverse aspects of our dataset, contributing to a more profound comprehension of the music ecosystem.

In essence, what we embark upon is not just a numerical journey but a narrative exploration. As we navigate the expansive landscape of our dataset, we are deciphering a story—one that unfolds through the lens of rigorous analysis and insightful interpretation. The relationship between artist countries and countries is a chapter in this story, revealing not just counts but the intricate threads that weave together to create the vibrant tapestry of music penetration in our data.
"
  })
  output$plot2a <- renderPlotly({
    ggplotly(hospitals1 %>%
               count(!!sym(input$variables4)) %>%
               ggplot(aes_string(x = input$variables4, y = "n", fill = input$variables4)) +
               geom_col(show.legend = TRUE) +
               ylab("count") +
               xlab("Variable of Interest") +
               geom_text(aes(label = paste0(round(n / sum(n) * 100, 1), "%, ")),position = position_stack(vjust = 0.5))+
               coord_flip() +
               ggtitle("Exploring the count of a variable for all") +
               theme_classic() +
               theme(axis.text.x = element_text(angle = 90, hjust = 0))
    )
  })
  output$table2a <- renderDataTable({
    hospitals1 %>%
      count(!!sym(input$variables4)) %>%  # Count occurrences of the second selected variable
      datatable(options = list(pageLength = 25))
  })
  output$text2a <- renderText({
    "In the intricate realm of data analysis, our expedition revolves around a meticulous exploration of the distribution of a pivotal variable within its own domain. A profound case study forms the nucleus of our inquiry, wherein we set our sights on unraveling the intricate tapestry of occurrences within the variable denoted as artist country. Our modus operandi involves a granular investigation, aiming to decipher the counts of occurrences of each artist country with a discerning focus on its internal representation within the expansive dataset.

Our analytical odyssey commences with a nuanced understanding of the inherent intricacies encapsulated within the artist country variable. Far from a mere quantitative exercise, our approach transforms each count into a narrative thread, weaving together a story of representation and prevalence. The artist country variable, a vibrant protagonist in this narrative, takes center stage as we unravel its multifaceted presence within the expansive landscape of the music dataset.

As we navigate through the data, our focal point becomes the artist country variable's self-representation, offering a panoramic view of its frequency and distribution. This endeavor is not a mere numerical exploration; rather, it's a journey into the heart of musical diversity, encapsulated within the representation of different countries. Each count becomes a testament to the global symphony, revealing not just the frequency but the nuanced nuances that distinguish one artist country from another.

In delving into the counts of artist countries within itself, we embark on a quest to decode the narrative of musical representation. The numbers cease to be mere statistics; instead, they metamorphose into keys that unlock the doors to cultural diversity, artistic expression, and global resonance. The artist country variable, in this context, transforms into a vibrant palette, painting the canvas of our analysis with the myriad hues of nations and their unique contributions to the musical landscape.

Furthermore, our methodology isn't confined to a singular exploration; it unfolds as a versatile tool, adaptable to unravel the complexities of other variables within our dataset. The same meticulous scrutiny can be applied to genres, time periods, or any other facet that our dataset encapsulates. This adaptability transcends the boundaries of a singular variable, paving the way for a comprehensive understanding of the intricate relationships that define the musical ecosystem.

As we extend our exploration beyond the artist country variable, we recognize the profound narrative potential embedded within our analysis. It's not merely about counts; it's about deciphering the stories that unfold as we traverse the expansive terrain of data. The self-representation of artist countries becomes a chapter in this narrative, revealing not just the frequency of occurrences but the cultural narratives, collaborative synergies, and global resonances that reverberate within the musical corridors of our dataset.

In conclusion, what we embark upon is a narrative journey, decoding the intricate stories within the numerical fabric of our data. The artist country variable, examined within the context of self-representation, becomes a lens through which we gain profound insights into the rich and diverse tapestry of music within our dataset. Each count, each occurrence, is a brushstroke on the canvas of our analysis, contributing to the vibrant masterpiece that is the representation of artist countries within the musical symphony of our data.
"
  })
  output$plot3a <- renderPlotly({
    ggplotly(hospitals1%>%
               group_by(!!sym(input$variables5))%>%
               summarise(views = sum(!!sym(input$variables5x), na.rm = TRUE))%>%
               ggplot(aes_string(x = input$variables5, y = "views", fill = input$variables5))+
               geom_col(show.legend =TRUE) +
               ylab(input$variables5x) +
               xlab("Column of Interest") +
               geom_text(aes(label = paste0(round(views / sum(views) * 100, 1), "%, ")),position = position_stack(vjust = 0.5))+
               coord_flip() +
               ggtitle("music penetration in terms of views")+
               theme_classic()+
               theme(axis.text.x = element_text(angle = 90, hjust = 0))
    )
  })
  output$table3a <- renderDataTable({
    hospitals1%>%
      group_by(!!sym(input$variables5))%>%
      summarise(sum= sum(!!sym(input$variables5x), na.rm = TRUE))%>%  # Count occurrences of the second selected variable
      datatable(options = list(pageLength = 25))
  })
  output$text3a <- renderText({
    "In this comprehensive exploration of our dataset, we embark on a journey to unravel the intricate dynamics of music penetration, employing a nuanced lens that focuses on the variable representing artist countries. Our analytical spotlight is directed towards understanding the self-representation of the artist country variable, offering a unique perspective on the prevalence and impact of each country within the expansive musical landscape encapsulated in our dataset.

The crux of our methodology lies in deciphering the music penetration, specifically in terms of views, as we delve into the self-representation of the artist country variable. Our quest is to meticulously tally the counts of occurrences of each artist country within itself, unveiling not just the numerical frequencies but also the underlying narratives, cultural resonances, and collaborative patterns that define the musical ecosystem.

As we traverse through the expansive dataset, each count of artist countries within itself becomes a pivotal data point, a gateway to understanding the diverse and multifaceted nature of musical representation. This exploration is not confined to numerical values alone; it transforms into a narrative journey, unraveling stories of global connectivity, artistic diversity, and the symbiotic relationships that shape the musical landscape.

The artist country variable, in this context, becomes a central protagonist, and its self-representation emerges as a testament to the multifaceted nature of music within our dataset. It is not merely about counting occurrences; it's about decoding the richness of each representation, discerning the unique qualities that each artist country brings to the musical tableau.

Furthermore, our methodology is not limited to a singular variable; it serves as a versatile tool that can be applied to probe the depths of other variables within our dataset. Whether it's genres, time periods, or any other facet of the musical landscape, our analytical framework adapts, providing a holistic understanding of the intricate relationships that define music penetration within our dataset.

In essence, what unfolds is a narrative expedition, where numerical counts transform into chapters of a compelling story. The self-representation of artist countries serves as a captivating narrative arc, revealing not only the statistical aspects of music penetration but also the cultural narratives, collaborative endeavors, and global resonances that reverberate within the dataset's musical corridors.

In conclusion, our analytical endeavor transcends the realms of mere counting; it is an exploration of the narratives woven within the fabric of our data. The self-representation of artist countries becomes a lens through which we gain profound insights into the diverse and vibrant tapestry of music penetration, offering a comprehensive understanding of the global symphony encapsulated within our dataset. Each count, each representation, contributes to the intricate masterpiece that is the self-portrait of artist countries within the music data landscape.
"
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
