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
  
  
  # look at it
  plot(xdata, ydata, main=paste("Mean RSSI Distribution over Distance - ", beacon), xlab="Distance [meters]", ylab="RSSI [dBm]", ylim=c(-95,-65), las=1, xaxt="n")
  axis(1, at=distance, labels=distance)
  
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

path <- "./DATASET_BEACONS/measures_from_three_beacons_simultaneously/room1/beacon_D0F8F2953A5C/"
distances <- c(0.27, 0.51, 0.76, 1.00, 1.25, 1.50, 1.75, 2.00, 2.25, 2.50, 2.75, 3.00, 3.25, 3.50, 3.75, 4.00)      
data_fiting(path, distances, "Beacon D0:F8:F2:95:3A:5C")

path <- "./DATASET_BEACONS/measures_from_three_beacons_simultaneously/room1/beacon_D9A3286AA7F1/"
distances <- c(5.58, 5.35, 5.11, 4.87, 4.63, 4.40, 4.17, 3.94, 3.71, 3.49, 3.27, 3.05, 2.84, 2.64, 2.45, 2.26)
data_fiting(path, distances, "Beacon D9:A3:28:6A:A7:F1")

path <- "./DATASET_BEACONS/measures_from_three_beacons_simultaneously/room1/beacon_D640866DBDDF/"
distances <- c(3.65, 3.47, 3.29, 3.12, 2.97, 2.83, 2.71, 2.60, 2.51, 2.45, 2.41, 2.40, 2.41, 2.45, 2.51, 2.60)
data_fiting(path, distances, "Beacon D6:40:86:6D:BD:DF")