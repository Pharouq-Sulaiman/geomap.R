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
RUN R -e "install.packages(c('shiny', 'shinydashboard', 'shinyjs', 'shinyFiles', 'tidyverse', 'sf', 'dplyr', 'mapview', 'leaflet', 'fontawesome', 'purrr', 'leaflet.extras', 'leaflet.extras2', 'leaflet.esri', 'htmltools', 'rwhatsapp', 'stringr', 'plotly', 'wordcloud2', 'ggplot2', 'tidyr', 'hms', 'text', 'stringi', 'emoji', 'janeaustenr', 'tidytext', 'writexl', 'emojifont', 'readr', 'reshape2', 'FactoMineR', 'factoextra', 'cluster', 'rio', 'SmartEDA', 'explore', 'ggraph', 'igraph', 'lubridate', 'ggimage'))"

# Create a directory for your Shiny app
RUN mkdir /srv/shiny-server/geomap

# Copy your app into the Docker container
COPY ./geomapping /srv/shiny-server/geomap/

# Expose the port the app runs on
EXPOSE 3838

# Run the Shiny app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/geomap', host='0.0.0.0', port=3838)"]
