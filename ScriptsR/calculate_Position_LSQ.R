calculate_Position_LSQ <- function(b1x, b1y, b2x, b2y, b3x, b3y, p1, p2, p3){
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
}