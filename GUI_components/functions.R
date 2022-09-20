# --------------------- Basic plot in specified window ----------------------- #
basic_plot = function(data, start_coord, end_coord){
  plot(data[start_coord:end_coord,]$V3, pch = 20, cex=0.1,
       main="Intergenic Mapping: Coverage",
       ylab = "Mapped Bases",
       xlab="Intergenic Position",
       col=rgb(red = 0, green = 0, blue = 0, alpha=0.3),
       cex.lab=2.5, cex.axis=1, cex.main=2.5, cex.sub=2.5)
}


# ------------------- Low coverage threshold - related ----------------------- #
find_low_coverage_regions = function(coverage_data, threshold){
  "
  Function that returns a vector of nucleotide coordinates with each entry 
  consisting of the start- and end-coordinate of a consistent region below
  the threshold.
  "
  
  
}



# thr = 10
# t1 = which(coverage_data$V3 < thr)
# View(rle(diff(t1)))
# 
# diff(t1)[9:(9+59)]
