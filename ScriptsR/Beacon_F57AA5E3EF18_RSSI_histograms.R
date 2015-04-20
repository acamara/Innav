# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

setwd("C:/Users/Albert/Desktop/Albert/UOC/Semestre 7 2014-15 (2)/TFM - Sistemes de comunicació/Scripts R")

path <- "C:/Users/Albert/Desktop/Albert/UOC/Semestre 7 2014-15 (2)/TFM - Sistemes de comunicació/DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/"

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

rssi_data = lapply(filelist,"[",,7)

medianas  <- sapply(rssi_data, median)
promedios <- sapply(rssi_data, mean)
minimos   <- sapply(rssi_data, min)
maximos   <- sapply(rssi_data, max)

par(mfrow = c(2, 3))

for (i in 1:length(rssi_data)) {
  x = rssi_data[[i]]
  hist(x, main=paste("RSSI distribution at ",0+0.5*i," meters - Beacon F5:7A:A5:E3:EF:18"), xlab="RSSI [dBm]", xlim=c(-55,-115), ylim=c(0,700), breaks=-seq(55,115,by=1), col=rgb(0,0,0,0.3))
  
  box()
  
  if(i/6 ==0){
    dev.new()
  }
}

plot(promedios, main = "Mean RSSi evolution over distance - Beacon F5:7A:A5:E3:EF:18",  xlab="Distance [meters]", ylab="RSSI [dBm]",las=1, xlim=c(0,18), xaxt="n")
axis(1, at=1:18, labels=0.5*(1:18))
lines(promedios)