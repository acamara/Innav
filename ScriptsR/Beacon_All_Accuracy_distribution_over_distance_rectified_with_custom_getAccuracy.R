# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

source('./ScriptsR/calculate_Accuracy_custom.R');

# Create calibration parameters
RSSI_0  <- c(-77, -77, -77, -77, -77)
D_0     <- c(1.00, 1.00, 1.00, 1.00, 1.00)
N       <- c(1.29, 1.35, 1.43, 1.48, 1.43)
Xg      <- c(8.02, 8.76, 11.85, 11.3, 8.83)

calibration <- data.frame(RSSI_0, D_0, N, Xg)

accuracy_rectified_all_beacons_over_distance <- function(path, beacon_name, calibration_data){

  files <- list.files(path=path,pattern="*.csv")
  filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})
  
  data <- lapply(filelist,"[",,7)
  rssi_data <-data
  
  for(i in 1:length(data)){
    rssi_data[[i]] <- data[[i]][0:50]
  }
  
  accuracy_data <- lapply(rssi_data, calculate_Accuracy_custom, calibration_data[,1], calibration_data[,2], calibration_data[,3], calibration_data[,4])
  
  boxplot(accuracy_data, main=paste("Accuracy distribution over distance - Beacon",beacon_name),xlab="Distance of mesurament [meters]",ylab="Accuracy (Estimate distance) [meters]",ylim=c(0,25), las=1, xaxt="n")
  
  axis(1, at=c(0:17), labels=seq(0,8.5, 0.5))
  axis(2, at=seq(0,30, 5), labels=seq(0,30, 5), las=1)
  
  promedios = sapply(accuracy_data, mean)
  promedios
}

par(mfrow = c(2, 3))

path <- "./DATASET_BEACONS/beacon_D0F8F2953A5C/hall_3/"
promedio_accuracy_1 <- accuracy_rectified_all_beacons_over_distance(path, "D0:F8:F2:95:3A:5C", calibration[1,])

path <- "./DATASET_BEACONS/beacon_D640866DBDDF/hall_3/"
promedio_accuracy_2 <- accuracy_rectified_all_beacons_over_distance(path, "D6:40:86:6D:BD:DF", calibration[2,])

path <- "./DATASET_BEACONS/beacon_D9A3286AA7F1/hall_3/"
promedio_accuracy_3 <- accuracy_rectified_all_beacons_over_distance(path, "D9:A3:28:6A:A7:F1", calibration[3,])

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_3/"
promedio_accuracy_4 <- accuracy_rectified_all_beacons_over_distance(path, "F5:7A:A5:E3:EF:18", calibration[4,])

path <- "./DATASET_BEACONS/beacon_FFA67CAFB0CB/hall_3/"
promedio_accuracy_5 <- accuracy_rectified_all_beacons_over_distance(path, "FF:A6:7C:AF:B0:CB", calibration[5,])

x = c(1:17)

plot(x, promedio_accuracy_1, type="n", main = "Mean accuracy evolution over distance",  xlab="Distance of mesurament [meters]", ylab="Accuracy (Estimate distance) [meters]",las=1, ylim=c(0,25), xaxt="n", yaxt="n")
axis(1, at=c(0:17), labels=seq(0,8.5, 0.5))
axis(2, at=seq(0,30, 5), labels=seq(0,30, 5), las=1)

lines(x, promedio_accuracy_1, type='o', col="red")
lines(x, promedio_accuracy_2, type='o', col="blue")
lines(x, promedio_accuracy_3, type='o', col="green4")
lines(x, promedio_accuracy_4, type='o', col="cornflowerblue")
lines(x, promedio_accuracy_5, type='o', col="orange")

legend(9.5,28, c("D0:F8:F2:95:3A:5C","D6:40:86:6D:BD:DF","D9:A3:28:6A:A7:F1","F5:7A:A5:E3:EF:18","FF:A6:7C:AF:B0:CB"), lwd=1, col=c('red', 'blue', 'green4','cornflowerblue','orange'), bty='n', xjust=0, x.intersp=0.1, y.intersp=0.2, seg.len=0.10, cex=1)