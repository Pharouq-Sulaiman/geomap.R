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
RUN R -e "install.packages(c('shiny', 'leaflet', 'sf', 'dplyr', 'tidyverse', 'mapview', 'leaflet.extras', 'plotly'))"

# Clone the Shiny app from GitHub repository
# Replace <Pharouq-Sulaiman> and <geomap.R> with your GitHub username and repository name
RUN git clone https://github.com/<Pharouq-Sulaiman>/<geomap.R>.git /srv/shiny-server/

# Make the Shiny app directory writable by the Shiny user
RUN chown -R shiny:shiny /srv/shiny-server/

# Expose the Shiny app port
EXPOSE 3838

# Run the Shiny app
CMD ["/usr/bin/shiny-server"]
