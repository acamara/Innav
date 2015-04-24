calculate_Accuracy_custom <- function(rssi, RSSi_0){
  # Calculate accuracy with custom path loss model
  
  n = 5; xg = 0; d0=1;
  accuracy = d0*(10^((-rssi+RSSi_0-xg)/(10*n)))
  accuracy
}