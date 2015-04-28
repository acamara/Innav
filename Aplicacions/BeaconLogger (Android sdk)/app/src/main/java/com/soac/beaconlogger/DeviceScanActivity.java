package com.soac.beaconlogger;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.NavUtils;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.soac.beaconlogger.adapter.DeviceListAdapter;
import com.soac.beaconlogger.util.myLogger;

import java.util.ArrayList;

/**
 * Activity for scanning and displaying available Bluetooth Low Energy devices.
 */

public class DeviceScanActivity extends ActionBarActivity {

    private DeviceListAdapter mBleDeviceListAdapter;
    private BluetoothAdapter mBluetoothAdapter;
    private ListView list_beacons;
    private boolean mScanning;
    private Handler mHandler;
    private static final int REQUEST_ENABLE_BT = 1;

    // Stops scanning after 60 seconds.
    private static final long SCAN_PERIOD = 7200000;

    private myLogger logger;
    private SoundPool soundPool;
    private int id_alert_sound;
    private int max_num_samples = 0;
    private double rssi_0;
    private double loss_exponent;
    private ArrayList<String> sel_address;
    private Double distance;
    private Boolean distance_on_filename;
    private Boolean alert = true;

    private TextView textView_num_samples;
    private TextView textView_counter;
    private TextView text_rssi;
    private TextView text_loss_exponent;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_scan);
        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);

        mHandler = new Handler();

        // Use this check to determine whether BLE is supported on the device.  Then you can
        // selectively disable BLE-related features.
        if (!getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            Toast.makeText(this, R.string.ble_not_supported, Toast.LENGTH_SHORT).show();
            finish();
        }

        // Initializes a Bluetooth adapter.  For API level 18 and above, get a reference to
        // BluetoothAdapter through BluetoothManager.
        final BluetoothManager bluetoothManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();

        // Checks if Bluetooth is supported on the device.
        if (mBluetoothAdapter == null) {
            Toast.makeText(this, R.string.error_bluetooth_not_supported, Toast.LENGTH_SHORT).show();
            finish();
            return;
        }

        textView_num_samples = (TextView) findViewById(R.id.textView_num_samples);
        textView_counter = (TextView) findViewById(R.id.textView_counter);
        text_rssi = (TextView) findViewById(R.id.textView_rssi);
        text_loss_exponent = (TextView) findViewById(R.id.textView_loss_exponent);

        Bundle bundle = getIntent().getExtras();
        max_num_samples = bundle.getInt("MAX_NUM_SAMPLES",-1);
        rssi_0 = bundle.getDouble("RSSI", -77.00);
        loss_exponent = bundle.getDouble("LOSS_EXPONENT", 2.00);
        sel_address = bundle.getStringArrayList("SELECTED_ADDRESS");
        distance = bundle.getDouble("DISTANCE", -1.0);
        distance_on_filename = bundle.getBoolean("DISTANCE_ON_FILENAME", false);
        Log.d("Albert - DEBUG", "Nombre de mostres pasades: " + String.valueOf(max_num_samples));
        Log.d("Albert - DEBUG", "Distance: " + distance);
        Log.d("Albert - DEBUG", "Distance on filename: " + distance_on_filename);
        logger = new myLogger(this, max_num_samples, distance, rssi_0, loss_exponent ,distance_on_filename);
        soundPool = new SoundPool( 5, AudioManager.STREAM_MUSIC , 0);
        id_alert_sound = soundPool.load(this, R.raw.sonido_alerta, 0);


        textView_num_samples.setText(String.valueOf(max_num_samples));
        text_rssi.setText(String.valueOf(rssi_0));
        text_loss_exponent.setText(String.valueOf(loss_exponent));

        if(sel_address != null && max_num_samples != -1) {
            Log.d("Albert - DEBUG", "Selected Address: " + sel_address.toString());

            for(int i= 0; i < sel_address.size();i++) {
                logger.create_file(sel_address.get(i));
            }
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_device_scan, menu);
        if (!mScanning) {
            menu.findItem(R.id.menu_stop).setVisible(false);
            menu.findItem(R.id.menu_scan).setVisible(true);
        } else {
            menu.findItem(R.id.menu_stop).setVisible(true);
            menu.findItem(R.id.menu_scan).setVisible(false);
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_scan:
                mBleDeviceListAdapter.clear();
                scanLeDevice(true);
                break;
            case R.id.menu_stop:
                scanLeDevice(false);
                break;
            case R.id.menu_directoryexplorer:
                Intent intent = new Intent(new Intent(this, DirectoryexplorerActivity.class));
                startActivity(intent);
                break;
            case android.R.id.home:
                NavUtils.navigateUpFromSameTask(this);
                break;
        }
        return true;
    }

    @Override
    protected void onResume() {
        super.onResume();

        // Ensures Bluetooth is enabled on the device.  If Bluetooth is not currently enabled,
        // fire an intent to display a dialog asking the user to grant permission to enable it.
        if (!mBluetoothAdapter.isEnabled()) {
            if (!mBluetoothAdapter.isEnabled()) {
                Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
            }
        }
        // Initializes list view adapter.
        mBleDeviceListAdapter = new DeviceListAdapter(this);
        list_beacons = (ListView)findViewById(R.id.list);
        list_beacons.setAdapter(mBleDeviceListAdapter);

        scanLeDevice(true);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // User chose not to enable Bluetooth.
        if (requestCode == REQUEST_ENABLE_BT && resultCode == Activity.RESULT_CANCELED) {
            finish();
            return;
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onPause() {
        super.onPause();
        scanLeDevice(false);
        mBleDeviceListAdapter.clear();
    }

    /*
    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        final BluetoothDevice device = mBleDeviceListAdapter.getDevice(position);
        if (device == null) return;
        //final Intent intent = new Intent(this, DeviceControlActivity.class);
        //intent.putExtra(DeviceControlActivity.EXTRAS_DEVICE_NAME, device.getName());
        //intent.putExtra(DeviceControlActivity.EXTRAS_DEVICE_ADDRESS, device.getAddress());
        if (mScanning) {
            mBluetoothAdapter.stopLeScan(mLeScanCallback);
            mScanning = false;
        }
        //startActivity(intent);
    }
    */

    private void scanLeDevice(final boolean enable) {
        if (enable) {
            // Stops scanning after a pre-defined scan period.
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    mScanning = false;
                    mBluetoothAdapter.stopLeScan(mLeScanCallback);
                    invalidateOptionsMenu();
                }
            }, SCAN_PERIOD);
            mScanning = true;
            mBluetoothAdapter.startLeScan(mLeScanCallback);
        } else {
            mScanning = false;
            mBluetoothAdapter.stopLeScan(mLeScanCallback);
        }
        invalidateOptionsMenu();
    }

    // Device scan callback.
    private BluetoothAdapter.LeScanCallback mLeScanCallback =
            new BluetoothAdapter.LeScanCallback() {
                @Override
                public void onLeScan(final BluetoothDevice device, final int rssi, final byte[] scanRecord) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            mBleDeviceListAdapter.addDevice(new Device(device, rssi, scanRecord), rssi_0, loss_exponent);
                            mBleDeviceListAdapter.notifyDataSetChanged();
                            /* Enviar dades al log*/
                            if(!logger.all_samples_captured()) {
                                logger.write_log(new Device(device, rssi, scanRecord));
                                textView_counter.setTextColor(Color.RED);
                                textView_counter.setText("Capturing data " + logger.get_number_samples_captured() + "...");
                            }
                            if(logger.all_samples_captured() && alert && max_num_samples !=-1){
                                soundPool.play(id_alert_sound, 1, 1, 1, 0, 1);
                                textView_counter.setTextColor(Color.BLUE);
                                textView_counter.setText("Data captured");
                                alert = false;
                            }
                        }
                    });
                }
            };

}