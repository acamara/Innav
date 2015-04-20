# Resolució de la posició mitjançant Circles Intersecction

# Clean out the workspace and console
rm(list=ls())      
cat("\014")

# Definim les coordenades dels beacons
b1x = 0; b1y = 2.2;
b2x = 3; b2y = 4.4;
b3x =  6; b3y = 0;

# Definim els pseudorangs obtinguts de cada beacon
r1 = 3; r2 = 2.2; r3 = sqrt(3^2+2.2^2);


A <- rbind(c((-2*b1x + 2*b2x), (-2*b1y + 2*b2y)), c((-2*b2x + 2*b3x), (-2*b2y + 2*b3y)))

B <- c((r1^2 - r2^2 - b1x^2 + b2x^2 - b1y^2 + b2y^2), (r2^2 - r3^2 - b2x^2 + b3x^2 - b2y^2 + b3y^2))

sol = solve(A, B)

sol