package com.soac.beaconlogger.activity;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.NumberPicker;

import com.soac.beaconlogger.R;
import com.soac.beaconlogger.dialog.BeaconSelectDialog;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class MainActivity extends ActionBarActivity implements BeaconSelectDialog.DialogListener {

    @InjectView(R.id.editText_max_num_samples)
    EditText text_max_num_samples;

    @InjectView(R.id.numberPicker_distance)
    NumberPicker np_distance;

    @InjectView(R.id.checkBox_distanceonFilename)
    CheckBox cb_distasnce_on_Filename;

    @InjectView(R.id.select_beacons)
    Button b_select_beacons;

    private int max_num_samples = -1;
    private Double distance = -1.00;
    private String[] values;
    private ArrayList<Integer> mSelectedItems;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        ButterKnife.inject(this);

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

        mSelectedItems = new ArrayList<Integer>();
        b_select_beacons.setText(getSavedSelectedItemsAsString());
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
            Intent intent = new Intent(new Intent(MainActivity.this, DirectoryexplorerActivity.class));
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

        if(!text_max_num_samples.getText().toString().isEmpty()) {
            max_num_samples = Integer.valueOf(text_max_num_samples.getText().toString());
        }

        distance = Double.valueOf(values[np_distance.getValue()]);

        intent.putExtra("MAX_NUM_SAMPLES", max_num_samples);

        intent.putStringArrayListExtra("SELECTED_ADDRESS", getSelectedAddress());
        intent.putExtra("DISTANCE", distance);
        intent.putExtra("DISTANCE_ON_FILENAME", cb_distasnce_on_Filename.isChecked());
        startActivity(intent);
    }

    @OnClick(R.id.select_beacons)
    void selectBeacons() {
        BeaconSelectDialog selec_dialog = new BeaconSelectDialog();
        selec_dialog.show(getSupportFragmentManager(), "select_dialog");
    }

    private String getSavedSelectedItemsAsString(){
        final SharedPreferences preferences = getSharedPreferences("selected_beacons", Context.MODE_PRIVATE);
        String[] availableTypes = getResources().getStringArray(R.array.beacon_unique_id_array);
        String sel_beacons = "";

        for(int i=0; i <availableTypes.length; i++) {
            if(preferences.getBoolean(availableTypes[i],false)){
                sel_beacons += availableTypes[i]+= ", ";
                mSelectedItems.add(i);
            }
        }

        sel_beacons = sel_beacons.substring(0,sel_beacons.length() - 2);
        Log.d("Albert - DEBUG", "getSavedSelectedItems: "+ sel_beacons + " " + mSelectedItems.toString());
        return sel_beacons;
    }

    private ArrayList<String> getSelectedAddress(){
        String[] beacons_address = getResources().getStringArray(R.array.beacon_address_array);
        ArrayList<String> sel_address = new ArrayList();

        for(int i=0; i <mSelectedItems.size();i++){
            sel_address.add(beacons_address[mSelectedItems.get(i)]);
        }
        return sel_address;
    }

    // The dialog fragment receives a reference to this Activity through the
    // Fragment.onAttach() callback, which it uses to call the following methods
    // defined by the NoticeDialogFragment.NoticeDialogListener interface
    @Override
    public void onDialogPositiveClick(DialogFragment dialog) {
        // User touched the dialog's positive button
        BeaconSelectDialog sdialog = (BeaconSelectDialog) dialog;
        mSelectedItems = sdialog.getSelectedItems();

        b_select_beacons.setText(sdialog.getSelectedItemsAsString());
        //Toast.makeText(getApplicationContext(), mSelectedItems.toString(), Toast.LENGTH_SHORT).show();
        //Toast.makeText(getApplicationContext(), sel_address.toString(), Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onDialogNegativeClick(DialogFragment dialog) {
        // User touched the dialog's negative button
        //Toast.makeText(getApplicationContext(), android.R.string.no, Toast.LENGTH_SHORT).show();
    }
}
