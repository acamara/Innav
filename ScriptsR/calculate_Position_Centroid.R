calculate_Position_Centroid <- function(b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y){
  # Càlcul de la posició (xu,yu) mitjançant el càlcul del centroide que defineixen quatre punts
  sol = c((b1x+b2x+b3x+b4x)/4,(b1y+b2y+b3y+b4y)/4)
  
  sol
}