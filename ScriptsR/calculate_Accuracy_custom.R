calculate_Accuracy_custom <- function(rssi, RSSi_0, n){
  # Calculate accuracy with custom path loss model
  d0=1;
  
  accuracy = d0*(10^((RSSi_0-rssi)/(10*n)))
  accuracy
}