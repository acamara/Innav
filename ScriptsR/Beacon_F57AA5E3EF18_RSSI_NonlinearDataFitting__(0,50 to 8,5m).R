# Beacon_F57AA5E3EF18_RSSI_NonlinearDataFitting__(0.50 to 8.5m)

# construct the data vectors
xdata = seq(0.5, 8.5, 0.5)
ydata = c(-67.274, -64.015, -67.980, -74.039, -70.670, -71.513, -79.871, -81.807, -88.136, -89.058, -83.470, -89.657, -92.045, -90.125, -84.849, -86.479, -81.197)

# look at it
plot(xdata,ydata, las=1)
axis(1, at=0:16, labels=seq(0.5, 8.5, 0.5))

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