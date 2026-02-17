.class public Lcom/pri/prizeinterphone/data/PersonSharePrefData;
.super Ljava/lang/Object;
.source "PersonSharePrefData.java"


# static fields
.field public static final PERSON_CONTACTS_SELETED_ID_DEFAULT:Ljava/lang/String; = "default"

.field public static final PREF_PERSON_BUSY_NO_SEND:Ljava/lang/String; = "pref_person_busy_no_send"

.field public static final PREF_PERSON_CHANNEL_AREA_SELECTED_INDEX:Ljava/lang/String; = "pref_person_channel_area_selected_index"

.field public static final PREF_PERSON_CONTACTS_SELETED:Ljava/lang/String; = "pref_person_contacts_seleted"

.field public static final PREF_PERSON_CONTACTS_SELETED_ID:Ljava/lang/String; = "pref_person_contacts_seleted_id"

.field public static final PREF_PERSON_CONTACTS_SELETED_TYPE:Ljava/lang/String; = "pref_person_contacts_seleted_type"

.field public static final PREF_PERSON_DATA:Ljava/lang/String; = "com.pri.prizeinterphone.data.person"

.field public static final PREF_PERSON_DEVICE_ID:Ljava/lang/String; = "pref_person_device_id"

.field public static final PREF_PERSON_ICON:Ljava/lang/String; = "pref_person_icon"

.field public static final PREF_PERSON_LIMIT_SEND_TIME:Ljava/lang/String; = "pref_person_limit_send_time"

.field public static final PREF_PERSON_MESSAGE_DB_VERSION:Ljava/lang/String; = "pref_person_message_db_version"

.field public static final PREF_PERSON_PTT_END_TONE:Ljava/lang/String; = "pref_person_ptt_end_tone"

.field public static final PREF_PERSON_PTT_RECORD:Ljava/lang/String; = "pref_person_ptt_record"

.field public static final PREF_PERSON_PTT_START_TONE:Ljava/lang/String; = "pref_person_ptt_start_tone"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getBooleanData(Landroid/content/Context;Ljava/lang/String;Z)Z
    .locals 2

    .line 70
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 71
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public static getImgData(Landroid/content/Context;Ljava/lang/String;Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;
    .locals 2

    .line 86
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, ""

    .line 87
    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 89
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_0

    .line 90
    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object p0

    const/4 p1, 0x1

    invoke-static {p0, p1}, Landroid/util/Base64;->decode([BI)[B

    move-result-object p0

    .line 91
    array-length p1, p0

    invoke-static {p0, v1, p1}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object p2

    :cond_0
    return-object p2
.end method

.method public static getIntData(Landroid/content/Context;Ljava/lang/String;I)I
    .locals 2

    .line 43
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 44
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method public static getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 57
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 58
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static putBooleanData(Landroid/content/Context;Ljava/lang/String;Z)V
    .locals 2

    .line 63
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 64
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 65
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 66
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static putImgData(Landroid/content/Context;Ljava/lang/String;Landroid/graphics/Bitmap;)V
    .locals 4

    .line 76
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 77
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 78
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 79
    sget-object v2, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v3, 0x64

    invoke-virtual {p2, v2, v3, v0}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 80
    new-instance p2, Ljava/lang/String;

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    invoke-static {v0, v1}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p2, v0}, Ljava/lang/String;-><init>(Ljava/lang/String;)V

    .line 81
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 82
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static putIntData(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 2

    .line 36
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 37
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 38
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 39
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method

.method public static putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 50
    invoke-static {}, Lcom/pri/prizeinterphone/InterPhoneApplication;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "com.pri.prizeinterphone.data.person"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 51
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 52
    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 53
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return-void
.end method
