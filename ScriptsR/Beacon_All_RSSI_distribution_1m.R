# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

path <- "./DATASET_BEACONS/measures_at_one_meter/d2/"

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

address_list = lapply(filelist,"[",,2)
rssi_data = lapply(filelist,"[",,7)

par(mfrow = c(2, 3))

for (i in 1:length(rssi_data)) {
  x = rssi_data[[i]]
  hist(x, main=paste("RSSI distribution at 1 Meter - Beacon ",address_list[[i]][[1]]), xlab="RSSI [dBm]", xlim=c(-65,-105), ylim=c(0,600), breaks=-seq(65,105,by=1), col=rgb(0,0,0,0.3))
    
  box()
    
  if(i/6 ==0){
    dev.new()
  }
}

boxplot(rssi_data, main="RSSI Distribution at 1 meter",xlab="BEACON",ylab="RSSI [dBm]",
        names=c(paste(address_list[[1]][[1]]),paste(address_list[[2]][[1]]),paste(address_list[[3]][[1]]),paste(address_list[[4]][[1]]),paste(address_list[[5]][[1]])),
        ylim=c(-60,-100), las=1)

segments(0, -77, 6, -77, col = "RED")

axis(2, -77, las=1)