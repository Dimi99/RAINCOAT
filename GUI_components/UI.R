# Koutsogiannis & Währer

ui = fluidPage(
  theme = shinytheme("slate"),
  navbarPage("SHICT"),
  fluidRow(
    column(3,
    # --------------------------- Sidebar: Upload ---------------------------- #
      fileInput("coverage_data", label = h2("Data Upload"), accept = ".txt", 
                width = '100%'),
      div(style = "margin-top: -20px"),  # reduces space
      actionButton("upload", "Upload!", width = '100%')
    ),
    column(8,
    # -------------------------- Sidebar: Controls --------------------------- #
      h2("Controls"),
      sliderInput("x_range", "X-Axis range", min = 0, max = 30000, 
                  value = c(0, 1000), width = '95%'),
      sliderInput("y_range", "Y-Axis range", min = 0, max = 30000, 
                  value = c(0, 5000), width='95%')
    )
  ), # fluidRow close
  fluidRow(style = "height:800px;",
    # ------------- Chromosome Selection/GFF Upload & Gene selection --------- #
    column(3,
           h2("Navigation"),
           selectInput("reference_seq", "Contig/Chromosome", 
                       choices = c("Chr1", "Chr2", "..."),
                       width = '100%'),
           fileInput("GFF", label = h2("GFF Upload"), accept = ".gff", 
                     width = '100%'),
           div(style = "margin-top: -20px"),  # reduces space
           
           actionButton("uploadGFF", "Upload!", width = '100%'),
           sliderInput("coverage_threshold", h4("Coverage Threshold"), 
                       min = 0, max = 1000, value = 10, 
                       width = '100%'),
           selectInput("low_coverage_region", h4("Jump to low coverage region"), 
                       choices = c("-"), width = '100%'),

           h2("Plot aesthetics"),
           sliderInput("plot_alpha", h4("Alpha"), 
                       min = 0, max = 1, value = 0.3, 
                       width = '100%'),
           selectInput("low_coverage_gene", h4("Jump to low coverage gene"), 
                       choices = c("needs gff file first"), width = '100%'),
           
           ),
    column(8,
           plotOutput("main_plot", width = '95%', height = '800px')
           )
    
  )
  
  # ---------------------------- Main panel: Plot ---------------------------- #
)

