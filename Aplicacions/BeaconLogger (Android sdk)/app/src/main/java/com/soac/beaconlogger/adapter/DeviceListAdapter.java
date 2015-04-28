package com.soac.beaconlogger.adapter;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.soac.beaconlogger.Device;
import com.soac.beaconlogger.R;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;

/**
 * Adapter for holding devices found through scanning.
 */

public class DeviceListAdapter extends BaseAdapter {

    private ArrayList<Device> mDevices;
    private LayoutInflater mInflator;
    private Context mContext = null;
    private Double rssi = -77.00;
    private Double loss_exponent = 2.00;

    public DeviceListAdapter(Context context) {
        super();
        mContext = context;
        mDevices = new ArrayList<Device>();
        mInflator = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    public void addDevice(Device device, Double rssi, Double loss_exponent) {
        this.rssi = rssi;
        this.loss_exponent = loss_exponent;

        if(!mDevices.contains(device)) {
            mDevices.add(device);
        }
        else{
            int i = mDevices.indexOf(device);
            mDevices.set(i, device);
        }

    }

    public Device getDevice(int position) {
        return mDevices.get(position);
    }

    public void clear() {
        mDevices.clear();
    }

    @Override
    public int getCount() {
        return mDevices.size();
    }

    @Override
    public Object getItem(int i) {
        return mDevices.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {

        ViewHolder viewHolder;
        // General ListView optimization code.

        if (view == null) {
            view = mInflator.inflate(R.layout.listitem_device, null);
            viewHolder = new ViewHolder();
            viewHolder.deviceAddress = (TextView) view.findViewById(R.id.device_address);
            viewHolder.deviceName = (TextView) view.findViewById(R.id.device_name);
            viewHolder.deviceRSSI = (TextView) view.findViewById(R.id.device_rssi);
            viewHolder.distance = (TextView) view.findViewById(R.id.distance);
            view.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) view.getTag();
        }

        BluetoothDevice device = mDevices.get(i).getBluetoothDevice();

        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');

        final String deviceName = device.getName();
        final double deviceRSSI = mDevices.get(i).getRSSI();

        if (deviceName != null && deviceName.length() > 0) {
            viewHolder.deviceName.setText(deviceName);
        } else {
            viewHolder.deviceName.setText(R.string.unknown_device);
        }

        viewHolder.deviceAddress.setText(device.getAddress());
        viewHolder.deviceRSSI.setText("RSSI: " + new DecimalFormat("0.00", symbols).format(deviceRSSI) + " dB");
        double distance = Math.pow(10.00, ((rssi - deviceRSSI) / (10.00 * loss_exponent)));
        viewHolder.distance.setText("Distance: " + new DecimalFormat("0.00", symbols).format(distance) + " m");
        return view;
    }

    static class ViewHolder {
        TextView deviceName;
        TextView deviceAddress;
        TextView deviceRSSI;
        TextView distance;
    }
}
