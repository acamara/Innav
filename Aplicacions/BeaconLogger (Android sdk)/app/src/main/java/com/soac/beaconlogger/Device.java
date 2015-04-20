package com.soac.beaconlogger;

import android.bluetooth.BluetoothDevice;

/**
 * Created by Albert on 18/03/2015.
 */

public class Device {
    private BluetoothDevice device;
    private int rssi;
    private byte[] scanRecord;

    public Device(BluetoothDevice device, int rssi, byte[] scanRecord) {
        this.device = device;
        this.rssi = rssi;
        this.scanRecord = scanRecord;
    }

    public void setBluetoothDevice(BluetoothDevice device) { this.device = device; }

    public BluetoothDevice getBluetoothDevice() { return device; }

    public void setRSSI(int rssi) { this.rssi = rssi; }

    public int getRSSI() { return rssi; }

    public void setscanRecord( byte[] scanRecord) { this.scanRecord = scanRecord; }

    public byte[] getscanRecord() { return scanRecord; }

    @Override
    public boolean equals(Object object) {

        if (object != null && object instanceof Device) {
            Device device = (Device) object;
            if (this.device == null) {
                return (device.device == null);
            }
            else {
                return this.device.equals(device.device);
            }
        }
        return false;
    }

}