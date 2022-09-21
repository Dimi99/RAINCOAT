# Koutsogiannis & Währer
server = shinyServer(function(input, output, session){
  max_range=500000
  # ---------------------------- Plot aesthetics ----------------------------- #
  # ---- alpha value for dot plot
  observeEvent(input$plot_alpha, {
    # get value
    alpha_value <<- input$plot_alpha
    
    # update plot
    req(input$coverage_data$datapath)
    output$main_plot = renderPlot({
      basic_plot(coverage_data_contig, input$x_range[1], input$x_range[2], alpha_value)
    })
  })
  
  # ----------------------------- Data Upload -------------------------------- #
  observeEvent(input$upload, {

    req(input$coverage_data$datapath)
    coverage_data <<- read.csv(input$coverage_data$datapath, sep='\t', header=FALSE)
    low_coverage_info <<- find_low_coverage_regions(coverage_data, input$coverage_threshold)
    
    # ----- Update sliders and inputs 
    updateSliderInput(session, "x_range", max = nrow(coverage_data))
    #updateSliderInput(session, "coverage_threshold", max = max(coverage_data[,3]), value = 10)
    updateSelectInput(session, "low_coverage_region", choices = c("OFF",low_coverage_info[,3]))
    updateSelectInput(session, "reference_seq", choices=coverage_data[,1][!duplicated(coverage_data[,1])])
    
    # ----- Basic plot
    output$main_plot = renderPlot({
      basic_plot(coverage_data, input$x_range[1], input$x_range[2], alpha_value)
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
      basic_plot(coverage_data, input$x_range[1], input$x_range[2], alpha_value)
      })
    })
  
  
  # -------------------------- Low coverage regions -------------------------- #
  # ---- find low coverage regions based on threshold
  observeEvent(input$coverage_threshold, {
    req(input$coverage_data$datapath)
    # update select input based on threshold
    low_coverage_info <<- find_low_coverage_regions(coverage_data_contig, input$coverage_threshold)
    updateSelectInput(session, "low_coverage_region", choices = c("OFF",low_coverage_info[,3]))
    req(input$GFF$datapath)
    low_cov_genes <<- low_coverage_gene(low_coverage_info,genes_df)
    updateSelectInput(session, "low_coverage_gene", choices = c("OFF",low_cov_genes$name))
  })
  
  # ---- jump to low coverage regions
  observeEvent(input$low_coverage_region, {
    req(input$coverage_data$datapath)
    if(input$low_coverage_region != "OFF"){
      start_end = as.integer(unlist(strsplit(input$low_coverage_region, " : ")))
      updateSliderInput(session, "x_range", value = c(start_end[1], start_end[2]))
    }
  })
  
  #----------------------------- select Contigs -------------------------------#
  observeEvent(input$reference_seq, {
    req(input$coverage_data$datapath)
    # subset data and change to different contig/chromosome
    coverage_data_contig <<- coverage_data[coverage_data$V1==input$reference_seq,]
    updateSliderInput(session, "x_range", max = nrow(coverage_data_contig))
    
    # update select input for low coverage regions on threshold
    low_coverage_info <<- find_low_coverage_regions(coverage_data_contig, input$coverage_threshold)
    updateSelectInput(session, "low_coverage_region", choices = c("OFF",low_coverage_info[,3]))
    
    # plot
    output$main_plot = renderPlot({
      basic_plot(coverage_data_contig, input$x_range[1], input$x_range[2])
    })
  })
  
  
  #------------------------------ Low Coverage Gene ------------------------------------#
  observeEvent(input$uploadGFF, {
    req(input$coverage_data$datapath)
    req(input$GFF$datapath)
    genes_df <<- parse_gff(input$GFF$datapath)
    if(max(genes_df$end) == nrow(coverage_data)){
      coverage_data_contig <<- depth_with_gene(coverage_data_contig, genes_df)
      low_cov = find_low_coverage_regions(coverage_data,input$coverage_threshold)
      low_cov_genes <<- low_coverage_gene(low_cov,genes_df)
      updateSelectInput(session, "low_coverage_gene", choices = c("OFF",low_cov_genes$name))
      
    }else{
      updateSelectInput(session, "low_coverage_gene", choices = "GFF not compatible with counts")
    }
    
   
  })
  
  
  observeEvent(input$low_coverage_gene, {
    req(input$coverage_data$datapath)
    req(input$GFF$datapath)
    if(input$low_coverage_gene != "OFF"){
      test_obj = low_cov_genes[which(low_cov_genes$name == input$low_coverage_gene), ]
      updateSliderInput(session, "x_range", value = c(test_obj[1,1], test_obj[1,2]))
    }
  })
  
})


