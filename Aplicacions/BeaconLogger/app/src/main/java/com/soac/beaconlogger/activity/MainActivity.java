package com.soac.beaconlogger.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.NumberPicker;
import android.widget.Spinner;
import android.widget.Toast;

import com.soac.beaconlogger.R;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class MainActivity extends ActionBarActivity {

    @InjectView(R.id.editText_max_num_samples)
    EditText text_max_num_samples;

    @InjectView(R.id.spinner_address)
    Spinner spinner_address;

    @InjectView(R.id.numberPicker_distance)
    NumberPicker np_distance;

    @InjectView(R.id.checkBox_distanceonFilename)
    CheckBox cb_distasnceonFilename;

    private int max_num_samples = -1;
    private String address = null;
    private Double distance = -1.00;
    private String[] values;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        ButterKnife.inject(this);

        //Carreguem el spinner
        // Create an ArrayAdapter using the string array and a default spinner layout
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.beacon_address_array, android.R.layout.simple_spinner_item);
        // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // Apply the adapter to the spinner
        spinner_address.setAdapter(adapter);

        values = new String[41];
        Double num = -0.25;

        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setDecimalSeparator('.');

        for(int i=0; i<values.length; i++){
            num = num + 0.25;
            values[i]= new DecimalFormat("0.00", symbols).format(num);
        }

        np_distance.setMaxValue(values.length-1);
        np_distance.setMinValue(0);
        np_distance.setDisplayedValues(values);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_mainactivity, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        if (id == R.id.action_directoryexplorer) {
            Intent intent = new Intent(new Intent(MainActivity.this, Directoryexplorer.class));
            startActivity(intent);
            return true;
        }

        return super.onOptionsItemSelected(item);
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

        distance = Double.valueOf(values[np_distance.getValue()]);

        intent.putExtra("MAX_NUM_SAMPLES", max_num_samples);
        intent.putExtra("ADDRESS", address);
        intent.putExtra("DISTANCE", distance);
        intent.putExtra("DISTANCE_ON_FILENAME",  cb_distasnceonFilename.isChecked());
        startActivity(intent);
    }
}
