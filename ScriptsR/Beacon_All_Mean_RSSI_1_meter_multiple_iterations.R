# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

calculate_mean_rssi_all_beacons_1_meter <- function(path){
  files <- list.files(path=path,pattern="*.csv")
  filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})
  
  rssi_data = lapply(filelist,"[",,7)
  
  promedio = sapply(rssi_data,mean)
  promedio
}

path <- "./DATASET_BEACONS/measures_at_one_meter/d1/"
d1 <- calculate_mean_rssi_all_beacons_1_meter(path)
  
path <- "./DATASET_BEACONS/measures_at_one_meter/d2/"
d2 <- calculate_mean_rssi_all_beacons_1_meter(path)

path <- "./DATASET_BEACONS/measures_at_one_meter/d3/"
d3 <- calculate_mean_rssi_all_beacons_1_meter(path)

path <- "./DATASET_BEACONS/measures_at_one_meter/d4/"
d4 <- calculate_mean_rssi_all_beacons_1_meter(path)

path <- "./DATASET_BEACONS/measures_at_one_meter/d5/"
d5 <- calculate_mean_rssi_all_beacons_1_meter(path)

path <- "./DATASET_BEACONS/measures_at_one_meter/d6/"
d6 <- calculate_mean_rssi_all_beacons_1_meter(path)

data <- data.frame("D0:F8:F2:95:3A:5C" = numeric(0),"D6:40:86:6D:BD:DF" = numeric(0),"D9:A3:28:6A:A7:F1" = numeric(0),"F5:7A:A5:E3:EF:18" = numeric(0),"FF:A6:7C:AF:B0:CB" = numeric(0), stringsAsFactors=FALSE)

data[nrow(data) + 1,] <- d1
data[nrow(data) + 1,] <- d2
data[nrow(data) + 1,] <- d3
data[nrow(data) + 1,] <- d4
data[nrow(data) + 1,] <- d5
data[nrow(data) + 1,] <- d6

summary(data)
