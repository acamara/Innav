package com.soac.beaconlogger;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import java.util.ArrayList;

/**
 * Adapter for holding devices found through scanning.
 */

public class DeviceListAdapter extends BaseAdapter {

    private ArrayList<Device> mDevices;
    private LayoutInflater mInflator;
    private Context mContext = null;

    public DeviceListAdapter(Context context) {
        super();
        mContext = context;
        mDevices = new ArrayList<Device>();
        mInflator = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    public void addDevice(Device device) {
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
            view.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) view.getTag();
        }

        BluetoothDevice device = mDevices.get(i).getBluetoothDevice();

        final String deviceName = device.getName();
        final int deviceRSSI = mDevices.get(i).getRSSI();

        if (deviceName != null && deviceName.length() > 0) {
            viewHolder.deviceName.setText(deviceName);
            viewHolder.deviceRSSI.setText("RSSI: " + deviceRSSI + " dB");
        } else {
            viewHolder.deviceName.setText(R.string.unknown_device);
        }

        viewHolder.deviceAddress.setText(device.getAddress());

        return view;
    }

    static class ViewHolder {
        TextView deviceName;
        TextView deviceAddress;
        TextView deviceRSSI;
    }
}
