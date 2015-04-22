calculate_Accuracy_kontakt <- function(rssi, txPower){
  # Calculate accuracy with Kontakt model
  
  if (rssi == 0){
    accuracy = -1.0; # if we cannot determine accuracy, return -1.
  }
  ratio = rssi*1.0/txPower;
  
  if (ratio < 1.0){
    accuracy = ratio^10;
  }
  
  else{
    accuracy =  (0.89976)*(ratio^7.7095) + 0.111;
  }
  accuracy
}