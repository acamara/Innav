calculate_Accuracy_custom <- function(rssi, txPower){
  # Calculate accuracy with custom path loss model
  
  xg = 0; n = 6; d0=1;
  accuracy = d0*(10^((-rssi+txPower-xg)/(10*n)))
  accuracy
}