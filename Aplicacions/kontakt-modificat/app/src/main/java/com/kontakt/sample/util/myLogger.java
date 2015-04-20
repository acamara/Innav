package com.kontakt.sample.util;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

import com.kontakt.sdk.android.device.BeaconDevice;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class myLogger {

        //Directory
        private static final String DIRECTORY = "/DATASET_BEACONS";

        //Delimiter used in CSV file
        private static final String COMMA_DELIMITER = ";";
        private static final String NEW_LINE_SEPARATOR = "\n";

        //CSV file header
        private static final String FILE_HEADER = "Device Name;Address;Accuracy;Battery Level;Major;Minor;Rssi;TxPower;Firmware Version;Beacon Unique ID;Proximity UUID;Proximity;Beacon Timestamp Discovered; System timestamp";

        private Context context;
        private FileWriter fileWriter = null;
        private File externalMemory;
        private File directory;
        private File file = null;

        private String filename;
        private Map<String, Integer> beacons_samples_counter;
        int num_samples;

        public myLogger(final Context context, int max_num_samples) {
            this.context = context;
            beacons_samples_counter = new HashMap<String,Integer>();
            num_samples = max_num_samples;
        }

        public void create_file(String address){
            beacons_samples_counter.put(address, 0);

            filename = "beacon_" + address + ".csv";

            //Validem si podem accedir a la memòria externa
            if (Environment.getExternalStorageState().equals("mounted")) {

                // Obtenim el directori de la memòria externa
                externalMemory = Environment.getExternalStorageDirectory();

                try {
                    // Instaciem un nou objecte File per crear un nou directori a la memòria externa
                    directory = new File(externalMemory.getAbsolutePath() + DIRECTORY);
                    // Creem el nou directori on es crearà l'arxiu
                    directory.mkdirs();

                    // Creem l'arxiu en el nou directori
                    file = new File(directory, filename);

                    fileWriter = new FileWriter(file, false);
                    fileWriter.append(FILE_HEADER);
                    fileWriter.append(NEW_LINE_SEPARATOR);

                    fileWriter.flush();
                    fileWriter.close();

                    Log.d("Albert - DEBUG", "L'arxiu: " + filename + " s'ha creat correctament");

                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }

        public void write_log(final List<BeaconDevice> beacons){

            try{
                //Write a new beacon object list to the CSV file
                for (BeaconDevice beacon : beacons) {
                    if (beacons_samples_counter.get(beacon.getAddress()) < num_samples) {
                        beacons_samples_counter.put(beacon.getAddress(), beacons_samples_counter.get(beacon.getAddress()) + 1);

                        filename = "beacon_" + beacon.getAddress() + ".csv";
                        // Obrim l'arxiu apropiat
                        file = new File(directory, filename);
                        fileWriter = new FileWriter(file, true);

                        fileWriter.append(beacon.getName());
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(beacon.getAddress());
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(new DecimalFormat("#.##").format(beacon.getAccuracy()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(String.valueOf(beacon.getBatteryPower()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(String.valueOf(beacon.getMajor()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(String.valueOf(beacon.getMinor()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(new DecimalFormat("#.####").format(beacon.getRssi()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(String.valueOf(beacon.getTxPower()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(String.valueOf(beacon.getFirmwareVersion()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(beacon.getUniqueId());
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(beacon.getProximityUUID().toString());
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(beacon.getProximity().toString());
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(convertTime(beacon.getTimestamp()));
                        fileWriter.append(COMMA_DELIMITER);

                        fileWriter.append(getTimeStamp());
                        fileWriter.append(NEW_LINE_SEPARATOR);

                        fileWriter.flush();
                        fileWriter.close();

                        //Log.d("Albert - DEBUG","S'ha escrit el log a: " + filename);
                    }
                }

                Log.d("Albert - DEBUG", beacons_samples_counter.toString());
            } catch (Exception e) {
                e.printStackTrace();
                Log.d("Albert - DEBUG","Error al escriure el log a: " + filename);
            }
        }

        public boolean all_samples_captured(){
            for (Map.Entry<String, Integer> entry : beacons_samples_counter.entrySet()) {
                if(entry.getValue() < num_samples){
                    return false;
                }
            }
            return true;
        }

        private String convertTime(long time){
            Date date = new Date(time);
            Format format = new SimpleDateFormat("dd/MM/yyyy  HH:mm:ss:SSS");
            return format.format(date);
        }

        private String getTimeStamp(){
            Date date = new Date();
            Format format = new SimpleDateFormat("dd/MM/yyyy  HH:mm:ss:SSS");
            return format.format(new Timestamp(date.getTime()));
        }

}
