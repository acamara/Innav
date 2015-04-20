# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/beacon_F57AA5E3EF18_d_1.0_04-04-2015_192204719.csv"

data <- read.csv(path, head=TRUE, sep=";")

hist <- hist(data$Rssi,main="RSSI distribution [1 Meter] - Beacon F5:7A:A5:E3:EF:18",xlab="RSSI [dBm]",xlim=c(-55,-75),ylim=c(0,400), col=rgb(0,0,0,0.3))