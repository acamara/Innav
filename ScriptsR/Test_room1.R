# Clean out the workspace, console and plots
rm(list=ls())      
cat("\014")
graphics.off()

# Carreguem funcions
source('./ScriptsR/calculate_Position_LSQ.R');

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
plot(0, 0, type="n", main="Test environment [room 1]", xlab="x (6.00 m)", ylab="y (4.40 m)", xlim=c(0,ceiling(roomWidth*samples_meter)), ylim=c(0,ceiling(roomHeight*samples_meter)), xaxt="n", yaxt="n")

# Creem el eixos del gràfic
axis(1, at=0:(roomWidth*samples_meter), labels=seq(0, roomWidth, step))
axis(2, at=0:(roomHeight*samples_meter),labels=seq(0, roomHeight, step), las=1)

# Dibuixem la zona de treball
rect(0,0, roomWidth*samples_meter, roomHeight*samples_meter,border="RED")

# Dibuixem els punts on s'han pres les mostres
points(x*samples_meter,y*samples_meter, pch=16)
text(x*samples_meter,y*samples_meter, labels=c(1:length(x)), cex=0.7, pos=3)
segments(0, 2*samples_meter, roomWidth*samples_meter, 2*samples_meter, lty=2)

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
points(b1x*samples_meter, b1y*samples_meter, pch=7, cex=4)
# Beacon 2
points(b2x*samples_meter, b2y*samples_meter, pch=7, cex=4)
# Beacon 3
points(b3x*samples_meter, b3y*samples_meter, pch=7, cex=4)

# ----------------------------------------------------------------------
# Obtenim les seves dades dels Beacons
# ----------------------------------------------------------------------

# Beacon 1
path <- "./DATASET_BEACONS/measures from_three_beacons_simultaneously/room1/beacon_D0F8F2953A5C/"
files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

B1_rssi_data = lapply(filelist,"[",,7)
B1_accuracy_data = lapply(filelist,"[",,3)

# Beacon 2
path <- "./DATASET_BEACONS/measures from_three_beacons_simultaneously/room1/beacon_D640866DBDDF/"
files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

B2_rssi_data = lapply(filelist,"[",,7)
B2_accuracy_data = lapply(filelist,"[",,3)

# Beacon 3
path <- "./DATASET_BEACONS/measures from_three_beacons_simultaneously/room1/beacon_D9A3286AA7F1/"
files <- list.files(path=path,pattern="*.csv")
filelist <- lapply(paste(path,files,sep=""),function(i){read.csv(i, header=TRUE, sep=";")})

B3_rssi_data = lapply(filelist,"[",,7)
B3_accuracy_data = lapply(filelist,"[",,3)

# ----------------------------------------------------------------------
# Calculem la posició de l'usuari sense aplicar rectificacions a les dades obtingudes
# ----------------------------------------------------------------------

# Definim uns vectors buits on guardar les posicions calculades
x_positions = c(1,length(B1_accuracy_data))
y_positions = c(1,length(B1_accuracy_data))

mostra <- 1

for(i in 1:length(B1_accuracy_data)){
  sol = calculate_Position_LSQ(b1x, b1y, b2x, b2y, b3x, b3y, B1_accuracy_data[[i]][mostra], B2_accuracy_data[[i]][mostra], B3_accuracy_data[[i]][mostra])
  x_positions[i] = sol[1];
  y_positions[i] = sol[2];
}


# Dibuixem els punts calculats
points(x_positions*samples_meter,y_positions*samples_meter, pch=1, col="RED", cex=1.25)
text(x_positions*samples_meter,y_positions*samples_meter, labels=c(1:length(x_positions)), cex=0.7, pos=3, col="RED")