# Beacon_D640866DBDDF_RSSI_NonlinearDataFitting_room

# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()


path <- "./DATASET_BEACONS/measures_from_three_beacons_simultaneously/room1/beacon_D640866DBDDF/"

distances <- c(3.65, 3.47, 3.29, 3.12, 2.97, 2.83, 2.71, 2.60, 2.51, 2.45, 2.41, 2.40, 2.41, 2.45, 2.51, 2.60)

files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

data = lapply(filelist,"[",,7)

mydata <- data.frame(replicate(16,numeric(0)))

for(i in 0:19){
  ini = 50*i+1
  fin = 50*i+50
  mydata <- rbind(mydata,c(mean(data[[1]][ini:fin]), mean(data[[2]][ini:fin]), mean(data[[3]][ini:fin]), 
                           mean(data[[4]][ini:fin]), mean(data[[5]][ini:fin]), mean(data[[6]][ini:fin]), 
                           mean(data[[7]][ini:fin]), mean(data[[8]][ini:fin]), mean(data[[9]][ini:fin]), 
                           mean(data[[10]][ini:fin]), mean(data[[11]][ini:fin]), mean(data[[12]][ini:fin]),
                           mean(data[[13]][ini:fin]), mean(data[[14]][ini:fin]), mean(data[[15]][ini:fin]),
                           mean(data[[16]][ini:fin])))
}

colnames(mydata) <- distances

# construct the data vectors
xdata = distances
ydata =  as.numeric(mydata[1,])

# look at it
plot(xdata, ydata, main="Mean RSSI Distribution over Distance - Beacon D6:40:86:6D:BD:DF", xlab="Distance [meters]", ylab="RSSI [dBm]", las=1, xaxt="n")
axis(1, at=xdata, labels=xdata)

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

real_distance <- distances
estimate_distance <- (10^((-77-mydata+parameters[[2]])/(10*parameters[[1]])))

error <- abs(sweep(estimate_distance,2,real_distance))
error_medio <- rowMeans(error)
error <-cbind(error,error_medio)