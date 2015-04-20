package com.soac.beaconlogger.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;


import java.io.File;
import java.text.DecimalFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.soac.beaconlogger.R;

public class FileBaseAdapter extends BaseAdapter{

    private ArrayList<File> listofiles;
    private LayoutInflater lInflater;

    public FileBaseAdapter(Context context, ArrayList<File> files) {
        this.lInflater = LayoutInflater.from(context);
        this.listofiles = files;
    }

    public boolean remove(File file){
        return listofiles.remove(file);
    }

    private String convertTime(long time){
        Date date = new Date(time);
        Format format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss:SSS");
        return format.format(date);
    }

    @Override
    public int getCount() { return listofiles.size(); }

    @Override
    public File getItem(int arg0) { return listofiles.get(arg0); }

    @Override
    public long getItemId(int arg0) { return arg0; }

    @Override
    public View getView(int arg0, View arg1, ViewGroup arg2) {
        ContainerView contenedor = null;

        if (arg1 == null){
            arg1 = lInflater.inflate(R.layout.file_list_row, null);

            contenedor = new ContainerView();
            contenedor.name = (TextView) arg1.findViewById(R.id.name);
            contenedor.lastmodified = (TextView) arg1.findViewById(R.id.lastmodified);
            contenedor.size = (TextView) arg1.findViewById(R.id.size);

            arg1.setTag(contenedor);
        } else
            contenedor = (ContainerView) arg1.getTag();

        File file = (File) getItem(arg0);
        contenedor.name.setText(file.getName());
        contenedor.lastmodified.setText(convertTime(file.lastModified()));
        contenedor.size.setText(String.format("%s kB", new DecimalFormat("#.##").format(file.length()/1024.00)));

        return arg1;
    }

    class ContainerView{
        TextView name;
        TextView lastmodified;
        TextView size;
    }
}

