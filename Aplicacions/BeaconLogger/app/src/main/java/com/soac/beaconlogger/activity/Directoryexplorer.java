package com.soac.beaconlogger.activity;

import android.content.Intent;
import android.os.Environment;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.PopupMenu;
import android.widget.TextView;
import android.widget.Toast;

import com.soac.beaconlogger.R;
import com.soac.beaconlogger.adapter.FileBaseAdapter;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Directoryexplorer extends ActionBarActivity {

    private File[] files;
    private FileBaseAdapter fileList;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.directoryexplorer_activity);
        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);

        File f = new File(Environment.getExternalStorageDirectory() + "/DATASET_BEACONS/");
        files = f.listFiles();

        //Mostramos la ruta en el layout
        TextView ruta = (TextView) findViewById(R.id.textView_root);
        ruta.setText(Environment.getExternalStorageDirectory() + "/DATASET_BEACONS/");

        //Localizamos y llenamos la lista
        ListView lstOpciones = (ListView) findViewById(R.id.listView_files);
        fileList = new FileBaseAdapter(this, new ArrayList<File>(Arrays.asList(files)));

        lstOpciones.setAdapter(fileList);

        // Accion para realizar al pulsar sobre la lista
        lstOpciones.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> a, View v, final int position,   long id) {
                //Creating the instance of PopupMenu
                PopupMenu popup = new PopupMenu(Directoryexplorer.this,v);
                //Inflating the Popup using xml file
                popup.getMenuInflater().inflate(R.menu.menu_popup_directoryexplorer, popup.getMenu());

                //registering popup with OnMenuItemClickListener
                popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    public boolean onMenuItemClick(MenuItem item) {
                        if(item.getTitle().equals("Delete")){
                            File file = files[position];
                            if(file.delete()){
                                fileList.remove(fileList.getItem(position));
                                fileList.notifyDataSetChanged();
                            }
                        }
                        if(item.getTitle().equals("Rename")){
                            File file = files[position];
                            //file.renameTo()
                        }
                        return true;
                    }
                });

                popup.show();//showing popup menu
            }
        });
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_directoryexplorer, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        return super.onOptionsItemSelected(item);
    }
}
