.class public final Lcom/mediatek/provider/MtkSettingsExt$System;
.super Ljava/lang/Object;
.source "MtkSettingsExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/provider/MtkSettingsExt;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "System"
.end annotation


# static fields
.field public static final ACCELEROMETER_ROTATION_RESTORE:Ljava/lang/String; = "accelerometer_rotation_restore"

.field public static final AUTO_TIME_GPS:Ljava/lang/String; = "auto_time_gps"

.field public static BASE_VOICE_WAKEUP_COMMAND_KEY:Ljava/lang/String; = "voice_wakeup_app"
    .annotation build Landroid/annotation/ProductApi;
    .end annotation
.end field

.field public static final BG_POWER_SAVING_ENABLE:Ljava/lang/String; = "background_power_saving_enable"

.field public static final DEFAULT_SIM_NOT_SET:J = -0x5L

.field public static final DEFAULT_SIM_SETTING_ALWAYS_ASK:J = -0x2L

.field public static final HDMI_AUDIO_OUTPUT_MODE:Ljava/lang/String; = "hdmi_audio_output_mode"

.field public static final HDMI_CABLE_PLUGGED:Ljava/lang/String; = "hdmi_cable_plugged"

.field public static final HDMI_ENABLE_STATUS:Ljava/lang/String; = "hdmi_enable_status"

.field public static final HDMI_VIDEO_RESOLUTION:Ljava/lang/String; = "hdmi_video_resolution"

.field public static final HDMI_VIDEO_SCALE:Ljava/lang/String; = "hdmi_video_scale"

.field public static final LAST_SIMID_BEFORE_WIFI_DISCONNECTED:Ljava/lang/String; = "last_simid_before_wifi_disconnected"

.field public static final MSIM_MODE_SETTING:Ljava/lang/String; = "msim_mode_setting"

.field public static final SMS_SIM_SETTING:Ljava/lang/String; = "sms_sim_setting"

.field public static final SMS_SIM_SETTING_AUTO:J = -0x3L

.field public static final SOUND_RECORDING_ERROR_STATUS:Ljava/lang/String; = "sound_recording_error_status"

.field public static SWITCH_RESOLUTION_BY_MODE:Ljava/lang/String; = "switch_resolution_by_mode"

.field public static final VOICE_CALL_SIM_SETTING_INTERNET:J = -0x2L

.field public static final VOICE_TRAINING_RETRAIN_CALLBACK_STATUS:Ljava/lang/String; = "voice_training_retrain_callback_status"

.field public static VOICE_TRIGGER_ACTIVE_COMMAND_ID:Ljava/lang/String; = "voice_trigger_active_command_id"

.field public static VOICE_TRIGGER_COMMAND_STATUS:Ljava/lang/String; = "voice_trigger_command_status"

.field public static VOICE_TRIGGER_MODE:Ljava/lang/String; = "voice_trigger_mode"

.field public static VOICE_WAKEUP_ACTIVE_COMMAND_ID:Ljava/lang/String; = "voice_wakeup_active_command_id"

.field public static VOICE_WAKEUP_COMMAND_STATUS:Ljava/lang/String; = "voice_wakeup_command_status"

.field public static VOICE_WAKEUP_COMMAND_STATUS_UPDATE:Ljava/lang/String; = "voice_wakeup_command_status_update"

.field public static VOICE_WAKEUP_COMMAND_UI_ACTION_1ENK:Ljava/lang/String; = "voice_wakeup_command_ui_action_1enk"

.field public static final VOICE_WAKEUP_MANAGER_COMMAND_STATUS_UPDATE:Ljava/lang/String; = "voice_wakeup_manager_command_status_update"

.field public static VOICE_WAKEUP_MODE:Ljava/lang/String; = "voice_wakeup_mode"

.field public static final WIFI_CONNECT_AP_TYPE:Ljava/lang/String; = "wifi_ap_connect_type"

.field public static final WIFI_CONNECT_AP_TYPE_AUTO:I = 0x0

.field public static final WIFI_CONNECT_REMINDER:Ljava/lang/String; = "wifi_connect_reminder"

.field public static final WIFI_CONNECT_TYPE:Ljava/lang/String; = "wifi_connect_type"

.field public static final WIFI_CONNECT_TYPE_ASK:I = 0x2

.field public static final WIFI_CONNECT_TYPE_AUTO:I = 0x0

.field public static final WIFI_CONNECT_TYPE_MANUL:I = 0x1

.field public static final WIFI_HOTSPOT_AUTO_DISABLE:Ljava/lang/String; = "wifi_hotspot_auto_disable"

.field public static final WIFI_HOTSPOT_AUTO_DISABLE_FOR_FIVE_MINS:I = 0x1

.field public static final WIFI_HOTSPOT_IS_ALL_DEVICES_ALLOWED:Ljava/lang/String; = "wifi_hotspot_is_all_devices_allowed"

.field public static final WIFI_HOTSPOT_MAX_CLIENT_NUM:Ljava/lang/String; = "wifi_hotspot_max_client_num"

.field public static final WIFI_PRIORITY_TYPE:Ljava/lang/String; = "wifi_priority_type"

.field public static final WIFI_PRIORITY_TYPE_DEFAULT:I = 0x0

.field public static final WIFI_PRIORITY_TYPE_MAMUAL:I = 0x1

.field public static final WIFI_SELECT_SSID_AUTO:I = 0x0

.field public static final WIFI_SELECT_SSID_TYPE:Ljava/lang/String; = "wifi_select_ssid_type"


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getVoiceCommandValue(Landroid/content/ContentResolver;Ljava/lang/String;I)Ljava/lang/String;
    .locals 1
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    .line 235
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static moveToGlobal(Ljava/util/HashSet;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/HashSet<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    const-string v0, "MtkSettingsProviderExt"

    const-string v1, "System moveToGlobal"

    .line 380
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v0, "msim_mode_setting"

    .line 381
    invoke-virtual {p0, v0}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    const-string v0, "auto_time_gps"

    .line 382
    invoke-virtual {p0, v0}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

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

    const-string v0, "System moveToSecure"

    .line 387
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static putInPublicSettings(Ljava/util/Set;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    const-string v0, "MtkSettingsProviderExt"

    const-string v1, "putInPublicSettings"

    .line 348
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v0, "msim_mode_setting"

    .line 349
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "auto_time_gps"

    .line 350
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "accelerometer_rotation_restore"

    .line 351
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "background_power_saving_enable"

    .line 352
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "hdmi_enable_status"

    .line 353
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "hdmi_video_resolution"

    .line 354
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "hdmi_video_scale"

    .line 355
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "hdmi_cable_plugged"

    .line 356
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "hdmi_audio_output_mode"

    .line 357
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string/jumbo v0, "wifi_connect_type"

    .line 358
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string/jumbo v0, "wifi_ap_connect_type"

    .line 359
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string/jumbo v0, "wifi_connect_reminder"

    .line 360
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string/jumbo v0, "wifi_priority_type"

    .line 361
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string/jumbo v0, "wifi_select_ssid_type"

    .line 362
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v0, "last_simid_before_wifi_disconnected"

    .line 363
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 364
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->BASE_VOICE_WAKEUP_COMMAND_KEY:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 365
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_WAKEUP_MODE:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 366
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_WAKEUP_COMMAND_STATUS:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 367
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_WAKEUP_COMMAND_STATUS_UPDATE:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 368
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_WAKEUP_COMMAND_UI_ACTION_1ENK:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 369
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_WAKEUP_ACTIVE_COMMAND_ID:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 370
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_TRIGGER_MODE:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 371
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_TRIGGER_COMMAND_STATUS:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 372
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->VOICE_TRIGGER_ACTIVE_COMMAND_ID:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string/jumbo v0, "voice_wakeup_manager_command_status_update"

    .line 373
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 374
    sget-object v0, Lcom/mediatek/provider/MtkSettingsExt$System;->SWITCH_RESOLUTION_BY_MODE:Ljava/lang/String;

    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string/jumbo v0, "voice_training_retrain_callback_status"

    .line 375
    invoke-interface {p0, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public static setVoiceCommandValue(Landroid/content/ContentResolver;Ljava/lang/String;ILjava/lang/String;)V
    .locals 1

    .line 225
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1, p3}, Landroid/provider/Settings$System;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z

    return-void
.end method
