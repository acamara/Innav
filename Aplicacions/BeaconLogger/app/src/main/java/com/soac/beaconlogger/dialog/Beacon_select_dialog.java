package com.soac.beaconlogger.dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;

import com.soac.beaconlogger.R;

import java.util.ArrayList;


public class Beacon_select_dialog extends DialogFragment {

    private ArrayList<Integer> mSelectedItems;
    private String[] availableBeacons;
    private boolean[] selectedBeacons;
    private DialogListener listener;

    public interface DialogListener {
        public void onDialogPositiveClick(DialogFragment dialog);

        public void onDialogNegativeClick(DialogFragment dialog);
    }

    // Override the Fragment.onAttach() method to instantiate the
    // NotifiedDialogListener
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        // Verify that the host activity implements the callback interface
        try {
            // Instantiate the NoticeDialogListener so we can send events to the
            // host
            listener = (DialogListener) activity;
        } catch (ClassCastException e) {
            // The activity doesn't implement the interface, throw exception
            throw new ClassCastException(activity.toString()
                    + " must implement DialogListener");
        }
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        mSelectedItems = new ArrayList();  // Where we track the selected items
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        final SharedPreferences preferences = getActivity().getSharedPreferences("selected_beacons", Context.MODE_PRIVATE);
        availableBeacons = getResources().getStringArray(R.array.beacon_unique_id_array);
        selectedBeacons = getSelectedBeacons(preferences, availableBeacons);

        // Set the dialog title
        builder.setTitle("Select Beacons")
                // Specify the list array, the items to be selected by default (null for none),
                // and the listener through which to receive callbacks when items are selected
                .setMultiChoiceItems(R.array.beacon_unique_id_array, selectedBeacons, new DialogInterface.OnMultiChoiceClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which, boolean isChecked) {
                                selectedBeacons[which] = isChecked;
                                if (isChecked) {
                                    // If the user checked the item, add it to the selected items
                                    mSelectedItems.add(which);
                                } else if (mSelectedItems.contains(which)) {
                                    // Else, if the item is already in the array, remove it
                                    mSelectedItems.remove(Integer.valueOf(which));
                                }
                            }
                        })
                        // Set the action buttons
                .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        // User clicked OK, so save the mSelectedItems results somewhere
                        // or return them to the component that opened the dialog
                        SharedPreferences.Editor prefEditor = preferences.edit();
                        saveSelectedBeacons(prefEditor, availableBeacons, selectedBeacons);
                        listener.onDialogPositiveClick(Beacon_select_dialog.this);
                    }
                })
                .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        listener.onDialogNegativeClick(Beacon_select_dialog.this);
                    }
                });

        return builder.create();
    }

    private boolean[] getSelectedBeacons(SharedPreferences preferences, String[] availableTypes){
        boolean[] selectedTypes = new boolean[availableTypes.length];
        for(int i=0; i <availableTypes.length; i++) {
            selectedTypes[i] = preferences.getBoolean(availableTypes[i],false);
            if(selectedTypes[i]){
                mSelectedItems.add(i);
            }
        }
        return selectedTypes;
    }

    private void saveSelectedBeacons(SharedPreferences.Editor editor, String[] availableTypes, boolean[] selectedBeacons){
        for(int i=0; i < availableTypes.length; i++) {
            editor.putBoolean(availableTypes[i], selectedBeacons[i]);
        }
        editor.commit();
    }

    public ArrayList getSelectedItems(){
        return mSelectedItems;
    }

    public String getSelectedItemsAsString(){
        String sel_beacons = "";
        for(int i=0; i < mSelectedItems.size(); i++){
            sel_beacons += availableBeacons[mSelectedItems.get(i)];
            if(i < mSelectedItems.size()-1){
                sel_beacons += ", ";
            }
        }
        return sel_beacons;
    }
}