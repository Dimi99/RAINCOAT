# Koutsogiannis & Währer
server = shinyServer(function(input, output, session){
  # ----------------------------- Data Upload -------------------------------- #
  observeEvent(input$upload, {

    # CATCH COVERAGE DATA NOT YET LOADED
    coverage_data <<- read.csv(input$coverage_data$datapath, sep='\t', header=FALSE)
    updateSliderInput(session, "x_range", max = nrow(coverage_data))
    output$main_plot = renderPlot({
      plot(coverage_data$V3[input$x_range[1]:input$x_range[2]], pch = 20, cex=0.1,
           main="Intergenic Mapping: Coverage",
           ylab = "Mapped Bases",
           xlab="Intergenic Position",
           col=rgb(red = 0, green = 0, blue = 0, alpha=0.3),
           cex.lab=2.5, cex.axis=1, cex.main=2.5, cex.sub=2.5)
      })
  })
  
  # ------------------------- x-Axis, fixed range ---------------------------- #
  observeEvent(input$x_range[2],{
    if(input$x_range[1] + max_range < input$x_range[2]){
      updateSliderInput(session, "x_range", value = c(input$x_range[1], input$x_range[1] + max_range))
    }
    # CATCH COVERAGE DATA NOT YET LOADED
    output$main_plot = renderPlot({
      plot(coverage_data$V3[input$x_range[1]:input$x_range[2]], pch = 20, cex=0.1,
           main="Intergenic Mapping: Coverage",
           ylab = "Mapped Bases",
           xlab="Intergenic Position",
           col=rgb(red = 0, green = 0, blue = 0, alpha=0.3),
           cex.lab=2.5, cex.axis=1, cex.main=2.5, cex.sub=2.5)
      })
    })
})