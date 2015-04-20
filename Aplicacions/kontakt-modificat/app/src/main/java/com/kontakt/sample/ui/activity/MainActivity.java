package com.kontakt.sample.ui.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;

import com.kontakt.sample.R;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class MainActivity extends BaseActivity {

    @InjectView(R.id.toolbar)
    Toolbar toolbar;

    @InjectView(R.id.editText_max_num_samples)
    EditText text_max_num_samples;

    @InjectView(R.id.spinner_address)
    Spinner spinner_address;

    private int max_num_samples = -1;
    private String address = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        ButterKnife.inject(this);

        setUpActionBar(toolbar);
        setUpActionBarTitle(getString(R.string.app_name));

        //Carreguem el spinner
        // Create an ArrayAdapter using the string array and a default spinner layout
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.beacon_address_array, android.R.layout.simple_spinner_item);
        // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // Apply the adapter to the spinner
        spinner_address.setAdapter(adapter);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ButterKnife.reset(this);
    }

    @OnClick(R.id.range_beacons)
    void startRanging() {
        Intent intent = new Intent(new Intent(MainActivity.this, BeaconRangeActivity.class));

        address = spinner_address.getSelectedItem().toString();

        if(!text_max_num_samples.getText().toString().isEmpty()) {
            max_num_samples = Integer.valueOf(text_max_num_samples.getText().toString());
        }

        intent.putExtra("MAX_NUM_SAMPLES", max_num_samples);
        intent.putExtra("ADDRESS", address);
        startActivity(intent);
    }

    @OnClick(R.id.monitor_beacons)
    void startMonitoring() {
        startActivity(new Intent(MainActivity.this, BeaconMonitorActivity.class));
    }

    @OnClick(R.id.background_scan)
    void startForegroundBackgroundScan() {
         startActivity(new Intent(MainActivity.this, BackgroundScanActivity.class));
    }
}
