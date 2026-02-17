package com.android.internal.telephony.util;

import android.app.NotificationChannel;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

public class VoicemailNotificationSettingsUtil {
    private static final String OLD_VOICEMAIL_NOTIFICATION_RINGTONE_SHARED_PREFS_KEY = "button_voicemail_notification_ringtone_key";
    private static final String OLD_VOICEMAIL_NOTIFICATION_VIBRATION_SHARED_PREFS_KEY = "button_voicemail_notification_vibrate_key";
    private static final String OLD_VOICEMAIL_RINGTONE_SHARED_PREFS_KEY = "button_voicemail_notification_ringtone_key";
    private static final String OLD_VOICEMAIL_VIBRATE_WHEN_SHARED_PREFS_KEY = "button_voicemail_notification_vibrate_when_key";
    private static final String OLD_VOICEMAIL_VIBRATION_ALWAYS = "always";
    private static final String OLD_VOICEMAIL_VIBRATION_NEVER = "never";
    private static final String VOICEMAIL_NOTIFICATION_RINGTONE_SHARED_PREFS_KEY_PREFIX = "voicemail_notification_ringtone_";
    private static final String VOICEMAIL_NOTIFICATION_VIBRATION_SHARED_PREFS_KEY_PREFIX = "voicemail_notification_vibrate_";

    public static void setVibrationEnabled(Context context, boolean z) {
        SharedPreferences.Editor edit = PreferenceManager.getDefaultSharedPreferences(context).edit();
        edit.putBoolean(getVoicemailVibrationSharedPrefsKey(), z);
        edit.commit();
    }

    public static boolean isVibrationEnabled(Context context) {
        NotificationChannel channel = NotificationChannelController.getChannel(NotificationChannelController.CHANNEL_ID_VOICE_MAIL, context);
        return channel != null ? channel.shouldVibrate() : getVibrationPreference(context);
    }

    public static boolean getVibrationPreference(Context context) {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        migrateVoicemailVibrationSettingsIfNeeded(context, defaultSharedPreferences);
        return defaultSharedPreferences.getBoolean(getVoicemailVibrationSharedPrefsKey(), false);
    }

    public static void setRingtoneUri(Context context, Uri uri) {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        String uri2 = uri != null ? uri.toString() : "";
        SharedPreferences.Editor edit = defaultSharedPreferences.edit();
        edit.putString(getVoicemailRingtoneSharedPrefsKey(), uri2);
        edit.commit();
    }

    public static Uri getRingtoneUri(Context context) {
        NotificationChannel channel = NotificationChannelController.getChannel(NotificationChannelController.CHANNEL_ID_VOICE_MAIL, context);
        return channel != null ? channel.getSound() : getRingTonePreference(context);
    }

    public static Uri getRingTonePreference(Context context) {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        migrateVoicemailRingtoneSettingsIfNeeded(context, defaultSharedPreferences);
        String string = defaultSharedPreferences.getString(getVoicemailRingtoneSharedPrefsKey(), Settings.System.DEFAULT_NOTIFICATION_URI.toString());
        if (!TextUtils.isEmpty(string)) {
            return Uri.parse(string);
        }
        return null;
    }

    private static void migrateVoicemailVibrationSettingsIfNeeded(Context context, SharedPreferences sharedPreferences) {
        String voicemailVibrationSharedPrefsKey = getVoicemailVibrationSharedPrefsKey();
        TelephonyManager from = TelephonyManager.from(context);
        if (!sharedPreferences.contains(voicemailVibrationSharedPrefsKey) && from.getPhoneCount() == 1) {
            if (sharedPreferences.contains(OLD_VOICEMAIL_NOTIFICATION_VIBRATION_SHARED_PREFS_KEY)) {
                sharedPreferences.edit().putBoolean(voicemailVibrationSharedPrefsKey, sharedPreferences.getBoolean(OLD_VOICEMAIL_NOTIFICATION_VIBRATION_SHARED_PREFS_KEY, false)).remove(OLD_VOICEMAIL_VIBRATE_WHEN_SHARED_PREFS_KEY).commit();
            }
            if (sharedPreferences.contains(OLD_VOICEMAIL_VIBRATE_WHEN_SHARED_PREFS_KEY)) {
                sharedPreferences.edit().putBoolean(voicemailVibrationSharedPrefsKey, sharedPreferences.getString(OLD_VOICEMAIL_VIBRATE_WHEN_SHARED_PREFS_KEY, OLD_VOICEMAIL_VIBRATION_NEVER).equals(OLD_VOICEMAIL_VIBRATION_ALWAYS)).remove(OLD_VOICEMAIL_NOTIFICATION_VIBRATION_SHARED_PREFS_KEY).commit();
            }
        }
    }

    private static void migrateVoicemailRingtoneSettingsIfNeeded(Context context, SharedPreferences sharedPreferences) {
        String voicemailRingtoneSharedPrefsKey = getVoicemailRingtoneSharedPrefsKey();
        TelephonyManager from = TelephonyManager.from(context);
        if (!sharedPreferences.contains(voicemailRingtoneSharedPrefsKey) && from.getPhoneCount() == 1 && sharedPreferences.contains("button_voicemail_notification_ringtone_key")) {
            sharedPreferences.edit().putString(voicemailRingtoneSharedPrefsKey, sharedPreferences.getString("button_voicemail_notification_ringtone_key", (String) null)).remove("button_voicemail_notification_ringtone_key").commit();
        }
    }

    private static String getVoicemailVibrationSharedPrefsKey() {
        return VOICEMAIL_NOTIFICATION_VIBRATION_SHARED_PREFS_KEY_PREFIX + SubscriptionManager.getDefaultSubscriptionId();
    }

    private static String getVoicemailRingtoneSharedPrefsKey() {
        return VOICEMAIL_NOTIFICATION_RINGTONE_SHARED_PREFS_KEY_PREFIX + SubscriptionManager.getDefaultSubscriptionId();
    }
}
