.class public Lcom/android/internal/telephony/MockModem;
.super Ljava/lang/Object;
.source "MockModem.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/MockModem$MockModemConnection;
    }
.end annotation


# static fields
.field static final BINDER_MAX_RETRY:I = 0x3

.field static final BINDER_RETRY_MILLIS:I = 0x12c

.field private static final BIND_IRADIOCONFIG:Ljava/lang/String; = "android.telephony.mockmodem.iradioconfig"

.field private static final BIND_IRADIODATA:Ljava/lang/String; = "android.telephony.mockmodem.iradiodata"

.field private static final BIND_IRADIOMESSAGING:Ljava/lang/String; = "android.telephony.mockmodem.iradiomessaging"

.field private static final BIND_IRADIOMODEM:Ljava/lang/String; = "android.telephony.mockmodem.iradiomodem"

.field private static final BIND_IRADIONETWORK:Ljava/lang/String; = "android.telephony.mockmodem.iradionetwork"

.field private static final BIND_IRADIOSIM:Ljava/lang/String; = "android.telephony.mockmodem.iradiosim"

.field private static final BIND_IRADIOVOICE:Ljava/lang/String; = "android.telephony.mockmodem.iradiovoice"

.field private static final DEFAULT_PHONE_ID:B = 0x0t

.field private static final PHONE_ID:Ljava/lang/String; = "phone_id"

.field static final RADIOCONFIG_SERVICE:I = 0x7

.field private static final TAG:Ljava/lang/String; = "MockModem"


# instance fields
.field private mConfigBinder:Landroid/os/IBinder;

.field private mConfigServiceConnection:Landroid/content/ServiceConnection;

.field private mContext:Landroid/content/Context;

.field private mDataBinder:Landroid/os/IBinder;

.field private mDataServiceConnection:Landroid/content/ServiceConnection;

.field private mMessagingBinder:Landroid/os/IBinder;

.field private mMessagingServiceConnection:Landroid/content/ServiceConnection;

.field private mModemBinder:Landroid/os/IBinder;

.field private mModemServiceConnection:Landroid/content/ServiceConnection;

.field private mNetworkBinder:Landroid/os/IBinder;

.field private mNetworkServiceConnection:Landroid/content/ServiceConnection;

.field private mPackageName:Ljava/lang/String;

.field private mPhoneId:B

.field private mServiceName:Ljava/lang/String;

.field private mSimBinder:Landroid/os/IBinder;

.field private mSimServiceConnection:Landroid/content/ServiceConnection;

.field private mVoiceBinder:Landroid/os/IBinder;

.field private mVoiceServiceConnection:Landroid/content/ServiceConnection;


# direct methods
.method static bridge synthetic -$$Nest$fputmConfigBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mConfigBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDataBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mDataBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmMessagingBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mMessagingBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmModemBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mModemBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmNetworkBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mNetworkBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmSimBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mSimBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmVoiceBinder(Lcom/android/internal/telephony/MockModem;Landroid/os/IBinder;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mVoiceBinder:Landroid/os/IBinder;

    return-void
.end method

.method static bridge synthetic -$$Nest$mgetModuleName(Lcom/android/internal/telephony/MockModem;I)Ljava/lang/String;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MockModem;->getModuleName(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    .line 69
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/MockModem;-><init>(Landroid/content/Context;Ljava/lang/String;I)V

    return-void
.end method

.method constructor <init>(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 0

    .line 72
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    int-to-byte p3, p3

    .line 73
    iput-byte p3, p0, Lcom/android/internal/telephony/MockModem;->mPhoneId:B

    .line 74
    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    const-string p1, "/"

    const/4 p3, 0x2

    .line 75
    invoke-virtual {p2, p1, p3}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p1

    const/4 p2, 0x0

    .line 76
    aget-object p2, p1, p2

    iput-object p2, p0, Lcom/android/internal/telephony/MockModem;->mPackageName:Ljava/lang/String;

    const/4 p2, 0x1

    .line 77
    aget-object p1, p1, p2

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mServiceName:Ljava/lang/String;

    return-void
.end method

.method private bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z
    .locals 4

    .line 139
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    .line 140
    new-instance v1, Landroid/content/ComponentName;

    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mPackageName:Ljava/lang/String;

    iget-object v3, p0, Lcom/android/internal/telephony/MockModem;->mServiceName:Ljava/lang/String;

    invoke-direct {v1, v2, v3}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 141
    invoke-virtual {v0, p2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const-string p2, "phone_id"

    .line 142
    invoke-virtual {v0, p2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;B)Landroid/content/Intent;

    .line 144
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    const/4 p1, 0x1

    invoke-virtual {p0, v0, p3, p1}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result p0

    return p0
.end method

.method private bindModuleToMockModemService(Ljava/lang/String;Landroid/content/ServiceConnection;)Z
    .locals 1

    const/4 v0, 0x0

    .line 132
    invoke-direct {p0, v0, p1, p2}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p0

    return p0
.end method

.method private getModuleName(I)Ljava/lang/String;
    .locals 0

    packed-switch p1, :pswitch_data_0

    const-string p0, "none"

    return-object p0

    :pswitch_0
    const-string p0, "config"

    return-object p0

    :pswitch_1
    const-string/jumbo p0, "voice"

    return-object p0

    :pswitch_2
    const-string/jumbo p0, "sim"

    return-object p0

    :pswitch_3
    const-string p0, "network"

    return-object p0

    :pswitch_4
    const-string p0, "modem"

    return-object p0

    :pswitch_5
    const-string p0, "messaging"

    return-object p0

    :pswitch_6
    const-string p0, "data"

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method


# virtual methods
.method public bindAllMockModemService()V
    .locals 2

    const/4 v0, 0x0

    :goto_0
    const/4 v1, 0x6

    if-gt v0, v1, :cond_0

    .line 173
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/MockModem;->bindToMockModemService(I)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method public bindToMockModemService(I)V
    .locals 4

    const/4 v0, 0x7

    const/4 v1, 0x0

    const-string v2, "MockModem"

    if-ne p1, v0, :cond_1

    .line 180
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mConfigBinder:Landroid/os/IBinder;

    if-nez p1, :cond_0

    .line 181
    new-instance p1, Lcom/android/internal/telephony/MockModem$MockModemConnection;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/MockModem$MockModemConnection;-><init>(Lcom/android/internal/telephony/MockModem;I)V

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mConfigServiceConnection:Landroid/content/ServiceConnection;

    const-string v0, "android.telephony.mockmodem.iradioconfig"

    .line 184
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(Ljava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p1

    if-nez p1, :cond_d

    const-string p1, "IRadio Config bind fail"

    .line 186
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 187
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mConfigServiceConnection:Landroid/content/ServiceConnection;

    goto/16 :goto_0

    :cond_0
    const-string p0, "IRadio Config is bound"

    .line 190
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    :cond_1
    const/4 v0, 0x3

    if-ne p1, v0, :cond_3

    .line 193
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mModemBinder:Landroid/os/IBinder;

    if-nez p1, :cond_2

    .line 194
    new-instance p1, Lcom/android/internal/telephony/MockModem$MockModemConnection;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/MockModem$MockModemConnection;-><init>(Lcom/android/internal/telephony/MockModem;I)V

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mModemServiceConnection:Landroid/content/ServiceConnection;

    .line 196
    iget-byte v0, p0, Lcom/android/internal/telephony/MockModem;->mPhoneId:B

    const-string v3, "android.telephony.mockmodem.iradiomodem"

    .line 197
    invoke-direct {p0, v0, v3, p1}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p1

    if-nez p1, :cond_d

    const-string p1, "IRadio Modem bind fail"

    .line 200
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 201
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mModemServiceConnection:Landroid/content/ServiceConnection;

    goto/16 :goto_0

    :cond_2
    const-string p0, "IRadio Modem is bound"

    .line 204
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    :cond_3
    const/4 v0, 0x5

    if-ne p1, v0, :cond_5

    .line 207
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mSimBinder:Landroid/os/IBinder;

    if-nez p1, :cond_4

    .line 208
    new-instance p1, Lcom/android/internal/telephony/MockModem$MockModemConnection;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/MockModem$MockModemConnection;-><init>(Lcom/android/internal/telephony/MockModem;I)V

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mSimServiceConnection:Landroid/content/ServiceConnection;

    .line 210
    iget-byte v0, p0, Lcom/android/internal/telephony/MockModem;->mPhoneId:B

    const-string v3, "android.telephony.mockmodem.iradiosim"

    .line 211
    invoke-direct {p0, v0, v3, p1}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p1

    if-nez p1, :cond_d

    const-string p1, "IRadio Sim bind fail"

    .line 214
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 215
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mSimServiceConnection:Landroid/content/ServiceConnection;

    goto/16 :goto_0

    :cond_4
    const-string p0, "IRadio Sim is bound"

    .line 218
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    :cond_5
    const/4 v0, 0x2

    if-ne p1, v0, :cond_7

    .line 221
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mMessagingBinder:Landroid/os/IBinder;

    if-nez p1, :cond_6

    .line 222
    new-instance p1, Lcom/android/internal/telephony/MockModem$MockModemConnection;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/MockModem$MockModemConnection;-><init>(Lcom/android/internal/telephony/MockModem;I)V

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mMessagingServiceConnection:Landroid/content/ServiceConnection;

    .line 224
    iget-byte v0, p0, Lcom/android/internal/telephony/MockModem;->mPhoneId:B

    const-string v3, "android.telephony.mockmodem.iradiomessaging"

    .line 225
    invoke-direct {p0, v0, v3, p1}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p1

    if-nez p1, :cond_d

    const-string p1, "IRadio Messaging bind fail"

    .line 228
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 229
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mMessagingServiceConnection:Landroid/content/ServiceConnection;

    goto/16 :goto_0

    :cond_6
    const-string p0, "IRadio Messaging is bound"

    .line 232
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    :cond_7
    const/4 v0, 0x1

    if-ne p1, v0, :cond_9

    .line 235
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mDataBinder:Landroid/os/IBinder;

    if-nez p1, :cond_8

    .line 236
    new-instance p1, Lcom/android/internal/telephony/MockModem$MockModemConnection;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/MockModem$MockModemConnection;-><init>(Lcom/android/internal/telephony/MockModem;I)V

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mDataServiceConnection:Landroid/content/ServiceConnection;

    .line 238
    iget-byte v0, p0, Lcom/android/internal/telephony/MockModem;->mPhoneId:B

    const-string v3, "android.telephony.mockmodem.iradiodata"

    .line 239
    invoke-direct {p0, v0, v3, p1}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p1

    if-nez p1, :cond_d

    const-string p1, "IRadio Data bind fail"

    .line 242
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 243
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mDataServiceConnection:Landroid/content/ServiceConnection;

    goto :goto_0

    :cond_8
    const-string p0, "IRadio Data is bound"

    .line 246
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_9
    const/4 v0, 0x4

    if-ne p1, v0, :cond_b

    .line 249
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mNetworkBinder:Landroid/os/IBinder;

    if-nez p1, :cond_a

    .line 250
    new-instance p1, Lcom/android/internal/telephony/MockModem$MockModemConnection;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/MockModem$MockModemConnection;-><init>(Lcom/android/internal/telephony/MockModem;I)V

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mNetworkServiceConnection:Landroid/content/ServiceConnection;

    .line 252
    iget-byte v0, p0, Lcom/android/internal/telephony/MockModem;->mPhoneId:B

    const-string v3, "android.telephony.mockmodem.iradionetwork"

    .line 253
    invoke-direct {p0, v0, v3, p1}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p1

    if-nez p1, :cond_d

    const-string p1, "IRadio Network bind fail"

    .line 256
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 257
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mNetworkServiceConnection:Landroid/content/ServiceConnection;

    goto :goto_0

    :cond_a
    const-string p0, "IRadio Network is bound"

    .line 260
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_b
    const/4 v0, 0x6

    if-ne p1, v0, :cond_d

    .line 263
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mVoiceBinder:Landroid/os/IBinder;

    if-nez p1, :cond_c

    .line 264
    new-instance p1, Lcom/android/internal/telephony/MockModem$MockModemConnection;

    invoke-direct {p1, p0, v0}, Lcom/android/internal/telephony/MockModem$MockModemConnection;-><init>(Lcom/android/internal/telephony/MockModem;I)V

    iput-object p1, p0, Lcom/android/internal/telephony/MockModem;->mVoiceServiceConnection:Landroid/content/ServiceConnection;

    .line 266
    iget-byte v0, p0, Lcom/android/internal/telephony/MockModem;->mPhoneId:B

    const-string v3, "android.telephony.mockmodem.iradiovoice"

    .line 267
    invoke-direct {p0, v0, v3, p1}, Lcom/android/internal/telephony/MockModem;->bindModuleToMockModemService(BLjava/lang/String;Landroid/content/ServiceConnection;)Z

    move-result p1

    if-nez p1, :cond_d

    const-string p1, "IRadio Voice bind fail"

    .line 270
    invoke-static {v2, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 271
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mVoiceServiceConnection:Landroid/content/ServiceConnection;

    goto :goto_0

    :cond_c
    const-string p0, "IRadio Voice is bound"

    .line 274
    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_d
    :goto_0
    return-void
.end method

.method public getServiceBinder(I)Landroid/os/IBinder;
    .locals 0

    packed-switch p1, :pswitch_data_0

    const/4 p0, 0x0

    return-object p0

    .line 164
    :pswitch_0
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mConfigBinder:Landroid/os/IBinder;

    return-object p0

    .line 162
    :pswitch_1
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mVoiceBinder:Landroid/os/IBinder;

    return-object p0

    .line 154
    :pswitch_2
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mSimBinder:Landroid/os/IBinder;

    return-object p0

    .line 160
    :pswitch_3
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mNetworkBinder:Landroid/os/IBinder;

    return-object p0

    .line 152
    :pswitch_4
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mModemBinder:Landroid/os/IBinder;

    return-object p0

    .line 156
    :pswitch_5
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mMessagingBinder:Landroid/os/IBinder;

    return-object p0

    .line 158
    :pswitch_6
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mDataBinder:Landroid/os/IBinder;

    return-object p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public getServiceName()Ljava/lang/String;
    .locals 0

    .line 335
    iget-object p0, p0, Lcom/android/internal/telephony/MockModem;->mServiceName:Ljava/lang/String;

    return-object p0
.end method

.method public unbindMockModemService(I)V
    .locals 3

    const-string v0, "MockModem"

    const/4 v1, 0x0

    const/4 v2, 0x7

    if-ne p1, v2, :cond_0

    .line 283
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mConfigServiceConnection:Landroid/content/ServiceConnection;

    if-eqz p1, :cond_6

    .line 284
    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    invoke-virtual {v2, p1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 285
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mConfigServiceConnection:Landroid/content/ServiceConnection;

    .line 286
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mConfigBinder:Landroid/os/IBinder;

    const-string/jumbo p0, "unbind IRadio Config"

    .line 287
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    :cond_0
    const/4 v2, 0x3

    if-ne p1, v2, :cond_1

    .line 290
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mModemServiceConnection:Landroid/content/ServiceConnection;

    if-eqz p1, :cond_6

    .line 291
    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    invoke-virtual {v2, p1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 292
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mModemServiceConnection:Landroid/content/ServiceConnection;

    .line 293
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mModemBinder:Landroid/os/IBinder;

    const-string/jumbo p0, "unbind IRadio Modem"

    .line 294
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    :cond_1
    const/4 v2, 0x5

    if-ne p1, v2, :cond_2

    .line 297
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mSimServiceConnection:Landroid/content/ServiceConnection;

    if-eqz p1, :cond_6

    .line 298
    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    invoke-virtual {v2, p1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 299
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mSimServiceConnection:Landroid/content/ServiceConnection;

    .line 300
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mSimBinder:Landroid/os/IBinder;

    const-string/jumbo p0, "unbind IRadio Sim"

    .line 301
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_2
    const/4 v2, 0x2

    if-ne p1, v2, :cond_3

    .line 304
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mMessagingServiceConnection:Landroid/content/ServiceConnection;

    if-eqz p1, :cond_6

    .line 305
    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    invoke-virtual {v2, p1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 306
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mMessagingServiceConnection:Landroid/content/ServiceConnection;

    .line 307
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mMessagingBinder:Landroid/os/IBinder;

    const-string/jumbo p0, "unbind IRadio Messaging"

    .line 308
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_3
    const/4 v2, 0x1

    if-ne p1, v2, :cond_4

    .line 311
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mDataServiceConnection:Landroid/content/ServiceConnection;

    if-eqz p1, :cond_6

    .line 312
    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    invoke-virtual {v2, p1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 313
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mDataServiceConnection:Landroid/content/ServiceConnection;

    .line 314
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mDataBinder:Landroid/os/IBinder;

    const-string/jumbo p0, "unbind IRadio Data"

    .line 315
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_4
    const/4 v2, 0x4

    if-ne p1, v2, :cond_5

    .line 318
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mNetworkServiceConnection:Landroid/content/ServiceConnection;

    if-eqz p1, :cond_6

    .line 319
    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    invoke-virtual {v2, p1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 320
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mNetworkServiceConnection:Landroid/content/ServiceConnection;

    .line 321
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mNetworkBinder:Landroid/os/IBinder;

    const-string/jumbo p0, "unbind IRadio Network"

    .line 322
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_5
    const/4 v2, 0x6

    if-ne p1, v2, :cond_6

    .line 325
    iget-object p1, p0, Lcom/android/internal/telephony/MockModem;->mVoiceServiceConnection:Landroid/content/ServiceConnection;

    if-eqz p1, :cond_6

    .line 326
    iget-object v2, p0, Lcom/android/internal/telephony/MockModem;->mContext:Landroid/content/Context;

    invoke-virtual {v2, p1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    .line 327
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mVoiceServiceConnection:Landroid/content/ServiceConnection;

    .line 328
    iput-object v1, p0, Lcom/android/internal/telephony/MockModem;->mVoiceBinder:Landroid/os/IBinder;

    const-string/jumbo p0, "unbind IRadio Voice"

    .line 329
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_6
    :goto_0
    return-void
.end method
