# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

# Carreguem funcions
source('./ScriptsR/calculate_Position_LSQ.R');
source('./ScriptsR/calculate_Accuracy_custom.R');


# Definim les dimensions de la zona de treball
roomWidth <- 6;
roomHeight <- 4.4;


# Definim el nombre de mostres per metre
samples_meter <- 4
step <- 1/samples_meter


# Definim les coordenades on s'han pres les mostres
x <- seq(0.25, 4, step)
y <- rep(2,length(x))


# Creem un gràfic buit on situarem els Beacons i l'usuari
plot(0, 0, type="n", main="Test environment [room 1]", xlab="x (6.00 m)", ylab="y (4.40 m)", xlim=c(0,ceiling(roomWidth)), ylim=c(0,ceiling(roomHeight)), xaxt="n", yaxt="n")

# Creem el eixos del gràfic
axis(1, at=seq(0, ceiling(roomWidth), step), labels=seq(0, ceiling(roomWidth), step))
axis(2, at=seq(0, ceiling(roomHeight), step),labels=seq(0, ceiling(roomHeight), step), las=1)

# Dibuixem la zona de treball
rect(0,0, roomWidth, roomHeight,border="RED")

# Dibuixem els punts on s'han pres les mostres
points(x, y, pch=16)
text(x, y, labels=c(1:length(x)), cex=0.7, pos=3)
segments(0, 2, roomWidth, 2, lty=2)

# ----------------------------------------------------------------------
# Definim la posició dels beacons
# ----------------------------------------------------------------------

# Beacon 1
b1x = 0.00; b1y = 2.10
# Beacon 2
b2x = 5.60; b2y = 0.40
# Beacon 3
b3x = 3.00; b3y = 4.40

# ----------------------------------------------------------------------
# Dibuixem els Beacons en la zona de treball
# ----------------------------------------------------------------------

# Beacon 1
points(b1x, b1y, pch=7, cex=2, col="BLUE")
# Beacon 2
points(b2x, b2y, pch=7, cex=2, col="BLUE")
# Beacon 3
points(b3x, b3y, pch=7, cex=2, col="BLUE")

text(c(b1x,b2x,b3x), c(b1y,b2y,b3y), labels=c('B1','B2','B3'), cex=0.7, pos=2, col="BLUE")

# ----------------------------------------------------------------------
# Obtenim les dades dels Beacons
# ----------------------------------------------------------------------

# Beacon 1
path <- "./DATASET_BEACONS/measures_from_three_beacons_simultaneously/room1/beacon_D0F8F2953A5C/"
files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

B1_rssi_data = lapply(filelist,"[",,7)
B1_rssi_data = lapply(B1_rssi_data, mean)
B1_accuracy_data = lapply(B1_rssi_data, calculate_Accuracy_custom, -77, 1, 2, 0)

# Beacon 2
path <- "./DATASET_BEACONS/measures_from_three_beacons_simultaneously/room1/beacon_D640866DBDDF/"
files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

B2_rssi_data = lapply(filelist,"[",,7)
B2_rssi_data = lapply(B2_rssi_data, mean)
B2_accuracy_data = lapply(B2_rssi_data, calculate_Accuracy_custom, -77, 1, 2, 0)

# Beacon 3
path <- "./DATASET_BEACONS/measures_from_three_beacons_simultaneously/room1/beacon_D9A3286AA7F1/"
files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

B3_rssi_data = lapply(filelist,"[",,7)
B3_rssi_data = lapply(B3_rssi_data, mean)
B3_accuracy_data = lapply(B3_rssi_data, calculate_Accuracy_custom, -77, 1, 2, 0)

# ----------------------------------------------------------------------
# Calculem la posició de l'usuari
# ----------------------------------------------------------------------

# Definim uns vectors buits on guardar les posicions calculades
x_positions = c(1,length(B1_accuracy_data))
y_positions = c(1,length(B1_accuracy_data))


for(i in 1:length(B1_accuracy_data)){
  sol = calculate_Position_LSQ(b1x, b1y, b2x, b2y, b3x, b3y, B1_accuracy_data[[i]], B2_accuracy_data[[i]], B3_accuracy_data[[i]])
  x_positions[i] = sol[1];
  y_positions[i] = sol[2];
}


# Dibuixem els punts calculats
points(x_positions, y_positions, pch=1, col="RED", cex=1.25)
text(x_positions, y_positions, labels=c(1:length(x_positions)), cex=0.7, pos=3, col="RED")

error_x = x - x_positions
error_y = y - y_positions
error_xy = sqrt( (x - x_positions)^2 + (y - y_positions)^2 )
average_error = mean(error_xy)
error_xy
average_error