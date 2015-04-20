# Resolució de la posició mitjançant Non Linear Least Squares Method

# Clean out the workspace and console
rm(list=ls())      
cat("\014")                      

# Definim les coordenades dels beacons
b1x = 0; b1y = 2.2;
b2x = 3; b2y = 4.4;
b3x = 6; b3y = 0;

# Definim els pseudorangs obtinguts de cada beacon
r1 = 3; r2 = 2.2; r3 = sqrt(3^2+2.2^2);

start_point  <- c(0, 0);

fun <- function(point) (sqrt((point[1]-b1x)^2+(point[2]-b1y)^2)-r1)^2 + (sqrt((point[1]-b2x)^2 + (point[2]-b2y)^2)-r2)^2 + (sqrt((point[1]-b3x)^2 + (point[2]-b3y)^2)-r3)^2;

sol <- optim(start_point, fun);

sol$par;

sol$value;