# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/"

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

rssi_data = lapply(filelist,"[",,7)
promedios <- sapply(rssi_data, mean)

par(mfrow = c(2, 3))

for (i in 1:length(rssi_data)) {
  x <- -rssi_data[[i]]
  
  hist(x, freq=FALSE, main=paste("RSSI density distribution at ",0+0.5*i," meters - Beacon F5:7A:A5:E3:EF:18"), xlab="RSSI [dBm]", xlim=c(55,115), ylim=c(0,1), breaks=seq(55,115,by=1), col=rgb(0,0,0,0.3), las=1)
  
  # estimate paramters
  library(MASS)
  fit <- fitdistr(x, "lognormal")
  curve(dlnorm(x, mean=fit$estimate[[1]], sd=fit$estimate[[2]]), col="red", add=TRUE)
  
  box()
  
  if(i/6 == 0){
    dev.new()
  }
}

plot(promedios, main = "Mean RSSi evolution over distance - Beacon F5:7A:A5:E3:EF:18",  xlab="Distance [meters]", ylab="RSSI [dBm]",las=1, xlim=c(0,18), xaxt="n")
axis(1, at=1:18, labels=0.5*(1:18))
lines(promedios)