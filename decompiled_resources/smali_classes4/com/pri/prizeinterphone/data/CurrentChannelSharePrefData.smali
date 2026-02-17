.class public Lcom/pri/prizeinterphone/data/CurrentChannelSharePrefData;
.super Ljava/lang/Object;
.source "CurrentChannelSharePrefData.java"


# static fields
.field public static final PREF_CURRENT_CHANNEL_DATA:Ljava/lang/String; = "com.pri.prizeinterphone.data.currentchannel"

.field public static final PREF_CURRENT_CHANNEL_ID:Ljava/lang/String; = "pref_current_channel_id"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z
    .locals 2

    .line 49
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.currentchannel"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 50
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public static getIntData(Landroid/content/Context;Ljava/lang/String;I)I
    .locals 2

    .line 22
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.currentchannel"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 23
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method public static getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 36
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.currentchannel"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 37
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V
    .locals 2

    .line 42
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.currentchannel"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 43
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 44
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 45
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static putIntData(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 2

    .line 15
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.currentchannel"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 16
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 17
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 18
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 29
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.currentchannel"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 30
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 31
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 32
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method
