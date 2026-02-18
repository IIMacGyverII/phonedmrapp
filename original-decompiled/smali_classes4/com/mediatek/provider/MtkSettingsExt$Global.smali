.class public final Lcom/mediatek/provider/MtkSettingsExt$Global;
.super Ljava/lang/Object;
.source "MtkSettingsExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/provider/MtkSettingsExt;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Global"
.end annotation


# static fields
.field public static final AUTO_TIME_GPS:Ljava/lang/String; = "auto_time_gps"

.field public static final CURRENT_NETWORK_CALL:Ljava/lang/String; = "current_network_call"

.field public static final CURRENT_NETWORK_SMS:Ljava/lang/String; = "current_network_sms"

.field public static final DATA_SERVICE_ENABLED:Ljava/lang/String; = "data_service_enabled"

.field public static final DOMESTIC_DATA_ROAMING:Ljava/lang/String; = "domestic_data_roaming"

.field public static final DOMESTIC_DATA_ROAMING_GUARD:Ljava/lang/String; = "domestic_data_roaming_guard"

.field public static final DOMESTIC_LTE_DATA_ROAMING:Ljava/lang/String; = "domestic_data_roaming"

.field public static final DOMESTIC_VOICE_TEXT_ROAMING:Ljava/lang/String; = "domestic_voice_text_roaming"

.field public static final DOMESTIC_VOICE_TEXT_ROAMING_GUARD:Ljava/lang/String; = "domestic_voice_text_roaming_guard"

.field public static final DSDA_ENABLED:Ljava/lang/String; = "dsda_enabled"

.field public static final INTERNATIONAL_DATA_ROAMING:Ljava/lang/String; = "international_data_roaming"

.field public static final INTERNATIONAL_DATA_ROAMING_GUARD:Ljava/lang/String; = "international_data_roaming_guard"

.field public static final INTERNATIONAL_TEXT_ROAMING_GUARD:Ljava/lang/String; = "international_text_roaming_guard"

.field public static final INTERNATIONAL_VOICE_ROAMING_GUARD:Ljava/lang/String; = "international_voice_roaming_guard"

.field public static final INTERNATIONAL_VOICE_TEXT_ROAMING:Ljava/lang/String; = "international_voice_text_roaming"

.field public static final MSIM_MODE_SETTING:Ljava/lang/String; = "msim_mode_setting"

.field public static final NFC_HCE_ON:Ljava/lang/String; = "nfc_hce_on"

.field public static final NFC_MULTISE_ACTIVE:Ljava/lang/String; = "nfc_multise_active"

.field public static final NFC_MULTISE_IN_SWITCHING:Ljava/lang/String; = "nfc_multise_in_switching"

.field public static final NFC_MULTISE_IN_TRANSACTION:Ljava/lang/String; = "nfc_multise_in_transation"

.field public static final NFC_MULTISE_LIST:Ljava/lang/String; = "nfc_multise_list"

.field public static final NFC_MULTISE_ON:Ljava/lang/String; = "nfc_multise_on"

.field public static final NFC_MULTISE_PREVIOUS:Ljava/lang/String; = "nfc_multise_previous"

.field public static final NFC_RF_FIELD_ACTIVE:Ljava/lang/String; = "nfc_rf_field_active"

.field public static final PRIMARY_SIM:Ljava/lang/String; = "primary_sim"

.field public static final SHOW_AMPLIFIER_OVERHEAT_WARNING:Ljava/lang/String; = "show_amplifier_overheat_warning"

.field public static final SMART_RAT_SWITCH_DEBUG:Ljava/lang/String; = "smart_rat_switch_debug"

.field public static final SMART_RAT_SWITCH_ENABLED:Ljava/lang/String; = "smart_rat_switch_enabled"

.field public static final TELECOM_RTT_AUDIO_MODE:Ljava/lang/String; = "telecom_rtt_adudio_mode"

.field public static final TELEPHONY_MISC_FEATURE_CONFIG:Ljava/lang/String; = "telephony_misc_feature_config"

.field public static final WIFI_DISPLAY_AUTO_CHANNEL_SELECTION:Ljava/lang/String; = "wifi_display_auto_channel_selection"

.field public static final WIFI_DISPLAY_CHOSEN_CAPABILITY:Ljava/lang/String; = "wifi_display_chosen_capability"

.field public static final WIFI_DISPLAY_DISPLAY_NOTIFICATION_TIME:Ljava/lang/String; = "wifi_display_notification_time"

.field public static final WIFI_DISPLAY_DISPLAY_TOAST_TIME:Ljava/lang/String; = "wifi_display_display_toast_time"

.field public static final WIFI_DISPLAY_LATENCY_PROFILING:Ljava/lang/String; = "wifi_display_latency_profiling"

.field public static final WIFI_DISPLAY_PORTRAIT_RESOLUTION:Ljava/lang/String; = "wifi_display_portrait_resolution"

.field public static final WIFI_DISPLAY_POWER_SAVING_DELAY:Ljava/lang/String; = "wifi_display_power_saving_delay"

.field public static final WIFI_DISPLAY_POWER_SAVING_OPTION:Ljava/lang/String; = "wifi_display_power_saving_option"

.field public static final WIFI_DISPLAY_QE_ON:Ljava/lang/String; = "wifi_display_qe_on"

.field public static final WIFI_DISPLAY_RESOLUTION:Ljava/lang/String; = "wifi_display_max_resolution"

.field public static final WIFI_DISPLAY_RESOLUTION_DONOT_REMIND:Ljava/lang/String; = "wifi_display_change_resolution_remind"

.field public static final WIFI_DISPLAY_SECURITY_OPTION:Ljava/lang/String; = "wifi_display_security_option"

.field public static final WIFI_DISPLAY_SOUND_PATH_DONOT_REMIND:Ljava/lang/String; = "wifi_display_sound_path_do_not_remind"

.field public static final WIFI_DISPLAY_SQC_INFO_ON:Ljava/lang/String; = "wifi_display_sqc_info_on"

.field public static final WIFI_DISPLAY_WFD_LATENCY:Ljava/lang/String; = "wifi_display_wfd_latency"

.field public static final WIFI_DISPLAY_WIFI_INFO:Ljava/lang/String; = "wifi_display_wifi_info"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 401
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static moveToSecure(Ljava/util/HashSet;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/HashSet<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    const-string p0, "MtkSettingsProviderExt"

    const-string v0, "Global moveToSecure"

    .line 738
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
