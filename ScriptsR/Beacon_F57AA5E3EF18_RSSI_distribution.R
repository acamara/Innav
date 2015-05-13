# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/"

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

boxplot(lapply(filelist,"[",,7),main="RSSI Distribution - Beacon F5:7A:A5:E3:EF:18",xlab="Distance [m]",ylab="RSSI [dBm]",las=1, xaxt="n")
axis(1, at=c(0:17), labels=seq(0,8.5, 0.5))
