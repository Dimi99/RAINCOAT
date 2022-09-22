# Koutsogiannis & Währer
library(ggplot2)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(rtracklayer)
library(dplyr) 
library(tidyr)
library(Rcpp)


source("./GUI_components/UI.R")
source("./GUI_components/server.R")
source("./GUI_components/functions.R")
sourceCpp("./Rcpp/subset.cpp")
sourceCpp("./Rcpp/add_gene_column.cpp")
sourceCpp("./Rcpp/remove_duplicates.cpp")


options(shiny.maxRequestSize=200*1024**2) 
shinyApp(ui, server, options = list(launch.browser = TRUE))
