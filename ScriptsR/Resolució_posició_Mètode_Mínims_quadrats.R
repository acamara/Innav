# Resolució de la posició mitjançant Linear Least Squares Method

# Clean out the workspace and console
rm(list=ls())      
cat("\014")

# Definim les coordenades dels beacons
b1x = 0; b1y = 2.2;
b2x = 3; b2y = 4.4;
b3x =  6; b3y = 0;

# Definim els pseudorangs obtinguts de cada beacon
p1 = 3; p2 = 2.2; p3 = sqrt(3^2+2.2^2);

# Calculem la distància entre beacons
d12 = sqrt((b2x-b1x)^2+(b2y-b1y)^2)
d13 = sqrt((b3x-b1x)^2+(b3y-b1y)^2)


B <- matrix(c(1/2*(p1^2-p2^2+d12^2), 1/2*(p1^2-p3^2+d13^2)),nrow = 2, ncol = 1, byrow=TRUE)

A <- matrix(c(b2x-b1x, b2y-b1y,
              b3x-b1x, b3y-b1y
              ),nrow = 2, ncol = 2, byrow=TRUE)

# Càlcul de la posició (xu,yu) mitjançant el mètode lineal de mínims quadrats
if(det(crossprod(A,A)) != 0){
  sol_lsq = (solve(crossprod(A,A))) %*% (crossprod(A,B))
}

sol = c(sol_lsq[1]+b1x, sol_lsq[2]+b1y)

sol