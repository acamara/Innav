package com.soac.beaconlogger.activity;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.content.Intent;
import android.graphics.Color;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Bundle;
import android.os.RemoteException;
import android.support.v4.app.NavUtils;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.soac.beaconlogger.R;
import com.soac.beaconlogger.adapter.BeaconBaseAdapter;
import com.soac.beaconlogger.util.myLogger;

import com.kontakt.sdk.android.configuration.BeaconActivityCheckConfiguration;
import com.kontakt.sdk.android.configuration.ForceScanConfiguration;
import com.kontakt.sdk.android.connection.OnServiceBoundListener;
import com.kontakt.sdk.android.connection.ServiceConnectionChain;
import com.kontakt.sdk.android.device.BeaconDevice;
import com.kontakt.sdk.android.device.Region;
import com.kontakt.sdk.android.factory.Filters;
import com.kontakt.sdk.android.manager.ActionManager;
import com.kontakt.sdk.android.manager.BeaconManager;
import com.kontakt.sdk.android.model.Device;
import com.kontakt.sdk.android.util.MemoryUnit;
import com.kontakt.sdk.core.interfaces.model.IAction;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class BeaconRangeActivity extends ActionBarActivity {

    private static final int REQUEST_CODE_ENABLE_BLUETOOTH = 1;

    private static final int REQUEST_CODE_CONNECT_TO_DEVICE = 2;

    @InjectView(R.id.device_list)
    ListView deviceList;

    @InjectView(R.id.textView_counter)
    TextView textView_counter;

    @InjectView(R.id.textView_num_samples)
    TextView textView_num_samples;

    private myLogger logger;
    private SoundPool soundPool;
    private int idalertsound;
    private int max_num_samples = 0;
    private String address;
    private Double distance;
    private Boolean distanceonfilename;
    private Boolean alert = true;

    private BeaconBaseAdapter adapter;
    private BeaconManager beaconManager;
    private ActionManager actionManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.beacon_range_activity);
        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
        actionBar.setDisplayShowHomeEnabled(true);
        ButterKnife.inject(this);
        adapter = new BeaconBaseAdapter(this);

        Bundle bundle = getIntent().getExtras();
        max_num_samples = bundle.getInt("MAX_NUM_SAMPLES",-1);
        address = bundle.getString("ADDRESS", null);
        distance = bundle.getDouble("DISTANCE", -1.0);
        distanceonfilename = bundle.getBoolean("DISTANCE_ON_FILENAME", false);
        Log.d("Albert - DEBUG", "Nombre de mostres pasades: " + String.valueOf(max_num_samples));
        Log.d("Albert - DEBUG", "Address: " + address);
        Log.d("Albert - DEBUG", "Distance: " + distance);
        Log.d("Albert - DEBUG", "Distance on filename: " + distanceonfilename);
        logger = new myLogger(this, max_num_samples, distance, distanceonfilename);
        soundPool = new SoundPool( 5, AudioManager.STREAM_MUSIC , 0);
        idalertsound = soundPool.load(this, R.raw.sonido_alerta, 0);
        textView_num_samples.setText(String.valueOf(max_num_samples));

        actionManager = ActionManager.newInstance(this);
        actionManager.setMemoryCacheSize(20, MemoryUnit.BYTES);
        actionManager.registerActionNotifier(new ActionManager.ActionNotifier() {
            @Override
            public void onActionsFound(final List<IAction<Device>> actions) {
                final IAction<Device> action = actions.get(0);
                final Device beacon = action.getDevice();
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        final String info = String.format("%d Actions found for beacon:\nID: %s\nMajor: %d\nMinor: %d\nProximity UUID: %s\nProximity: %s",
                                actions.size(),
                                beacon.getId().toString(),
                                beacon.getMajor(),
                                beacon.getMinor(),
                                beacon.getProximityUUID().toString(),
                                action.getProximity().name());
                        Toast.makeText(BeaconRangeActivity.this, info, Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });

        beaconManager = BeaconManager.newInstance(this);

        beaconManager.setScanMode(BeaconManager.SCAN_MODE_LOW_LATENCY); // Works only for Android L OS version


        //beaconManager.setRssiCalculator(RssiCalculators.newLimitedMeanRssiCalculator(5)); //Calculate rssi value basing on arithmethic mean of 5 last notified values
/*
        beaconManager.setRssiCalculator(new RssiCalculators.CustomRssiCalculator() { //Provide your own Rssi Calculator to estimate manipulate Rssi value
            @Override                                                                  //and thus Proximity from Beacon device
            public double calculateRssi(int beaconHashCode, int rssiValue) {
                return rssiValue;
            }

            @Override
            public void clear() {

            }
        });
*/


        if(address != null && !address.equals("All") && max_num_samples != -1) {
            Log.d("Albert - DEBUG", "Filtrant per adreça un beacon");
            logger.create_file(address);
            beaconManager.addFilter(Filters.newAddressFilter(address));                     //accept Beacons with specified adress only
        }

        if(address.equals("All") && max_num_samples != -1) {
            Log.d("Albert - DEBUG", "No Filtrant per adreça, analitzant tots els Beacons");
            List<String> myResArrayList = Arrays.asList(getResources().getStringArray(R.array.beacon_address_array));
            List<String> beacons_address_list = new ArrayList<String>(myResArrayList);
            beacons_address_list.remove(0);

            for(int i= 0; i < beacons_address_list.size();i++) {
                logger.create_file(beacons_address_list.get(i));
            }
        }




        //beaconManager.addFilter(Filters.newProximityUUIDFilter(BeaconManager.DEFAULT_KONTAKT_BEACON_PROXIMITY_UUID)); //accept Beacons with default Proximity UUID only
        //(f7826da6-4fa2-4e98-8024-bc5b71e0893e)
/*
        beaconManager.addFilter(Filters.newAddressFilter("00:00:00:00:00:00")); //accept Beacons with specified MAC address only
        beaconManager.addFilter(Filters.newBeaconUniqueIdFilter("myID"));         //accept Beacons with specified Unique Id only
        beaconManager.addFilter(Filters.newDeviceNameFilter("my_beacon_name"));   //accept Beacons with specified name only
        beaconManager.addFilter(Filters.newFirmwareFilter(26));                   //accept Beacons with specified Firmware version only
        beaconManager.addFilter(Filters.newMajorFilter(666));                     //accept Beacons with specified Major only
        beaconManager.addFilter(Filters.newMinorFilter(333));                     //accept Beacons with specified Minor only
        beaconManager.addFilter(Filters.newMultiFilterBuilder()                   //accept Beacon matching constraints specified in MultiFilter
                                        .setBeaconUniqueId("Boom")
                                        .setDeviceName("device_name")
                                        .setAddress("00:00:00:00:00:00")
                                        .setFirmware(26)
                                        .setProximityUUID(UUID.randomUUID())
                                        .build());

        beaconManager.addFilter(new Filters.CustomFilter() {                      //create your customized filter
            @Override
            public boolean filter(AdvertisingPackage advertisingPackage) {
                return advertisingPackage.getAccuracy() < 5;                     //accept beacons from distance 5m at most
            }
        });
        */

        beaconManager.setBeaconActivityCheckConfiguration(BeaconActivityCheckConfiguration.DEFAULT);

        beaconManager.setForceScanConfiguration(ForceScanConfiguration.DEFAULT);

        beaconManager.registerRangingListener(new BeaconManager.RangingListener() {
            @Override
            public void onBeaconsDiscovered(final Region region, final List<BeaconDevice> beacons) {
                BeaconRangeActivity.this.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        adapter.replaceWith(beacons);

                        /* Enviar dades al log*/
                        if(!logger.all_samples_captured()) {
                            logger.write_log(beacons);
                            textView_counter.setTextColor(Color.RED);
                            textView_counter.setText("Capturing data " + logger.get_number_samples_captured() + "...");
                        }
                        if(logger.all_samples_captured() && alert && max_num_samples !=-1){
                            soundPool.play(idalertsound, 1, 1, 1, 0, 1);
                            textView_counter.setTextColor(Color.BLUE);
                            textView_counter.setText("Data captured");
                            alert = false;
                        }
                    }
                });
            }
        });

        deviceList.setAdapter(adapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_beaconrangeactivity, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        if (id == R.id.action_directoryexplorer) {
            Intent intent = new Intent(new Intent(BeaconRangeActivity.this, Directoryexplorer.class));
            startActivity(intent);
            return true;
        }

        if (id == R.id.home) {
            NavUtils.navigateUpFromSameTask(this);
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onResume() {
        super.onResume();

        if(! beaconManager.isBluetoothEnabled()){
            final Intent intent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(intent, REQUEST_CODE_ENABLE_BLUETOOTH);
        } else if(beaconManager.isConnected()) {
            startRanging();
        } else {
            connect();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if(beaconManager.isConnected()) {
            beaconManager.stopRanging();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ServiceConnectionChain.start()
                .disconnect(actionManager)
                .disconnect(beaconManager)
                .performQuietly();
        actionManager = null;
        beaconManager = null;
        ButterKnife.reset(this);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if(requestCode == REQUEST_CODE_ENABLE_BLUETOOTH) {
            if(resultCode == Activity.RESULT_OK) {
                connect();
            } else {
                final String bluetoothNotEnabledInfo = getString(R.string.bluetooth_not_enabled);
                Toast.makeText(BeaconRangeActivity.this, bluetoothNotEnabledInfo, Toast.LENGTH_LONG).show();
            }
            return;
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void startRanging() {
        try {
            beaconManager.startRanging();
        } catch (RemoteException e) {
            Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }

    private void connect() {
        try {
            ServiceConnectionChain.start()
                    .connect(actionManager, new OnServiceBoundListener() {
                        @Override
                        public void onServiceBound() {
                            beaconManager.setActionController(actionManager.getActionController());
                        }
                    })
                    .connect(beaconManager, new OnServiceBoundListener() {
                        @Override
                        public void onServiceBound() {
                            try {
                                beaconManager.startRanging(); //Starts ranging everywhere

                                /*final Set<Region> regionSet = new HashSet<Region>();
                                regionSet.add(new Region(UUID.randomUUID(), 333, 333, "My region"));
                                beaconManager.startRanging(regionSet);

                                You can range Beacons by specifying Region Set as it was
                                in previous versions of kontakt.io's Android SDK
                                */
                            } catch (RemoteException e) {
                                Toast.makeText(BeaconRangeActivity.this, e.getMessage(), Toast.LENGTH_LONG).show();
                            }
                        }
                    })
                    .perform();
        } catch (RemoteException e) {
            Toast.makeText(BeaconRangeActivity.this, e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }
}
