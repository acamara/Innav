# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

source('./ScriptsR/calculate_Accuracy_kontakt.R');

path <- "./DATASET_BEACONS/measures_at_one_meter/d1/"

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";", dec=",")})

rssi_data = lapply(filelist,"[",,7)
accuracy_data = lapply(filelist,"[",,3)
address_data = lapply(filelist,"[",,2)

promedios_rssi <- lapply(rssi_data, mean)

par(mfrow = c(1, 2))

# Accuracy original
medianas_accuracy  <- sapply(accuracy_data, median)
promedios_accuracy <- sapply(accuracy_data, mean)

boxplot(accuracy_data,main="Accuracy at 1 meter",xlab="BEACON",ylab="Distance [m]",
        names=c(paste(address_data[[1]][[1]]),paste(address_data[[2]][[1]]),paste(address_data[[3]][[1]]),paste(address_data[[4]][[1]])),
        ylim=c(0,7), las=1)

segments(0, 1, 5, 1, col = "RED")
axis(2, 1, las=1)

mtext(paste("Means:   ", paste(round(promedios_accuracy,2),collapse=", ")),1, line=2.50, adj=0, cex=0.8, col="GRAY32")
mtext(paste("Medians: ", paste(round(medianas_accuracy,2),collapse=", ")), 1, line=3.75, adj=0, cex=0.8, col="GRAY32")


# Accuracy rectificada con el promedio de RSSi y modelo de kontakt

for(i in 1:length(rssi_data)){
  accuracy_data[[i]] <- sapply(rssi_data[[i]], calculate_Accuracy_kontakt, txPower=promedios_rssi[[i]])
}

medianas_accuracy  <- sapply(accuracy_data, median)
promedios_accuracy <- sapply(accuracy_data, mean)

boxplot(accuracy_data,main="Accuracy at 1 meter rectified with RSSI mean and kontakt getAccuracy",xlab="BEACON",ylab="Distance [m]",
        names=c(paste(address_data[[1]][[1]]),paste(address_data[[2]][[1]]),paste(address_data[[3]][[1]]),paste(address_data[[4]][[1]])),
        ylim=c(0,7), las=1)

segments(0, 1, 5, 1, col = "RED")
axis(2, 1, las=1)

mtext(paste("Means:   ", paste(round(promedios_accuracy,2),collapse=", ")),1, line=2.50, adj=0, cex=0.8, col="GRAY32")
mtext(paste("Medians: ", paste(round(medianas_accuracy,2),collapse=", ")), 1, line=3.75, adj=0, cex=0.8, col="GRAY32")