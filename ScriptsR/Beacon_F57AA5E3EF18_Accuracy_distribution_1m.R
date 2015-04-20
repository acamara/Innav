# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

setwd("C:/Users/Albert/Desktop/Albert/UOC/Semestre 7 2014-15 (2)/TFM - Sistemes de comunicació/Scripts R")

path <- "C:/Users/Albert/Desktop/Albert/UOC/Semestre 7 2014-15 (2)/TFM - Sistemes de comunicació/DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/beacon_F57AA5E3EF18_d_1.0_04-04-2015_192204719.csv"

data <- read.csv(path, head=TRUE, sep=";", dec=",")

hist(data$Accuracy,main="Accuracy distribution [1 Meter] - Beacon F5:7A:A5:E3:EF:18",xlab="Distance [meters]", xlim=c(0,1), col=rgb(0,0,0,0.3))