package com.mediatek.location;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.ContentObserver;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.os.UserHandle;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;
import com.mediatek.cta.CtaManager;
import com.mediatek.cta.CtaManagerFactory;
import com.mediatek.internal.R;
import java.util.Calendar;

public class MtkLocationExt {
    private static final boolean DEBUG = true;
    private static final String TAG = "MtkLocationExt";

    public static class GnssLocationProvider {
        private static final int EVENT_GPS_TIME_SYNC_CHANGED = 4;
        private static final int EVENT_SEND_BLUESKY_BROADCAST = 5;
        /* access modifiers changed from: private */
        public final Context mContext;
        /* access modifiers changed from: private */
        public Handler mGpsHandler;
        private GpsTimeSyncObserver mGpsTimeSyncObserver;
        /* access modifiers changed from: private */
        public Thread mGpsTimerThread;
        /* access modifiers changed from: private */
        public Handler mGpsToastHandler = new Handler() {
            public void handleMessage(Message message) {
                Toast.makeText(GnssLocationProvider.this.mContext, (String) message.obj, 1).show();
            }
        };
        private final Handler mHandler;
        /* access modifiers changed from: private */
        public boolean mIsGpsTimeSyncRunning = false;
        private Location mLastLocation;
        /* access modifiers changed from: private */
        public LocationListener mLocationListener = new LocationListener() {
            public void onProviderDisabled(String str) {
            }

            public void onProviderEnabled(String str) {
            }

            public void onStatusChanged(String str, int i, Bundle bundle) {
            }

            public void onLocationChanged(Location location) {
                GnssLocationProvider.this.mGpsTimerThread.interrupt();
            }
        };
        /* access modifiers changed from: private */
        public LocationManager mLocationManager;
        private LocationListener mPassiveLocationListener = new LocationListener() {
            public void onProviderDisabled(String str) {
            }

            public void onProviderEnabled(String str) {
            }

            public void onStatusChanged(String str, int i, Bundle bundle) {
            }

            public void onLocationChanged(Location location) {
                if ("gps".equals(location.getProvider())) {
                    GnssLocationProvider.this.doSystemTimeSyncByGps((location.getLatitude() == 0.0d || location.getLongitude() == 0.0d) ? false : true, location.getTime());
                }
            }
        };

        public GnssLocationProvider(Context context, Handler handler) {
            Log.d(MtkLocationExt.TAG, "MtkLocationExt GnssLocationProvider()");
            this.mContext = context;
            this.mHandler = handler;
            registerIntentReceiver();
            Log.d(MtkLocationExt.TAG, "add GPS time sync handler and looper");
            this.mGpsHandler = new MyHandler(handler.getLooper());
            this.mLocationManager = (LocationManager) context.getSystemService("location");
            GpsTimeSyncObserver gpsTimeSyncObserver = new GpsTimeSyncObserver(this.mGpsHandler, 4);
            this.mGpsTimeSyncObserver = gpsTimeSyncObserver;
            gpsTimeSyncObserver.observe(context);
        }

        private void registerIntentReceiver() {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction("android.intent.action.BOOT_COMPLETED");
            this.mContext.registerReceiverAsUser(new BroadcastReceiver() {
                public void onReceive(Context context, Intent intent) {
                    if ("android.intent.action.BOOT_COMPLETED".equals(intent.getAction())) {
                        boolean r2 = GnssLocationProvider.this.getGpsTimeSyncState();
                        Log.d(MtkLocationExt.TAG, "BOOT_COMPLETED, GPS Time sync is set to " + r2);
                        GnssLocationProvider.this.setGpsTimeSyncFlag(r2);
                        GnssLocationProvider.this.mGpsHandler.obtainMessage(5).sendToTarget();
                    }
                }
            }, UserHandle.ALL, intentFilter, (String) null, this.mHandler);
        }

        private class MyHandler extends Handler {
            public MyHandler(Looper looper) {
                super(looper);
            }

            public void handleMessage(Message message) {
                int i = message.what;
                if (i == 4) {
                    boolean r4 = GnssLocationProvider.this.getGpsTimeSyncState();
                    Log.d(MtkLocationExt.TAG, "GPS Time sync is changed to " + r4);
                    GnssLocationProvider.this.onGpsTimeChanged(r4);
                } else if (i == 5) {
                    BlueskyUtility.sendBlueskyBroadcast(GnssLocationProvider.this.mContext);
                    Log.d(MtkLocationExt.TAG, "Finish Bluesky broadcast");
                }
            }
        }

        /* access modifiers changed from: private */
        public boolean getGpsTimeSyncState() {
            try {
                return Settings.Global.getInt(this.mContext.getContentResolver(), "auto_time_gps") > 0;
            } catch (Settings.SettingNotFoundException unused) {
                return false;
            }
        }

        private static class GpsTimeSyncObserver extends ContentObserver {
            private Handler mHandler;
            private int mMsg;

            GpsTimeSyncObserver(Handler handler, int i) {
                super(handler);
                this.mHandler = handler;
                this.mMsg = i;
            }

            /* access modifiers changed from: package-private */
            public void observe(Context context) {
                context.getContentResolver().registerContentObserver(Settings.Global.getUriFor("auto_time_gps"), false, this);
            }

            public void onChange(boolean z) {
                this.mHandler.obtainMessage(this.mMsg).sendToTarget();
            }
        }

        public void onGpsTimeChanged(boolean z) {
            if (z) {
                startUsingGpsWithTimeout(180000, this.mContext.getString(R.string.gps_time_sync_fail_str));
            } else {
                Thread thread = this.mGpsTimerThread;
                if (thread != null) {
                    thread.interrupt();
                }
            }
            setGpsTimeSyncFlag(z);
        }

        /* access modifiers changed from: private */
        public void setGpsTimeSyncFlag(boolean z) {
            Log.d(MtkLocationExt.TAG, "setGpsTimeSyncFlag: " + z);
            if (z) {
                this.mLocationManager.requestLocationUpdates("passive", 0, 0.0f, this.mPassiveLocationListener);
            } else {
                this.mLocationManager.removeUpdates(this.mPassiveLocationListener);
            }
        }

        /* access modifiers changed from: private */
        public void doSystemTimeSyncByGps(boolean z, long j) {
            if (z) {
                Log.d(MtkLocationExt.TAG, " ########## Auto-sync time with GPS: timestamp = " + j + " ########## ");
                Calendar instance = Calendar.getInstance();
                instance.setTimeInMillis(j);
                long timeInMillis = instance.getTimeInMillis();
                if (timeInMillis / 1000 < 2147483647L) {
                    SystemClock.setCurrentTimeMillis(timeInMillis);
                }
                this.mLocationManager.removeUpdates(this.mPassiveLocationListener);
            }
        }

        public void startUsingGpsWithTimeout(final int i, final String str) {
            if (this.mIsGpsTimeSyncRunning) {
                Log.d(MtkLocationExt.TAG, "WARNING: Gps Time Sync is already run");
                return;
            }
            this.mIsGpsTimeSyncRunning = true;
            Log.d(MtkLocationExt.TAG, "start using GPS for GPS time sync timeout=" + i + " timeoutMsg=" + str);
            this.mLocationManager.requestLocationUpdates("gps", 1000, 0.0f, this.mLocationListener);
            AnonymousClass3 r0 = new Thread() {
                public void run() {
                    boolean z;
                    try {
                        Thread.sleep((long) i);
                        z = true;
                    } catch (InterruptedException unused) {
                        z = false;
                    }
                    Log.d(MtkLocationExt.TAG, "isTimeout=" + z);
                    if (z) {
                        Message message = new Message();
                        message.obj = str;
                        GnssLocationProvider.this.mGpsToastHandler.sendMessage(message);
                    }
                    GnssLocationProvider.this.mLocationManager.removeUpdates(GnssLocationProvider.this.mLocationListener);
                    GnssLocationProvider.this.mIsGpsTimeSyncRunning = false;
                }
            };
            this.mGpsTimerThread = r0;
            r0.start();
        }
    }

    public static class LocationManagerService {
        private final Context mContext;
        private CtaManager mCtaManager = CtaManagerFactory.getInstance().makeCtaManager();
        private final Handler mHandler;
        private LocationManager mLocationManager;

        public LocationManagerService(Context context, Handler handler) {
            Log.d(MtkLocationExt.TAG, "MtkLocationExt LocationManagerService()");
            this.mContext = context;
            this.mHandler = handler;
            this.mLocationManager = (LocationManager) context.getSystemService("location");
        }

        public boolean isCtaFeatureSupport() {
            return this.mCtaManager.isCtaSupported();
        }

        public void printCtaLog(int i, int i2, String str, String str2, String str3) {
            CtaManager.ActionType actionType = CtaManager.ActionType.USE_LOCATION;
            if ("USE_LOCATION".equals(str2)) {
                actionType = CtaManager.ActionType.USE_LOCATION;
            } else if ("READ_LOCATION_INFO".equals(str2)) {
                actionType = CtaManager.ActionType.READ_LOCATION_INFO;
            }
            int i3 = i;
            int i4 = i2;
            this.mCtaManager.printCtaInfor(i3, i4, CtaManager.KeywordType.LOCATION, str, actionType, str3);
        }

        public void showNlpNotInstalledToast(String str) {
            try {
                Log.d(MtkLocationExt.TAG, "showNlpNotInstalledToast provider: " + str);
                if ("network".equals(str)) {
                    Toast.makeText(this.mContext, "No Network Location Provider is installed!NLP is necessary for network location fixes.", 1).show();
                }
            } catch (Exception e) {
                Log.w(MtkLocationExt.TAG, "Failed to show toast ", e);
            }
        }
    }
}
