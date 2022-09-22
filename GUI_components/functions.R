# --------------------- Basic plot in specified window ----------------------- #
basic_plot = function(data, start_coord, end_coord, alpha=0.3){
  plot(data[start_coord:end_coord,]$V3, pch = 20, cex=0.1,
       main="Intergenic Mapping: Coverage",
       ylab = "Mapped Bases",
       xlab="Intergenic Position",
       col=rgb(red = 0, green = 0, blue = 0, alpha=alpha),
       cex.lab=2.5, cex.axis=1, cex.main=2.5, cex.sub=2.5)
}



basic_plot = function(data, start_coord, end_coord, plot_dots = TRUE, 
                      plot_lines = FALSE, dots_alpha=0.3, line_alpha=1){
  # subset data
  data_subset = data[start_coord:end_coord,]
  colnames(data_subset)[2:3] = c("V2", "V3")
  # basic plot
  p1 = ggplot(data = data_subset, aes(x=V2, y=V3)) + 
    theme_bw() + 
    labs(x = "Position in Reference", y = "Coverage")
    
  # add dots
  if(plot_dots){
    p1 = p1 + geom_point(alpha=dots_alpha) 
  }
  # add lines
  if(plot_lines){
    p1 = p1 + geom_line(alpha=line_alpha)
  }
  return(p1)
}

# ------------------- Low coverage threshold - related ----------------------- #
find_low_coverage_regions = function(coverage_data, threshold){
  "
  Function that returns a vector of nucleotide coordinates with each entry 
  consisting of the start- and end-coordinate of a consistent region below
  the threshold.
  "
  # find consecutive low coverage coordinates and length of these regions
  low_cov = which(coverage_data$V3 < threshold)
  start = c(low_cov[1], low_cov[c(0, diff(low_cov)) > 1])
  end = c(low_cov[diff(low_cov) > 1], low_cov[length(low_cov)])
  
  if(end[length(end)] == length[length(end)-1]){
    # this case occurs if the last low coverage region consists of only a single base
    end = end[-length(end)]
  }
  
  start_end_regions = data.frame(start, end)
  start_end_regions$choices = paste(start_end_regions[,1], " : ", start_end_regions[,2])
  
  return(start_end_regions)
  
}

# # ------------------- GFF-Parsing - related ----------------------- #

parse_gff = function(filepath){
  my_columns <- c( "start", "end", "strand")
  df3 <- readGFF(filepath, columns=my_columns)
  zu = data.frame(df3$start, df3$end, df3$Name, df3$strand)
  colnames(zu) = c("start","end","id","strand")
  zu$id<- zu$id %>% replace_na("XXX")
  out = remove_duplicates(zu)
  return(out)
}

