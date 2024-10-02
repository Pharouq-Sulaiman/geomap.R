# Use the official R base image with Shiny installed
FROM rocker/shiny:latest

# Install system dependencies for packages (if needed)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev

# Install R packages required by your app
RUN R -e "install.packages(c('shiny', 'shinydashboard','shinyjs','shinyFiles','tidyverse','sf','dplyr','mapview','leaflet','fontawesome','purrr','leaflet.extras','leaflet.extras2','leaflet.esri','htmltools','stringr','plotly','DT','bslib','here','hereR'))"

# Create a directory for your Shiny app
RUN mkdir /srv/shiny-server/geomap


# Copy your app into the Docker container
COPY ./app.R /srv/shiny-server/geomap/

# Copy the CSV file into the app directory
COPY ./new_hospital.csv /srv/shiny-server/geomap/

# Copy the CSV file into the app directory
COPY ./coat_of_arm.jpg /srv/shiny-server/geomap/

# Copy the CSV file into the app directory
COPY ./medical_logo.jpg /srv/shiny-server/geomap/

# Copy the CSV file into the app directory
COPY ./hospital_plus.jpg /srv/shiny-server/geomap/

# Make sure www and data directories are accessible
RUN chmod -R 755 /srv/shiny-server/


# Expose the port the app runs on
EXPOSE 3838

# Run the Shiny app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/geomap', host='127.0.0.0', port=3838)"]
