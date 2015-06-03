calculate_Position_IntersectionsCircles <- function(b1x, b1y, b2x, b2y, b3x, b3y, r1, r2, r3){
 
  A <- rbind(c((-2*b1x + 2*b2x), (-2*b1y + 2*b2y)), c((-2*b2x + 2*b3x), (-2*b2y + 2*b3y)))
  
  B <- c((r1^2 - r2^2 - b1x^2 + b2x^2 - b1y^2 + b2y^2), (r2^2 - r3^2 - b2x^2 + b3x^2 - b2y^2 + b3y^2))
  
  sol = solve(A, B)
  
  sol
}