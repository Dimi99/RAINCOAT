# Koutsogiannis & Währer
library(shiny)
library(shinythemes)
library(shinyWidgets)

source("./GUI_components/UI.R")
source("./GUI_components/server.R")

max_range=100000
options(shiny.maxRequestSize=200*1024**2) 
shinyApp(ui, server, options = list(launch.browser = TRUE))
