# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/"

files <- list.files(path=path,pattern="*.csv")

filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";", dec=",")})

boxplot(lapply(filelist,"[",,3),main="Accuracy Distribution - Beacon F5:7A:A5:E3:EF:18",xlab="Distance of mesurament [meters]",ylab="Accuracy (Estimate distance) [meters]",las=1, xaxt="n", yaxt="n")

axis(1, at=0:20, labels=0.50*(0:20))
axis(2, at=0:20, labels=0.50*(0:20),las=1)
