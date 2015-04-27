# View RSSI for all beacons from 0.5 meters to 5 meters

# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

boxplot_rssi_all_beacons_specific_distance_grouping <- function(path, distance, objective_RSSI, samples_group){ 
    
  files <- list.files(path=path,pattern="*.csv")
  filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})
  
  address_list = lapply(filelist,"[",,2)
  rssi_data = lapply(filelist,"[",,7)
  
  
  for(i in 1:length(rssi_data)){
    rssi_data[[i]] = tapply(rssi_data[[i]], rep(1:(length(rssi_data[[i]])/samples_group), each = samples_group), mean)
  }
  
  medianas_rssi  <- sapply(rssi_data, median)
  promedios_rssi <- sapply(rssi_data, mean)
  
  boxplot(rssi_data, main=paste("RSSI Distribution at ", distance, "meters"),xlab="BEACONS",ylab="RSSI [dBm]",
          names=c(paste(address_list[[1]][[1]]),paste(address_list[[2]][[1]]),paste(address_list[[3]][[1]]),paste(address_list[[4]][[1]]),paste(address_list[[5]][[1]])),
          ylim=c(-60,-110), las=1)
  
  segments(0, objective_RSSI, 6, objective_RSSI, col = "RED")
  
  axis(2, objective_RSSI, las=1)
  
  mtext(paste("Means:   ", paste(round(promedios_rssi,2),collapse=", ")),1, line=2.50, adj=0, cex=0.8, col="GRAY32")
  mtext(paste("Medians: ", paste(round(medianas_rssi,2),collapse=", ")), 1, line=3.75, adj=0, cex=0.8, col="GRAY32")
}


par(mfrow = c(2, 3))

path <- "./DATASET_BEACONS/measures_at_half_meter/d1/"

boxplot_rssi_all_beacons_specific_distance_grouping(path, 0.5, -70.98, 5)

path <- "./DATASET_BEACONS/measures_at_one_meter/d1/"

boxplot_rssi_all_beacons_specific_distance_grouping(path, 1, -77, 5)

path <- "./DATASET_BEACONS/measures_at_two_meter/d1/"

boxplot_rssi_all_beacons_specific_distance_grouping(path, 2, -83.02, 5)

path <- "./DATASET_BEACONS/measures_at_three_meter/d1/"

boxplot_rssi_all_beacons_specific_distance_grouping(path, 3, -86.54, 5)

path <- "./DATASET_BEACONS/measures_at_four_meter/d1/"

boxplot_rssi_all_beacons_specific_distance_grouping(path, 4, -89.04, 5)

path <- "./DATASET_BEACONS/measures_at_five_meter/d1/"

boxplot_rssi_all_beacons_specific_distance_grouping(path, 5, -90.98, 5)