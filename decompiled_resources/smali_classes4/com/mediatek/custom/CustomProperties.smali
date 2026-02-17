.class public Lcom/mediatek/custom/CustomProperties;
.super Ljava/lang/Object;
.source "CustomProperties.java"


# static fields
.field public static final HOST_NAME:Ljava/lang/String; = "HostName"

.field public static final MANUFACTURER:Ljava/lang/String; = "Manufacturer"

.field public static final MODEL:Ljava/lang/String; = "Model"

.field public static final MODULE_BLUETOOTH:Ljava/lang/String; = "bluetooth"

.field public static final MODULE_BROWSER:Ljava/lang/String; = "browser"

.field public static final MODULE_CMMB:Ljava/lang/String; = "cmmb"

.field public static final MODULE_DM:Ljava/lang/String; = "dm"

.field public static final MODULE_FMTRANSMITTER:Ljava/lang/String; = "fmtransmitter"

.field public static final MODULE_HTTP_STREAMING:Ljava/lang/String; = "http_streaming"

.field public static final MODULE_MMS:Ljava/lang/String; = "mms"

.field public static final MODULE_RTSP_STREAMING:Ljava/lang/String; = "rtsp_streaming"

.field public static final MODULE_SYSTEM:Ljava/lang/String; = "system"

.field public static final MODULE_WLAN:Ljava/lang/String; = "wlan"

.field public static final PROP_MODULE_MAX:I = 0x20

.field public static final PROP_NAME_MAX:I = 0x40

.field public static final RDS_VALUE:Ljava/lang/String; = "RDSValue"

.field public static final SSID:Ljava/lang/String; = "SSID"

.field public static final UAPROF_URL:Ljava/lang/String; = "UAProfileURL"

.field public static final USER_AGENT:Ljava/lang/String; = "UserAgent"

.field static mLoader:Ljava/lang/ClassLoader;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-string v0, "custom_jni"

    .line 137
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 138
    new-instance v0, Ldalvik/system/PathClassLoader;

    invoke-static {}, Ljava/lang/ClassLoader;->getSystemClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const-string v2, "/system/framework/CustomPropInterface.jar"

    invoke-direct {v0, v2, v1}, Ldalvik/system/PathClassLoader;-><init>(Ljava/lang/String;Ljava/lang/ClassLoader;)V

    sput-object v0, Lcom/mediatek/custom/CustomProperties;->mLoader:Ljava/lang/ClassLoader;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 43
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getString(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    const/4 v0, 0x0

    .line 150
    invoke-static {v0, p0, v0}, Lcom/mediatek/custom/CustomProperties;->getString(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    const/4 v0, 0x0

    .line 164
    invoke-static {p0, p1, v0}, Lcom/mediatek/custom/CustomProperties;->getString(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static getString(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    if-eqz p0, :cond_1

    .line 179
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x20

    if-gt v0, v1, :cond_0

    goto :goto_0

    .line 180
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "module.length >32"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    :goto_0
    if-eqz p1, :cond_2

    .line 182
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x40

    if-gt v0, v1, :cond_2

    .line 186
    invoke-static {p0, p1, p2}, Lcom/mediatek/custom/CustomProperties;->native_get_string(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 183
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "name.length > 64"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static loadInterface()Ljava/lang/Class;
    .locals 4

    .line 193
    :try_start_0
    sget-object v0, Lcom/mediatek/custom/CustomProperties;->mLoader:Ljava/lang/ClassLoader;

    const-string v1, "com.mediatek.custom.CustomPropInterface"

    invoke-virtual {v0, v1}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/ClassNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const/4 v1, 0x0

    .line 196
    invoke-virtual {v0}, Ljava/lang/ClassNotFoundException;->printStackTrace()V

    move-object v0, v1

    .line 199
    :goto_0
    sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[CustomProp]loadInterface->clazz:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    return-object v0
.end method

.method private static native native_get_string(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
.end method
