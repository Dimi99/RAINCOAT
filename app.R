# Koutsogiannis & Währer
library(ggplot2)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(rtracklayer)


source("./GUI_components/UI.R")
source("./GUI_components/server.R")
source("./GUI_components/functions.R")


options(shiny.maxRequestSize=200*1024**2) 
shinyApp(ui, server, options = list(launch.browser = TRUE))
