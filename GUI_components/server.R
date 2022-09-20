# Koutsogiannis & Währer
server = shinyServer(function(input, output, session){
  max_range=500000
  # ----------------------------- Data Upload -------------------------------- #
  observeEvent(input$upload, {

    req(input$coverage_data$datapath)
    coverage_data <<- read.csv(input$coverage_data$datapath, sep='\t', header=FALSE)
    
    # ----- Update sliders and inputs 
    updateSliderInput(session, "x_range", max = nrow(coverage_data))
    updateSliderInput(session, "coverage_threshold", max = max(coverage_data[,3]))
    updateSelectInput(session, "reference_seq", choices=coverage_data[,1][!duplicated(coverage_data[,1])])
    # ----- Basic plot

    output$main_plot = renderPlot({
      basic_plot(coverage_data, input$x_range[1], input$x_range[2])
      })
  })
  
  # ----------------------------- x-Axis control ----------------------------- #
  observeEvent(input$x_range[2],{
    # ----- Fixed x-Axis range
    if(input$x_range[1] + max_range < input$x_range[2]){
      updateSliderInput(session, "x_range", value = c(input$x_range[1], input$x_range[1] + max_range))
    }
    # ----- Plot based on sliders
    req(input$coverage_data$datapath)
    output$main_plot = renderPlot({
      basic_plot(coverage_data, input$x_range[1], input$x_range[2])
      })
    })
  
  #----------------------------- select Contigs -------------------------------#
  observeEvent(input$reference_seq, {
    req(input$coverage_data$datapath)
    df2 = coverage_data[coverage_data$V1==input$reference_seq,]
    output$main_plot = renderPlot({
      basic_plot(df2, input$x_range[1], input$x_range[2])
    })
  })
  
  
  #------------------------------ GFF Upload ------------------------------------#
  observeEvent(input$uploadGFF, {
    req(input$coverage_data$datapath)
    req(input$GFF$datapath)
    
    
    parse_gff(input$GFF$datapath)
    
    
  })
  
  
})


