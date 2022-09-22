# Koutsogiannis & Währer

ui = fluidPage(
  
  # ----- Enables labels to the left of items ----- 
  tags$style(HTML(
    "
    .label-left .form-group {
      display: flex;              /* Use flexbox for positioning children */
      flex-direction: row;        /* Place children on a row (default) */
      width: 100%;                /* Set width for container */
      max-width: 400px;
    }

    .label-left label {
      margin-right: 2rem;         /* Add spacing between label and slider */
      align-self: center;         /* Vertical align in center of row */
      text-align: right;
      flex-basis: 100px;          /* Target width for label */
    }

    .label-left .irs {
      flex-basis: 300px;          /* Target width for slider */
    }
    "
  )), 

  # ============================ USER INTERFACE ============================== #
  theme = shinytheme("slate"),
  navbarPage("SHICT"),

  fluidRow(
    # --------------------------- Sidebar: Upload ---------------------------- #
    column(3,
      # ---- Coverage data     
      fileInput("coverage_data", label = h2("Data Upload"), accept = ".txt", 
                width = '100%'),
      div(style = "margin-top: -20px"),  # reduces space
      actionButton("upload", "Upload!", width = '100%'),
      
      # ---- GFF file
      fileInput("GFF", label = h4("GFF Upload (Optional)"), accept = ".gff", 
                width = '100%'),
      div(style = "margin-top: -20px"),  # reduces space
      actionButton("uploadGFF", "Upload!", width = '100%'),
    ),
    # -------------------------- Sidebar: Controls --------------------------- #
    column(8,
      h2("Controls"),
      sliderInput("x_range", "X-Axis range", min = 0, max = 30000, 
                  value = c(0, 1000), width = '100%'),
      sliderInput("y_range", "Y-Axis range", min = 0, max = 30000, 
                  value = c(0, 5000), width='100%')
    )
  ), # fluidRow close

  fluidRow(#style = "height:600px;",
    # ------------- Chromosome Selection/GFF Upload & Gene selection --------- #
    column(3,
           h2("Navigation"),
           # Selectinput: Contigs
           selectInput("reference_seq", "Contig/Chromosome", 
                       choices = c("Chr1", "Chr2", "..."),
                       width = '100%'),
           
           # Slider: Coverage threshold
           sliderInput("coverage_threshold", h4("Coverage Threshold"), 
                       min = 0, max = 1000, value = 10, 
                       width = '100%'),
           checkboxInput("low_cov_check", "Mark low coverage positions", value = FALSE),
           # Selectinputs: Low coverage regions/genes
           selectInput("low_coverage_region", h4("Jump to low coverage region"), 
                       choices = c("-"), width = '100%'),
           selectizeInput("low_coverage_gene", h4("Jump to low coverage gene"), 
                       choices = c("needs gff file first"), width = '100%'),
           ),
    # ------------------------------ Plot Window ----------------------------- #
    column(8,
           tabsetPanel(type = "tabs",
                       tabPanel("Main Plot",
                                plotOutput("main_plot", width = '100%', height = '550px', brush = brushOpts("plot_brush", direction = "x"))
                                ), # tabPanel "main plot" close
                       tabPanel("Selected Coordinates",
                                fluidRow(
                                  column(6, plotOutput("selection_plot", width = '100%', height = '550px')),
                                  column(6, style = "background-color:#FFFFFF;", dataTableOutput("main_plot_info"))
                                ) # fluidRow close
                                ) # tabPanel "selected coordinates" close
                       ) # tabsetPanel close
           )
  ), # fluidRow close
  
  # ------------------------------ Plot aesthetics --------------------------- #
  hr(),
  fluidRow(column(12, h2("Plot aesthetics"))),
  fluidRow(
    column(3,
           # ---- Dot and/or line plot + alpha values
           fluidRow(
             # -- Checkboxes
             column(2,
                    h4("Dots"),
                    checkboxInput("plot_dots", "Enabled", value = TRUE),
                    h4("Line"),
                    checkboxInput("plot_line", "Enabled", value = FALSE)
                    ),
             # -- Alpha sliders
             column(10,
                    div(class='label-left', sliderInput("dots_alpha", "Dots alpha", 0, 1, 0.3, width = '100%')),
                    div(class='label-left', sliderInput("line_alpha", "Line alpha", 0, 1, 1, width = '100%'))
                    )
             ), # fluidRow dots and lines close
           ),
    # ---- Axis label inputs
    # Axis labels (text inputs)
    column(3,
           div(style = "margin-top: 10px"),
           # x-Axis
           fluidRow(
             column(9, div(class='label-left', textInput("x_label", "x-Label"))),
             column(3, actionButton("set_x_text", "Set!", width = '100%'))
           ),
           div(style = "margin-top: 20px"),
           # y-Axis
           fluidRow(
             column(9, div(class='label-left', textInput("y_label", "y-Label"))),
             column(3, actionButton("set_y_text", "Set!", width = '100%'))
           ),
           ),
    # Axis label size (sliders)
    column(3,
           div(class='label-left', sliderInput("font_size", "Font size", 11, 40, 23, width = '100%')),
           div(class='label-left', sliderInput("xy_tick_size", "Useless Slider", 0, 1, 1, width = '100%'))
           )
  ) # fluidRow aesthetics close
  

  
  
) # UI close

