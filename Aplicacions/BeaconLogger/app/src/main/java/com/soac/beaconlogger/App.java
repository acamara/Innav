package com.soac.beaconlogger;

import android.app.Application;

import com.kontakt.sdk.android.http.KontaktApiClient;
import com.kontakt.sdk.android.util.Logger;

import butterknife.ButterKnife;

public class App extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        Logger.setDebugLoggingEnabled(BuildConfig.DEBUG);
        KontaktApiClient.init(this);
        ButterKnife.setDebug(BuildConfig.DEBUG);
    }
}
