# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()


data_fiting <- function(path, distance, beacon){
  
  files <- list.files(path=path,pattern="*.csv")
  filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})
  
  rssi_data = lapply(filelist,"[",,7)
  
  # construct the data vectors
  xdata <- distance
  ydata <- sapply(rssi_data, mean)
  ydata_median <- sapply(rssi_data, median)
  
  # look at it
  plot(xdata, ydata, main=paste("Mean RSSI Distribution over Distance - ", beacon), xlab="Distance [meters]", ylab="RSSI [dBm]", ylim=c(-95,-55), las=1, xaxt="n")
  axis(1, at=distance, labels=distance)
  
  # points(xdata, ydata_median, col="RED")
  
  # some starting values
  rssi_0 = -77
  p2 = 2
  p3 = 0
  
  # do the fit
  fit = nls(ydata ~ rssi_0-10*p2*log10(xdata)+p3, start=list(p2=p2,p3=p3))
  
  # summarise
  summary(fit)
  
  new = data.frame(xdata = seq(min(xdata),max(xdata),len=200))
  lines(new$xdata,predict(fit,newdata=new), col='BLUE')
  
  parameters <- round(coef(fit), 2)
  
  mtext(paste("n: ", parameters[[1]], " Xg: ", parameters[[2]]), 1, line=3, adj=0, cex=0.8, col="GRAY32")
  
  
  fit
}

par(mfrow = c(2, 3))

distances <- seq(0.5, 8.5, 0.5)

path <- "./DATASET_BEACONS/beacon_D0F8F2953A5C/hall_3/"
data_fiting(path, distances, "Beacon D0:F8:F2:95:3A:5C")

path <- "./DATASET_BEACONS/beacon_D9A3286AA7F1/hall_3/"
data_fiting(path, distances, "Beacon D9:A3:28:6A:A7:F1")

path <- "./DATASET_BEACONS/beacon_D640866DBDDF/hall_3/"
data_fiting(path, distances, "Beacon D6:40:86:6D:BD:DF")

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_3/"
data_fiting(path, distances, "Beacon F5:7A:A5:E3:EF:18")

path <- "./DATASET_BEACONS/beacon_FFA67CAFB0CB/hall_3/"
data_fiting(path, distances, "Beacon FF:A6:7C:AF:B0:CB")