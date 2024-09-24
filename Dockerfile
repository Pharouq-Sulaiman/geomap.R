# Use the official R Shiny image
FROM rocker/shiny

# Install R packages required by your app
R -e "install.packages(c('shiny', 'shinydashboard', 'shinyjs', 'shinyFiles', 'tidyverse', 'sf', 'dplyr', 'mapview', 'leaflet', 'fontawesome', 'purrr', 'leaflet.extras', 'leaflet.extras2', 'leaflet.esri', 'htmltools', 'rwhatsapp', 'stringr', 'plotly', 'wordcloud2', 'ggplot2', 'tidyr', 'hms', 'text', 'stringi', 'emoji', 'janeaustenr', 'tidytext', 'writexl', 'emojifont', 'readr', 'reshape2', 'FactoMineR', 'factoextra', 'cluster', 'rio', 'SmartEDA', 'explore', 'ggraph', 'igraph', 'lubridate', 'ggimage'))"


# Copy the Shiny app into the Docker container
COPY ./app.R /srv/shiny-server/
# Make port 3838 available to the world outside this container
EXPOSE 3838

# Run Shiny Server
CMD ["/usr/bin/shiny-server"]
