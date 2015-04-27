# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()


path <- "./DATASET_BEACONS/measures_at_one_meter/d1/"

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";", dec=",")})

accuracy_data = lapply(filelist,"[",,3)
address_data  = lapply(filelist,"[",,2)
rssi_data     = lapply(filelist,"[",,7)

medianas_accuracy  <- sapply(accuracy_data, median)
medianas_rssi      <- sapply(rssi_data, median)
promedios_accuracy <- sapply(accuracy_data, mean)
promedios_rssi     <- sapply(rssi_data, mean)

par(mfrow = c(1, 2))

boxplot(rssi_data,main="RSSI Distribution at 1 meter",xlab="BEACON",ylab="RSSI [dBm]",
        names=c(paste(address_data[[1]][[1]]),paste(address_data[[2]][[1]]),paste(address_data[[3]][[1]]),paste(address_data[[4]][[1]]),paste(address_data[[5]][[1]])),
        ylim=c(-60,-110), las=1)

segments(0, -77, 6, -77, col = "RED")
axis(2, -77, las=1)

mtext(paste("Means:   ", paste(round(promedios_rssi,2),collapse=", ")),1, line=2.50, adj=0, cex=0.8, col="GRAY32")
mtext(paste("Medians: ", paste(round(medianas_rssi,2),collapse=", ")), 1, line=3.75, adj=0, cex=0.8, col="GRAY32")

boxplot(accuracy_data,main="Accuracy at 1 meter",xlab="BEACON",ylab="Distance [m]",
        names=c(paste(address_data[[1]][[1]]),paste(address_data[[2]][[1]]),paste(address_data[[3]][[1]]),paste(address_data[[4]][[1]]),paste(address_data[[5]][[1]])),
        las=1)

segments(0, 1, 6, 1, col = "RED")
axis(2, 1, las=1)

mtext(paste("Means:   ", paste(round(promedios_accuracy,2),collapse=", ")),1, line=2.50, adj=0, cex=0.8, col="GRAY32")
mtext(paste("Medians: ", paste(round(medianas_accuracy,2),collapse=", ")), 1, line=3.75, adj=0, cex=0.8, col="GRAY32")