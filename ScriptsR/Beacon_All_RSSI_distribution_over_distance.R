# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()


rssi_all_beacons_over_distance <- function(path, beacon_name){
  files <- list.files(path=path,pattern="*.csv")
  filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})
  
  rssi_data = lapply(filelist,"[",,7)
    
  boxplot(rssi_data,main=paste("RSSI Distribution over distance - Beacon",beacon_name),xlab="Distance [m]", ylim=c(-100,-50), ylab="RSSI [dBm]",las=1, xaxt="n")
  axis(1, at=c(0:17), labels=seq(0,8.5, 0.5))
  
  promedios = sapply(rssi_data, mean)
  promedios
}

par(mfrow = c(2, 3))

path <- "./DATASET_BEACONS/beacon_D0F8F2953A5C/hall_3/"
promedio_rssi_1 <- rssi_all_beacons_over_distance(path, "D0:F8:F2:95:3A:5C")

path <- "./DATASET_BEACONS/beacon_D640866DBDDF/hall_3/"
promedio_rssi_2 <- rssi_all_beacons_over_distance(path, "D6:40:86:6D:BD:DF")

path <- "./DATASET_BEACONS/beacon_D9A3286AA7F1/hall_3/"
promedio_rssi_3 <- rssi_all_beacons_over_distance(path, "D9:A3:28:6A:A7:F1")

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_3/"
promedio_rssi_4 <- rssi_all_beacons_over_distance(path, "F5:7A:A5:E3:EF:18")

path <- "./DATASET_BEACONS/beacon_FFA67CAFB0CB/hall_3/"
promedio_rssi_5 <- rssi_all_beacons_over_distance(path, "FF:A6:7C:AF:B0:CB")

x = c(1:17)

plot(x, promedio_rssi_1, type="n", main = "Mean RSSI evolution over distance",  xlab="Distance [meters]", ylab="RSSI [dBm]",las=1, xlim=c(0,18), ylim=c(-100,-50), xaxt="n")
axis(1, at=c(0:17), labels=seq(0,8.5, 0.5))

lines(x, promedio_rssi_1, type='o', col="red")
lines(x, promedio_rssi_2, type='o', col="blue")
lines(x, promedio_rssi_3, type='o', col="green4")
lines(x, promedio_rssi_4, type='o', col="cornflowerblue")
lines(x, promedio_rssi_5, type='o', col="orange")

legend(9,-48, c("D0:F8:F2:95:3A:5C","D6:40:86:6D:BD:DF","D9:A3:28:6A:A7:F1","F5:7A:A5:E3:EF:18","FF:A6:7C:AF:B0:CB"), lwd=1, col=c('red', 'blue', 'green4','cornflowerblue','orange'), bty='n', xjust=0, x.intersp=0.1, y.intersp=0.2, seg.len=0.10, cex=1)