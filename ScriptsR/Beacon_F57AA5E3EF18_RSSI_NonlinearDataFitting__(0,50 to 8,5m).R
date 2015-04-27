# Beacon_F57AA5E3EF18_RSSI_NonlinearDataFitting__(0.50 to 8.5m)

# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()


path <- "./DATASET_BEACONS/beacon_F57AA5E3EF18/hall_1/"

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

rssi_data = lapply(filelist,"[",,7)

medianas  <- sapply(rssi_data, median)
promedios <- sapply(rssi_data, mean)
minimos   <- sapply(rssi_data, min)
maximos   <- sapply(rssi_data, max)

# construct the data vectors
xdata = seq(0.5, 8.5, 0.5)
ydata = promedios

# look at it
plot(xdata, ydata, main="Mean RSSI Distribution over Distance - Beacon F5:7A:A5:E3:EF:18", xlab="Distance [meters]", ylab="RSSI [dBm]", las=1, xaxt="n")
axis(1, at=seq(0.5, 8.5, 0.5), labels=seq(0.5, 8.5, 0.5))

# some starting values
p1 = -77
p2 = 2
p3 = 3

# do the fit
fit = nls(ydata ~ p1-10*p2*log10(xdata), start=list(p1=p1,p2=p2))

# summarise
summary(fit)

new = data.frame(xdata = seq(min(xdata),max(xdata),len=200))
lines(new$xdata,predict(fit,newdata=new), col='BLUE')