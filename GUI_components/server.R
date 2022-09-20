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
})