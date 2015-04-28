package com.soac.beaconlogger.util;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.os.Environment;
import android.util.Log;

import com.soac.beaconlogger.Device;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class myLogger {

    //Directory
    private static final String DIRECTORY = "/DATASET_BEACONS_WITH_ANDROID_SDK";

    //Delimiter used in CSV file
    private static final String COMMA_DELIMITER = ";";
    private static final String NEW_LINE_SEPARATOR = "\n";

    //CSV file header
    private static final String FILE_HEADER =   "Device Name;Address;Distance;RSSI;TX Power;System timestamp;Distance of measurement";

    private Context context;
    private File externalMemory;
    private File directory;
    private FileWriter fileWriter;

    private Map<String, Integer> beacons_samples_counter;
    private Map<String, String>  beacons_filenames;
    private int num_samples;
    private Double rssi = -77.00;
    private Double loss_exponent = 2.00;
    private String distance;
    private Boolean distanceonfilename;
    private DecimalFormatSymbols symbols;

    public myLogger(final Context context, int max_num_samples, Double distance, Double rssi, Double loss_exponent, Boolean distanceonfilename) {
        this.context = context;
        this.num_samples = max_num_samples;
        this.rssi = rssi;
        this.loss_exponent = loss_exponent;
        symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');
        this.distance = new DecimalFormat("0.00",symbols).format(distance);
        this.distanceonfilename = distanceonfilename;
        beacons_samples_counter = new HashMap<String,Integer>();
        beacons_filenames = new HashMap<String,String>();

        create_directory();
    }

    public void create_file(String beacon_identifier){

        String filename = "beacon_" + beacon_identifier + "_" + getFileTimeStamp() + ".csv";

        if(distanceonfilename){
            filename = "beacon_" + beacon_identifier + "_d_" + distance + "_"+ getFileTimeStamp()+ ".csv";
        }

        beacons_samples_counter.put(beacon_identifier, 0);
        beacons_filenames.put(beacon_identifier, filename);

        try{
            // Creem l'arxiu en el nou directori
            File file = new File(directory, filename);

            if(!file.exists()) {
                fileWriter = new FileWriter(file, false);
                fileWriter.append(FILE_HEADER);
                fileWriter.append(NEW_LINE_SEPARATOR);

                fileWriter.flush();
                fileWriter.close();

                //Toast.makeText(context, "L'arxiu: " + filename + " s'ha creat correctament", Toast.LENGTH_SHORT).show();
                Log.d("Albert - DEBUG", "L'arxiu: " + filename + " s'ha creat correctament");
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void write_log(Device  device){
        String filename = null;
        BluetoothDevice bdevice = device.getBluetoothDevice();

        try{
            //Write a new beacon object list to the CSV file
                String address = bdevice.getAddress();
                if (beacons_filenames.containsKey(address) && beacons_samples_counter.get(address) < num_samples) {
                    beacons_samples_counter.put(bdevice.getAddress(), beacons_samples_counter.get(address) + 1);
                    filename = beacons_filenames.get(address);

                    // Obrim l'arxiu apropiat
                    File file = new File(directory, filename);
                    fileWriter = new FileWriter(file, true);

                    fileWriter.append(bdevice.getName().toString());
                    fileWriter.append(COMMA_DELIMITER);

                    fileWriter.append(bdevice.getAddress().toString());
                    fileWriter.append(COMMA_DELIMITER);

                    double distance_estimate = Math.pow(10.00, ((rssi - device.getRSSI()) / (10.00 * loss_exponent)));

                    fileWriter.append(String.format("%s", new DecimalFormat("0.00", symbols).format(distance_estimate)));
                    fileWriter.append(COMMA_DELIMITER);

                    fileWriter.append(String.format("%s", new DecimalFormat("#.00", symbols).format(device.getRSSI())));
                    fileWriter.append(COMMA_DELIMITER);

                    fileWriter.append(String.format("%s", new DecimalFormat("#.00", symbols).format(-77)));
                    fileWriter.append(COMMA_DELIMITER);

                    fileWriter.append(getTimeStamp());
                    fileWriter.append(COMMA_DELIMITER);

                    fileWriter.append(distance);
                    fileWriter.append(NEW_LINE_SEPARATOR);


                    fileWriter.flush();
                    fileWriter.close();

                    //Log.d("Albert - DEBUG","S'ha escrit el log a: " + filename);
                }
            //Log.d("Albert - DEBUG", beacons_samples_counter.toString());
        } catch (Exception e) {
            e.printStackTrace();
            Log.d("Albert - DEBUG","Error al escriure el log a: " + filename);
            Log.d("Albert - DEBUG","Error: " + e);
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

    public String get_number_samples_captured(){
        int num = num_samples * beacons_samples_counter.size();
        int captured = 0;
        for (Map.Entry<String, Integer> entry : beacons_samples_counter.entrySet()) {
            captured = captured + entry.getValue();
        }
        return String.format("(%s of %s)",captured, num);
    }

    private void create_directory() {
        Log.d("Albert - DEBUG", "Es crida a crear directori");
        //Validem si podem accedir a la memòria externa
        if (Environment.getExternalStorageState().equals("mounted")) {

            // Obtenim el directori de la memòria externa
            externalMemory = Environment.getExternalStorageDirectory();

           // Instaciem un nou objecte File per crear un nou directori a la memòria externa
           directory = new File(externalMemory.getAbsolutePath() + DIRECTORY);
           if (!directory.isDirectory()) {
            // Creem el nou directori on es crearà l'arxiu
            directory.mkdirs();
               Log.d("Albert - DEBUG", "Es crea el directori");

           }
        }
    }

    private String convertTime(long time){
        Date date = new Date(time);
        Format format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss:SSS");
        return format.format(date);
    }

    private String getTimeStamp(){
        Date date = new Date();
        Format format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss:SSS");
        return format.format(new Timestamp(date.getTime()));
    }

    private String getFileTimeStamp(){
        Date date = new Date();
        Format format = new SimpleDateFormat("dd-MM-yyyy_HH:mm:ss:SSS");
        return format.format(new Timestamp(date.getTime()));
    }

}
