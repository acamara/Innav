# View accuracy for all beacons from 0 meters to 8 meters

# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

source('./ScriptsR/calculate_Accuracy_custom.R');

boxplot_accuracy_all_beacons_specific_distance <- function(path, distance){

  files <- list.files(path=path,pattern="*.csv")
  filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";", dec=".")})
  
  rssi_data = lapply(filelist,"[",,7)
  accuracy_data = lapply(filelist,"[",,3)
  address_data = lapply(filelist,"[",,2)
  
  promedios_rssi <- lapply(rssi_data, mean)
  
  # Accuracy rectificada con modelo propio de path lost
  accuracy_data <- lapply(rssi_data, calculate_Accuracy_custom, -77, 1, 2, 0)
  medianas_accuracy  <- sapply(accuracy_data, median)
  promedios_accuracy <- sapply(accuracy_data, mean)
  
  boxplot(accuracy_data,main=paste("Accuracy at ", distance, " meters rectified with custom getAccuracy"),xlab="BEACON",ylab="Distance [m]",
          names=c(paste(address_data[[1]][[1]]),paste(address_data[[2]][[1]]),paste(address_data[[3]][[1]]),paste(address_data[[4]][[1]]),paste(address_data[[5]][[1]])),
          ylim=c(0,8), las=1)
  
  segments(0, distance, 6, distance, col = "RED")
  axis(2, distance, las=1)
  
  mtext(paste("Means:   ", paste(round(promedios_accuracy,2),collapse=", ")),1, line=2.50, adj=0, cex=0.8, col="GRAY32")
  mtext(paste("Medians: ", paste(round(medianas_accuracy,2),collapse=", ")), 1, line=3.75, adj=0, cex=0.8, col="GRAY32")
}

par(mfrow = c(2, 3))

path <- "./DATASET_BEACONS/measures_at_zero_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 0)

path <- "./DATASET_BEACONS/measures_at_one_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 1)

path <- "./DATASET_BEACONS/measures_at_two_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 2)

path <- "./DATASET_BEACONS/measures_at_three_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 3)

path <- "./DATASET_BEACONS/measures_at_four_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 4)

path <- "./DATASET_BEACONS/measures_at_five_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 5)

path <- "./DATASET_BEACONS/measures_at_six_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 6)

path <- "./DATASET_BEACONS/measures_at_seven_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 7)

path <- "./DATASET_BEACONS/measures_at_eight_meter/d1/"

boxplot_accuracy_all_beacons_specific_distance(path, 8)
