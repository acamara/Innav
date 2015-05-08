calculate_Accuracy_custom <- function(rssi, RSSi_0, d_0, n, Xg){
  # Calculate accuracy with custom path loss model

  accuracy = d_0*(10^((RSSi_0-rssi+Xg)/(10*n)))
  accuracy
}