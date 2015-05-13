# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/beacon_F57AA5E3EF18_d_1.0_04-04-2015_192204719.csv"

data <- read.csv(path, head=TRUE, sep=";")

rssi = data$Rssi

time = as.POSIXlt(x = paste(substr(as.character(data$System.timestamp),start=1,stop=19),".",substr(as.character(data$System.timestamp),start=21,stop=23), sep=""), format = "%d/%m/%Y %H:%M:%OS")
xtime= rep(0, length(time))

for(i in 1:length(time)){
  xtime[i] <- difftime(time[i], time[1], units ="secs")
}

plot(xtime[1:100], rssi[1:100], type="n", main="RSSI over Time - Beacon F5:7A:A5:E3:EF:18", xlab="Time [seconds]",ylab="RSSI [dBm]",ylim=c(-55,-75), las=1)

lines(xtime[1:100], rssi[1:100], type="o") 