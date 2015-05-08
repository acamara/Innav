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