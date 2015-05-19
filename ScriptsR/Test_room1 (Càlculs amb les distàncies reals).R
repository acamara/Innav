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
plot(0, 0, type="n", main="Test environment - Room 1 (with real distances)", xlab="x (6.00 m)", ylab="y (4.40 m)", xlim=c(0,ceiling(roomWidth)), ylim=c(0,ceiling(roomHeight)), xaxt="n", yaxt="n")

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
points(b1x, b1y, pch=7, cex=4)
# Beacon 2
points(b2x, b2y, pch=7, cex=4)
# Beacon 3
points(b3x, b3y, pch=7, cex=4)

# ----------------------------------------------------------------------
# Obtenim les dades dels Beacons (Assignem les distàncies reals per testejar l'algorisme de trilateració)
# ----------------------------------------------------------------------

# Beacon 1
r1 <- c(0.27, 0.51, 0.76, 1.00, 1.25, 1.50, 1.75, 2.00, 2.25, 2.50, 2.75, 3.00, 3.25, 3.50, 3.75, 4.00)

# Beacon 2
r2 <- c(5.58, 5.35, 5.11, 4.87, 4.63, 4.40, 4.17, 3.94, 3.71, 3.49, 3.27, 3.05, 2.84, 2.64, 2.45, 2.26)

# Beacon 3

r3 <- c(3.65, 3.47, 3.29, 3.12, 2.97, 2.83, 2.71, 2.60, 2.51, 2.45, 2.41, 2.40, 2.41, 2.45, 2.51, 2.60)

# ----------------------------------------------------------------------
# Calculem la posició de l'usuari sense aplicar rectificacions a les dades obtingudes
# ----------------------------------------------------------------------

# Definim uns vectors buits on guardar les posicions calculades
x_positions = c(1,length(r1))
y_positions = c(1,length(r1))

mostra <- 1

for(i in 1:length(r1)){
  sol = calculate_Position_LSQ(b1x, b1y, b2x, b2y, b3x, b3y, r1[[i]], r2[[i]], r3[[i]])
  x_positions[i] = sol[1];
  y_positions[i] = sol[2];
}


# Dibuixem els punts calculats
points(x_positions, y_positions, pch=1, col="RED", cex=1.25)
text(x_positions, y_positions, labels=c(1:length(x_positions)), cex=0.7, pos=1, col="RED")