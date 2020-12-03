# Used packages
packs = c("shiny", "shinydashboard", "tidyverse", "scales", "DT",
          "leaflet","RColorBrewer", "widgetframe", "lubridate",  "plotly",
          "shinydashboardPlus", "htmlwidgets")

# Run the following command to verify that the required packages are installed. If some package
# is missing, it will be installed automatically
package.check <- lapply(packs, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
  }
})

# Define working directory
data <- source('data.R')
