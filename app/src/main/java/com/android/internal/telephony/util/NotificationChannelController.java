package com.android.internal.telephony.util;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioAttributes;
import android.net.Uri;
import android.provider.Settings;
import android.telephony.SubscriptionManager;
import java.util.Arrays;

public class NotificationChannelController {
    public static final String CHANNEL_ID_ALERT = "alert";
    public static final String CHANNEL_ID_CALL_FORWARD = "callForwardNew";
    private static final String CHANNEL_ID_CALL_FORWARD_DEPRECATED = "callForward";
    private static final String CHANNEL_ID_MOBILE_DATA_ALERT_DEPRECATED = "mobileDataAlert";
    public static final String CHANNEL_ID_MOBILE_DATA_STATUS = "mobileDataAlertNew";
    public static final String CHANNEL_ID_SIM = "sim";
    public static final String CHANNEL_ID_SIM_HIGH_PRIORITY = "simHighPriority";
    public static final String CHANNEL_ID_SMS = "sms";
    public static final String CHANNEL_ID_VOICE_MAIL = "voiceMail";
    public static final String CHANNEL_ID_WFC = "wfc";
    private final BroadcastReceiver mBroadcastReceiver;

    /* access modifiers changed from: private */
    public static void createAll(Context context) {
        NotificationChannel notificationChannel = new NotificationChannel(CHANNEL_ID_ALERT, context.getText(17040901), 3);
        notificationChannel.setSound(Settings.System.DEFAULT_NOTIFICATION_URI, new AudioAttributes.Builder().setUsage(5).build());
        notificationChannel.setBlockable(true);
        NotificationChannel notificationChannel2 = new NotificationChannel(CHANNEL_ID_MOBILE_DATA_STATUS, context.getText(17040900), 2);
        notificationChannel2.setBlockable(true);
        NotificationChannel notificationChannel3 = new NotificationChannel(CHANNEL_ID_SIM, context.getText(17040908), 2);
        notificationChannel3.setSound((Uri) null, (AudioAttributes) null);
        NotificationChannel notificationChannel4 = new NotificationChannel(CHANNEL_ID_CALL_FORWARD, context.getText(17040891), 3);
        migrateCallFowardNotificationChannel(context, notificationChannel4);
        ((NotificationManager) context.getSystemService(NotificationManager.class)).createNotificationChannels(Arrays.asList(new NotificationChannel[]{new NotificationChannel(CHANNEL_ID_SMS, context.getText(17040910), 4), new NotificationChannel(CHANNEL_ID_WFC, context.getText(17040917), 2), new NotificationChannel(CHANNEL_ID_SIM_HIGH_PRIORITY, context.getText(17040909), 4), notificationChannel, notificationChannel2, notificationChannel3, notificationChannel4}));
        if (getChannel(CHANNEL_ID_VOICE_MAIL, context) != null) {
            migrateVoicemailNotificationSettings(context);
        }
        if (getChannel(CHANNEL_ID_MOBILE_DATA_ALERT_DEPRECATED, context) != null) {
            ((NotificationManager) context.getSystemService(NotificationManager.class)).deleteNotificationChannel(CHANNEL_ID_MOBILE_DATA_ALERT_DEPRECATED);
        }
        if (getChannel(CHANNEL_ID_CALL_FORWARD_DEPRECATED, context) != null) {
            ((NotificationManager) context.getSystemService(NotificationManager.class)).deleteNotificationChannel(CHANNEL_ID_CALL_FORWARD_DEPRECATED);
        }
    }

    public NotificationChannelController(Context context) {
        AnonymousClass1 r0 = new BroadcastReceiver() {
            public void onReceive(Context context, Intent intent) {
                if ("android.intent.action.LOCALE_CHANGED".equals(intent.getAction())) {
                    NotificationChannelController.createAll(context);
                } else if ("android.intent.action.SIM_STATE_CHANGED".equals(intent.getAction()) && -1 != SubscriptionManager.getDefaultSubscriptionId()) {
                    NotificationChannelController.migrateVoicemailNotificationSettings(context);
                }
            }
        };
        this.mBroadcastReceiver = r0;
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("android.intent.action.LOCALE_CHANGED");
        intentFilter.addAction("android.intent.action.SIM_STATE_CHANGED");
        context.registerReceiver(r0, intentFilter);
        createAll(context);
    }

    public static NotificationChannel getChannel(String str, Context context) {
        return ((NotificationManager) context.getSystemService(NotificationManager.class)).getNotificationChannel(str);
    }

    /* access modifiers changed from: private */
    public static void migrateVoicemailNotificationSettings(Context context) {
        NotificationChannel notificationChannel = new NotificationChannel(CHANNEL_ID_VOICE_MAIL, context.getText(17040915), 3);
        notificationChannel.enableVibration(VoicemailNotificationSettingsUtil.getVibrationPreference(context));
        Uri ringTonePreference = VoicemailNotificationSettingsUtil.getRingTonePreference(context);
        if (ringTonePreference == null) {
            ringTonePreference = Settings.System.DEFAULT_NOTIFICATION_URI;
        }
        notificationChannel.setSound(ringTonePreference, new AudioAttributes.Builder().setUsage(5).build());
        ((NotificationManager) context.getSystemService(NotificationManager.class)).createNotificationChannel(notificationChannel);
    }

    private static void migrateCallFowardNotificationChannel(Context context, NotificationChannel notificationChannel) {
        NotificationChannel channel = getChannel(CHANNEL_ID_CALL_FORWARD_DEPRECATED, context);
        if (channel != null) {
            notificationChannel.setSound(channel.getSound(), channel.getAudioAttributes());
            notificationChannel.setVibrationPattern(channel.getVibrationPattern());
            notificationChannel.enableVibration(channel.shouldVibrate());
        }
    }
}
