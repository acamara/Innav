# Resolució de la posició mitjançant Centroid Positioning

# Clean out the workspace and console
rm(list=ls())      
cat("\014")

# Definim les coordenades dels beacons
b1x = 0; b1y = 2.2;
b2x = 3; b2y = 4.4;
b3x =  6; b3y = 0;

# Càlcul de la posició (xu,yu) mitjançant el càlcul del centroide que defineixen tres Beacons 
sol = c((b1x+b2x+b3x)/3,(b1y+b2y+b3y)/3)

sol