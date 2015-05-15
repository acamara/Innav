# Resolució de la posició mitjançant Centroid Positioning
# Clean out the workspace and console
rm(list=ls())      
cat("\014")

# Definim les coordenades dels quatre punts definits per la intersecció de quatre arcs
b1x = 1.66; b1y = 3.13;
b2x = 1.14; b2y = 2.78;
b3x = 2.52; b3y = 1.63;
b4x = 3.30; b4y = 2.08;

# Càlcul de la posició (xu,yu) mitjançant el càlcul del centroide del polígon 
sol = c((b1x+b2x+b3x+b4x)/4,(b1y+b2y+b3y+b4y)/4)
