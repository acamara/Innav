calculate_Position_Centroid <- function(b1x, b1y, b2x, b2y, b3x, b3y){
  # Càlcul de la posició (xu,yu) mitjançant el càlcul del centroide que defineixen tres Beacons 
  sol = c((b1x+b2x+b3x)/3,(b1y+b2y+b3y)/3)
  
  sol
}