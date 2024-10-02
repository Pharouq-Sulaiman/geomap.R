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
hospitals <- read.csv("https://raw.githubusercontent.com/Pharouq-Sulaiman/geomap.R/refs/heads/main/new_hospital.csv")
options(timeout = 6000000000)




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
                         leafletOutput("map", height="1000px"), textOutput("text"),textOutput("textb1"),textOutput("textb2"),textOutput("textb3"),textOutput("textb4"),textOutput("textb5"),
                         textOutput("textb6"),
                         fluidRow(
                           column(8, plotlyOutput("plot", height="1000px")
                           ),
                           column(4, textOutput("text1"),textOutput("text1b1"),textOutput("text1b2"),textOutput("text1b3"),textOutput("text1b4"),textOutput("text1b5"),textOutput("text1b6"),textOutput("text1b7"),textOutput("text1b8"),textOutput("text1b9"),
                           )
                         ),
                         textOutput("blank"),
                         fluidRow(
                           column(4, textOutput("text2"),textOutput("text2b1"),textOutput("text2b2"),textOutput("text2b3"),textOutput("text2b4"),textOutput("text2b5"),textOutput("text2b6"),textOutput("text2b7"),
                           ),
                           column(8, plotlyOutput("plot1", height="1200px")
                           )
                         ),fluidRow(
                           column(width = 12,
                                  style = "background-color: lightcoral;",  # Light red background
                                  textOutput("overview")
                                  ))
    ),
    tabPanel("ViewMap",icon = icon("globe", class = "btn-lg btn-info"),
             navbarPage(div("Hospital Locations", class = "custom-titles"),
                        navlistPanel(
                          tabPanel("Esri_WorldMap", icon= icon("location-dot", class = "btn-sm btn-success"),
                                   leafletOutput("map1", height = "1000px"), textOutput("texts1"),textOutput("texts1b1"),textOutput("texts1b2"),textOutput("texts1b3"),textOutput("texts1b4"),textOutput("texts1b5"),textOutput("texts1b6"),
                          ),
                          tabPanel("Street WorldMap", icon= icon("location", class = "btn-sm btn-success"),
                                   leafletOutput("map2", height = "1000px"), textOutput("texts"),textOutput("textsb1"),textOutput("textsb2"),textOutput("textsb3"),textOutput("textsb4"),textOutput("textsb5"),textOutput("textsb6"),
                          ),
                          tabPanel("Locate Hospital", icon= icon("magnifying-glass-location", class = "btn-sm btn-success"),
                                   selectInput("facility", 
                                               "Select Hospital:", 
                                               choices = c("All", unique(hospitals1$facility_name)), 
                                               selected = "All"), submitButton("confam", icon = icon("check-square", class = "btn-sm btn-info") ),
                                   leafletOutput("map3"), textOutput("texts2"),textOutput("texts2b1"),textOutput("texts2b2"),textOutput("texts2b3"),textOutput("texts2b4"),textOutput("texts2b5"),textOutput("texts2b6"),textOutput("texts2b7"),textOutput("texts2b8"),textOutput("texts2b9"),textOutput("texts2b10"),
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
  output$image1 <- renderImage({
    list(src = "medical_logo.jpg", height = 70, width = 100)
  }, deleteFile = FALSE)
  
  output$image2 <- renderImage({
    list(src = "coat_of_arm.jpg", height = 70, width = 100)
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
    "Welcome to the hospital location map! Here, you are exploring a dynamic visualization of healthcare facilities in various regions. Each point on the map represents a hospital, and you can zoom in or out to get a closer look at the specific locations across different cities, towns, and regions."
  })
  output$textb1 <- renderText({
    "As you interact with the map, you’ll notice key information at your fingertips:"
  })
  output$textb2 <- renderText({
    "Precise Locations: You’re viewing the exact locations of hospitals, which helps you understand their geographical distribution."
  })
  output$textb3 <- renderText({
    "Ease of Access: This map allows you to easily find the nearest healthcare facility by interacting with the map’s zoom and pan functionalities."
  })
  output$textb4 <- renderText({
    "Global & Local Context: If you're zooming out, you can gain a global overview of the healthcare network. Zooming in provides you with local insight, showing which hospitals are near major roads, residential areas, and other key landmarks."
  })
  output$textb5 <- renderText({
    "Each hospital pin isn’t just a dot; it’s a gateway to crucial medical services. So, whether you’re exploring for personal health, professional research, or curiosity, this map serves as your visual guide to the healthcare infrastructure. The interactive nature lets you engage with the data in a meaningful way, and we hope you find it as informative as it is intuitive."
  })
  output$textb6 <- renderText({
    "Dive in and explore!"
  })
  output$text1 <- renderText({
    "This plot provides a powerful visualization of how different hospital facility types (such as general hospitals, specialized clinics, etc.) are distributed based on their management type (e.g., private, public, or government-owned). The chart is an insightful way to compare the number of hospitals for each type of facility, categorized by their management type."
  })
  output$text1b1 <- renderText({
    "Here’s a breakdown of what you’re seeing in the plot:"
  })
  output$text1b2 <- renderText({
    "Bars and Color Coding: Each bar represents a different facility type (displayed on the y-axis), while the bars are further segmented by the management type, shown in different colors. This makes it easy to compare how various management systems are distributed across different facility types."
  })
  output$text1b3 <- renderText({
    "Count of Management: The height of each bar represents the count of hospitals managed under a specific management category for that facility type. This allows you to visually gauge which management style is more prominent within certain types of facilities."
  })
  output$text1b4 <- renderText({
    "Facility Distribution: The x-axis displays the facility types in a horizontal layout, allowing for easy comparison across a wide range of categories. Facility types with longer bars indicate a higher number of hospitals in that category."
  })
  output$text1b5 <- renderText({
    "Title and Theme: The title provides a clear description of the purpose of the plot, and the classic theme makes the chart clean and easy to interpret, even with large datasets."
  })
  output$text1b6 <- renderText({
    "What insights can you derive from this chart?"
  })
  output$text1b7 <- renderText({
    "If a particular facility type is mostly managed by the public sector, private sector, or government organizations."
  })
  output$text1b8 <- renderText({
    "How certain management styles dominate specific types of facilities, which might reflect on accessibility, funding, and service delivery for healthcare in that region."
  })
  output$text1b9 <- renderText({
    "The plot is highly interactive using ggplotly, so you can hover over the bars to see the exact counts, zoom in on specific sections, or pan across the plot for a more detailed exploration. The interactive nature of the plot makes it an engaging tool for users to dig deeper into the data and uncover patterns in healthcare management."
  })
  output$plot <- renderPlotly({
    ggplotly(hospitals1%>%
               group_by(facility_type_display)%>%
               count(management)%>%
               ggplot(aes(x = facility_type_display, y = n, fill = management))+
               geom_col(show.legend =TRUE) +
               ylab("count of management") +
               xlab("facility_type") +
               coord_flip() +
               ggtitle("The count of different Management for each Facility type")+
               theme_classic()+
               theme(axis.text.x = element_text(angle = 90, hjust = 0)))
  })
  output$text2 <- renderText({
    "This interactive pie chart provides a detailed visualization of how full-time doctors are distributed across various facility types in the healthcare system. It helps to understand the proportion of medical staff assigned to different categories of facilities, offering an insightful perspective on healthcare infrastructure."
  })
  output$text2b1 <- renderText({
    "Facility Types: The slices of the pie represent different healthcare facility types, such as general hospitals, specialist clinics, health centers, and others. Each type shows the total number of full-time doctors assigned to that category."
  })
  output$text2b2 <- renderText({
    "Proportions: The size of each slice corresponds to the total number of doctors working full-time at that specific facility type. Larger slices indicate a greater concentration of medical personnel in that facility type, while smaller slices suggest fewer doctors."
  })
  output$text2b3 <- renderText({
    "Doctor Distribution: The chart visually emphasizes where the majority of full-time doctors are concentrated. For example, you might observe that a specific type of hospital, such as a general hospital, takes up a larger portion of the pie, indicating that most doctors are stationed there compared to smaller clinics or specialized health facilities."
  })
  
  output$text2b4 <- renderText({
    "Hover Information: By hovering over each slice, you can instantly view the facility type, the exact number of full-time doctors, and their percentage of the total doctor workforce. This enables a more granular understanding of the distribution."
  })
  output$text2b5 <- renderText({
    "Percentages: The percentages displayed give insight into how much of the doctor workforce is dedicated to each facility type, allowing for easy comparisons between different facility categories."
  })
  output$text2b6 <- renderText({
    "Aesthetic Design: The color scheme enhances the visual appeal and differentiation between facility types, while the donut-shaped design with a central hole adds clarity to the chart. The data source is clearly mentioned, contributing to the credibility of the information."
  })
  output$text2b7 <- renderText({
    "Conclusion:
This pie chart serves as a powerful tool for visualizing the allocation of medical personnel across facility types. It highlights the concentration of doctors in different healthcare environments, providing valuable insights for decision-makers, health administrators, and researchers. The interactive nature of the chart further enhances your ability to explore the data, making it easier to grasp how healthcare resources are distributed within the system."
  })
  
  
  
  output$blank <- renderText({
    "."
  })
  
  output$texts1 <- renderText({
    "When you look at this map, you'll immediately notice that each hospital or healthcare facility is represented by a unique icon based on its type. The icons are visually distinctive to help you quickly identify different types of facilities. For instance, hospitals have a symbol resembling a medical bed, while health posts and specialist hospitals are marked with icons like a stethoscope or medical flags. This makes it easy to see where different levels of healthcare services are available."
  })
  output$texts1b1 <- renderText({
    "Key Insights:"
  })
  output$texts1b2 <- renderText({
    "Hospital and Facility Distribution: As you explore the map, you can see how healthcare facilities are spread out across the region. Areas with high clusters of facilities may indicate regions with better healthcare access, while sparse areas might highlight places with fewer available services. The clustering feature helps organize the map when zoomed out, combining facilities in the same geographical area. As you zoom in, the clusters break apart, revealing individual facilities."
  })
  output$texts1b3 <- renderText({
    "Facility Types: The different icon colors and symbols allow you to distinguish between primary health centers, general hospitals, clinics, and even teaching hospitals at a glance. For example, if you're searching for a teaching hospital, the purple icons will guide you. On the other hand, comprehensive health centers are marked in brown, while private facilities are in cadet blue."
  })
  output$texts1b4 <- renderText({
    "Pop-up Details: When you click on any icon, a popup provides specific information about that facility, such as its name and type. This is particularly useful for anyone needing to find a particular hospital or type of healthcare service in a given area."
  })
  output$texts1b5 <- renderText({
    "User-Friendly Visualization: The base layer of the map uses Esri World Imagery, providing a high-resolution satellite view of the region. This not only gives you an idea of the hospital's location in relation to roads and landmarks but also lets you appreciate the geographic context of healthcare service distribution."
  })
  output$texts1b6 <- renderText({
    "Overall, the map provides a detailed and accessible view of hospital locations, enabling users to explore healthcare services with ease. Whether you're interested in finding a specific type of facility or understanding healthcare availability across regions, this map is an excellent tool for visual insight."
  })
  output$texts <- renderText({
      "When exploring this map, you will see healthcare facilities represented with custom, easy-to-distinguish icons based on their type. Each type of healthcare facility is assigned a specific icon color and symbol, making it easy for users to visually differentiate between facility types without needing to click on every marker."
    })
  output$textsb1 <- renderText({
   "Visual Representation of Healthcare Facility Types:

Health Posts are marked with a blue “bed-pulse” icon, representing basic healthcare services, often found in rural or underserved areas.
Basic Health Centers are marked with a red “house-chimney-medical” icon, indicating centers that provide primary healthcare services.
Primary Health Centers (PHCs) use a green “truck-medical” icon, showing facilities that deliver more advanced care than basic health centers.
Dispensaries, typically small medical facilities, are identified with a dark green “square-h” icon.
General Hospitals are shown with a dark red “hospital-user” icon, representing larger, more comprehensive healthcare centers.
Specialist Hospitals are marked in gray with a “house-medical-flag” icon, offering specialized medical services, and Teaching Hospitals are represented by a purple “user-doctor” icon, indicating facilities that provide both patient care and medical education.
Private Facilities are marked with cadet blue, denoting privately-owned hospitals or clinics, and other categories such as Clinics and Comprehensive Health Centers have their own distinct markers as well." 
    })
  output$textsb2 <- renderText({
"Geographic Distribution and Access:

As you look at the distribution of these icons, you get a sense of how healthcare services are spread out in the area. The clustering feature helps to simplify the map when zoomed out by combining multiple nearby facilities into a single cluster. When you zoom in, the clusters break apart, revealing individual healthcare facilities and their types.
Areas with many healthcare icons suggest regions with easier access to medical care, whereas sparse regions with few icons could indicate areas where healthcare access might be more limited."
    })
  output$textsb3 <- renderText({
"Detailed Popups:

Clicking on any marker will provide more specific information about that healthcare facility, such as its name, helping users to find the exact location of a particular facility they might be interested in.
"  })
  output$textsb4 <- renderText({
"Clustered View for Large Data:

Since many healthcare facilities may exist within a particular area, the clustering option helps organize the data when zoomed out. For users exploring the map at a higher level, these clusters allow for a clear, less cluttered overview, while zooming in reveals individual markers for more granular insights."  })
  output$textsb5 <- renderText({
"User-Friendly Navigation:

The map uses default tiles, providing familiar street-level views for navigation. This ensures that users can easily locate healthcare facilities in relation to roads, landmarks, or neighborhoods."  })
  output$textsb6 <- renderText({
"Overall, this map offers an efficient, user-friendly way to explore various healthcare services across the region. It helps users quickly find the type of facility they need while giving insights into the overall availability of healthcare in different geographic areas. The visual cues make it easy to navigate and interpret, providing both high-level and detailed views of the healthcare infrastructure."  })
  
  output$texts2 <- renderText({
    "This portion of your Shiny app provides an interactive map experience that allows users to visualize the locations of healthcare facilities in your dataset, using custom icons for easy identification. Here’s a detailed breakdown of the insights users can glean from this feature:"  })
  
  output$texts2b1 <- renderText({
    "Key Insights:" 
    })
  output$texts2b2 <- renderText({
    "Customizable Marker Icons:

The use of a custom icon enhances the visual appeal of the map and improves user experience by making it easier to identify healthcare facilities. The icon size and anchor settings ensure that the icons are clearly visible and well-positioned on the map." 
  })
  output$texts2b3 <- renderText({
    "Interactive Map Navigation:

Users can pan and zoom across the map to explore healthcare facilities. Initially, the map is centered to a particular hospital, allowing for a straightforward starting point. The zoom level is set to 10, providing a balance between detail and context, making it easier for users to identify nearby facilities." 
  })
  output$texts2b4 <- renderText({
    "Dynamic Facility Filtering:

The ability to filter the displayed facilities based on user input (e.g., selecting a specific facility or showing all facilities) adds interactivity and personalization to the map. If a user selects 'All' the map updates to show all healthcare facilities, allowing for a comprehensive overview of healthcare access in the region.
When a specific facility is selected, the map automatically zooms in (to a zoom level of 15) and centers on that facility. This feature is especially useful for users looking for detailed information on a particular location, helping them quickly navigate to the healthcare service they need." 
  })
  output$texts2b5 <- renderText({
    "User-Friendly Popups:

Each healthcare facility is associated with a popup that displays its name. This information is critical for users to identify and distinguish between various facilities. The popups serve as informative touchpoints that enhance the user's understanding of what each marker represents." 
  })
  output$texts2b6 <- renderText({
    "Marker Clustering:

The clustering option is particularly beneficial in areas where multiple healthcare facilities are located closely together. This feature simplifies the map view by grouping nearby markers into clusters, making it easier for users to see the concentration of facilities in a given area without overwhelming them with too many icons at once." 
  })
  
  output$texts2b7 <- renderText({
    "Real-Time Updates:

The use of leafletProxy allows for dynamic updates to the map without requiring a full page reload. This responsiveness enhances the user experience, ensuring that users can interact with the map fluidly as they make selections and receive instant feedback.
" 
  })
  output$texts2b8 <- renderText({
    "Enhanced Accessibility to Healthcare Services:

By visualizing the healthcare facilities on the map, users can quickly assess the availability and distribution of healthcare services in their area. This insight is vital for identifying potential gaps in healthcare access and understanding where more facilities may be needed." 
  })
  
  output$texts2b9 <- renderText({
    "Data-Driven Decision Making:

This interactive mapping feature empowers stakeholders (e.g., healthcare administrators, policymakers, and community leaders) to make informed decisions based on the geographical distribution of facilities. By understanding the clustering of hospitals, they can better strategize improvements in healthcare accessibility." 
  })
  
  output$texts2b10 <- renderText({
    "Overall, this interactive map feature transforms complex data into a user-friendly format, allowing users to explore healthcare facility locations and gain valuable insights into service accessibility. It provides a seamless experience that caters to both casual users seeking information and professionals making strategic decisions regarding healthcare services." 
  })
  output$overview <- renderText({
    "The app is designed to provide a comprehensive overview of healthcare facilities, utilizing interactive mapping and visualization tools to enhance user engagement. Users can explore various types of healthcare institutions, such as hospitals, clinics, and specialized centers, through an intuitive interface that showcases their geographical distribution.

The app employs **leaflet** for dynamic map displays, enabling users to visualize the locations of facilities in relation to other variables, such as practitioner types and service offerings. Customized icons are used to represent different facility types, enhancing clarity and understanding of the map. Additionally, clustering options are integrated to manage the display of markers, ensuring that users can easily navigate dense areas of facilities.

Users can filter and select specific facility types, which updates the map and visualizations accordingly. This functionality allows for focused exploration of particular categories, revealing insights into their distribution and prevalence across different regions.

The app also incorporates **plotly** for detailed graphical representations of data, showcasing relationships and distributions among various healthcare metrics. This includes analyzing counts of facility types, understanding service penetration, and examining the interplay between different healthcare dimensions.

Overall, the app serves as a powerful tool for visualizing and analyzing healthcare data, providing users with a clear understanding of the healthcare landscape and facilitating informed decision-making. It empowers users to explore the dynamics of healthcare facilities while offering insights into accessibility and service availability within the dataset."
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
    
    hospitalIconUrl <- "hospital_plus.jpg" # Replace with the correct URL
    
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
    "The bar chart allows you to compare two different variables from the hospital dataset. You can select any two variables, and the chart will show the count of one variable broken down by the categories of another.

Categories: The bars represent different categories based on the first variable you choose.
Breakdown: Each bar is split into colored segments, showing how the second variable you choose is distributed across the categories. For example, you might see how different hospital types are managed (public, private, etc.).
Key Features:
Counts & Proportions: The height of each bar shows the total count for that category. Inside each bar, you’ll see percentages that tell you how much each segment contributes to the total. This makes it easy to understand the distribution at a glance.

Percentage Labels: Each section of the bar includes a percentage label, so you can instantly see the share of each sub-category.

Horizontal Layout: The bars are arranged horizontally to make it easier to read the category names, especially if they’re long.

Interactive: Since this is a Plotly chart, it’s interactive. You can hover over the bars to see detailed information, zoom in and out, and even focus on specific parts of the data.

Why This is Useful:
This chart is helpful for comparing different aspects of the hospital dataset. For example:

Comparing Facility Types: You can see how many hospitals of each type (like Health Posts or General Hospitals) are in different management categories (like Public, Private, etc.).
Understanding Distribution: It’s easy to spot patterns, such as which types of facilities are more common in a certain management structure, or which ones have the highest counts overall.
By providing a dynamic way to compare these factors, this chart helps users gain insights into the distribution of healthcare facilities and their characteristics. It’s a great tool for exploring the data and understanding how different factors influence the hospital infrastructure."
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
    "This part of the Shiny app provides an interactive and detailed visualization of the distribution of healthcare practitioners, such as doctors, nurses, and other medical staff, across different healthcare facilities or related categories. The visualization allows users to explore how the number of practitioners is spread across various dimensions, such as facility type (e.g., health posts, clinics, hospitals) or management types (e.g., public, private, or NGO-run facilities). By selecting different variables through the input fields, users can easily customize the plot to focus on specific aspects of the healthcare system that are of interest.

The bar chart generated here displays the counts of practitioners, with bars grouped and color-coded based on the second variable chosen (such as management type). For instance, you can compare how many doctors are present in public hospitals versus private ones, or how many nurses are available in district hospitals compared to teaching hospitals. This type of grouping allows for quick comparisons and a comprehensive understanding of how healthcare staff are distributed across different types of facilities.

To make the insights even clearer, each bar is annotated with the percentage of the total practitioners it represents, placed in the middle of each stacked section. This percentage allows users to see not only the absolute numbers but also the relative proportions of practitioners working in each type of facility or under different management categories. The combination of color, percentages, and counts provides a rich and detailed snapshot of healthcare workforce distribution.

This visualization can help policymakers, administrators, and health professionals assess the allocation of medical staff resources. For instance, if a certain facility type appears to have a disproportionate number of doctors or nurses, it may suggest a potential area for workforce rebalancing or highlight regions that are underserved. Additionally, the ability to toggle between different variables provides a high level of customization, enabling users to explore various dimensions of the healthcare system.

By presenting the data in a clear, easy-to-understand format, this app helps users quickly grasp where healthcare resources are concentrated and which areas may need attention. Whether you are analyzing staffing levels for operational improvements, planning future resource allocation, or simply exploring the healthcare landscape, this plot provides valuable and actionable insights into how practitioners are distributed across different parts of the healthcare system."
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
    "In the intricate realm of data analysis, our exploration revolves around a meticulous examination of the distribution of healthcare facilities across various categories within the hospital dataset. At the heart of this analytical journey lies the variable denoted as **facility type**, which serves as the focal point for our inquiry. Our approach is far from a mere quantitative exercise; rather, it is a thoughtful and granular investigation into the representation and prevalence of different healthcare facility types within the dataset. This analysis aims to unravel the intricate patterns of healthcare accessibility and distribution across a variety of healthcare settings, from local health posts to specialist hospitals.

The **facility type** variable takes center stage as we aim to understand its internal distribution and self-representation within the dataset. By diving deep into the counts of different facility types, we reveal a narrative about healthcare infrastructure, exploring how different categories of healthcare services are spread across regions or countries. Each count of a particular facility type—whether it is a clinic, general hospital, teaching hospital, or dispensary—serves as a narrative thread that tells a story of healthcare distribution and availability. 

This analysis transcends mere numbers, transforming each count into a meaningful reflection of healthcare services across different contexts. The variable becomes more than just a categorical label—it emerges as a key to understanding the healthcare landscape. The **facility type** variable, in this context, offers a panoramic view of healthcare accessibility and the role that each facility plays within the healthcare system. As we examine the occurrence of each type of facility, we begin to uncover patterns in how healthcare services are distributed across rural and urban areas, public and private sectors, and general and specialized care settings.

As we continue our journey through the dataset, our focal point remains on the self-representation of these healthcare facilities. We are not merely counting instances; we are analyzing how these facilities contribute to the broader healthcare ecosystem. Each count reveals the scope and scale of the services provided, shedding light on the capacity and reach of different facility types. For example, the presence of general hospitals in specific regions may indicate a high demand for comprehensive healthcare services, while the distribution of smaller clinics may reflect a focus on localized, primary care. The diversity of facility types—ranging from health posts to teaching hospitals—offers insights into how different levels of healthcare provision are structured and managed within a given healthcare system.

Moreover, this analytical approach is not confined to facility types alone. The same scrutiny can be applied to other critical variables within the dataset, such as the distribution of medical staff (e.g., doctors, nurses), patient capacity, or the geographic location of facilities. This adaptability allows for a multi-dimensional exploration of the hospital dataset, enabling us to understand the intricate relationships between different healthcare variables and how they shape the overall system. By extending our analysis to other dimensions, we can gain a comprehensive understanding of the healthcare landscape, identifying trends, gaps, and opportunities for improvement.

In essence, our exploration of the **facility type** variable is a journey into the heart of healthcare representation. It allows us to decode the narrative of how healthcare services are distributed and what that means for access to care. The counts of different facility types offer insights into the availability of healthcare across various regions and how well different healthcare needs are met. By analyzing this data, we gain a better understanding of the healthcare system’s strengths and weaknesses, and how resources are allocated.

In conclusion, this analytical journey is not just about numbers—it’s about revealing the intricate stories embedded within the hospital dataset. The **facility type** variable, examined through the lens of self-representation, becomes a tool for understanding healthcare provision across a variety of contexts. Each count of a facility type is a data point that contributes to a broader narrative, helping us piece together the mosaic of healthcare services and their distribution. This analysis allows us to visualize the structure and dynamics of healthcare systems, offering valuable insights into how healthcare facilities are organized and what that means for the populations they serve."
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
    "In this exploration of our hospital dataset, we focus on understanding the distribution and representation of different **facility types** within the healthcare landscape. Our goal is to delve into the self-representation of this key variable, revealing the frequency and presence of each type of healthcare facility—whether it be clinics, general hospitals, or specialized centers—within the dataset.

Through this analysis, we aim to uncover not just the numerical occurrences, but also the broader narrative that each facility type contributes to the healthcare system. Each count of a facility type is a reflection of its role and importance in providing medical services, highlighting patterns of healthcare accessibility, capacity, and infrastructure.

The **facility type** variable becomes the central character of our investigation, showcasing how different categories of healthcare institutions are spread across regions. It tells a story of how healthcare services are organized and distributed, offering insight into which facilities dominate specific areas and what that implies for access to care.

This analysis is not confined to just facility types—it can be extended to other dimensions such as staff distribution or geographic reach. Each analysis piece contributes to a comprehensive understanding of the healthcare ecosystem, allowing us to grasp the dynamic relationships between facility types and their impact on healthcare availability.

In conclusion, this exploration goes beyond mere counts. It paints a picture of healthcare infrastructure, illustrating the roles various facility types play in the overall system. Each count, each representation, forms part of the bigger story about how healthcare is structured and delivered within the dataset, offering key insights into the healthcare landscape."
  })
}

options(shiny.maxRequestSize = 10000 * 1024^2)
shinyApp(ui = ui, server = server)

