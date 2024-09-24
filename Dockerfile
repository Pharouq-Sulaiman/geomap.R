# Use the official R base image with Shiny installed
FROM rocker/shiny:latest

# Install system dependencies for packages (if needed) and Git
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    git  # Install Git

# Install R packages required by your app
RUN R -e "install.packages(c('shiny', 'shinydashboard', 'shinyjs', 'shinyFiles', 'tidyverse', 'sf', 'dplyr', 'mapview', 'leaflet', 'fontawesome', 'purrr', 'leaflet.extras', 'leaflet.extras2', 'leaflet.esri', 'htmltools', 'plotly', 'ggplot2', 'tidyr', 'lubridate'))"

# Clone the Shiny app from GitHub repository
RUN git clone https://github.com/Pharouq-Sulaiman/geomap.git /srv/shiny-server/

# Make the Shiny app directory writable by the Shiny user
RUN chown -R shiny:shiny /srv/shiny-server/

# Expose the port where the Shiny app will run
EXPOSE 3838

# Run the Shiny app
CMD ["/usr/bin/shiny-server"]
