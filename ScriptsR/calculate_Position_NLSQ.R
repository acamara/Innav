calculate_Position_NLSQ <- function(b1x, b1y, b2x, b2y, b3x, b3y, r1, r2, r3){
  start_point  <- c(0, 0);
  
  fun <- function(point) (sqrt((point[1]-b1x)^2+(point[2]-b1y)^2)-r1)^2 + (sqrt((point[1]-b2x)^2 + (point[2]-b2y)^2)-r2)^2 + (sqrt((point[1]-b3x)^2 + (point[2]-b3y)^2)-r3)^2;
  
  sol <- optim(start_point, fun);
  
  sol$par;
}