.class public Lcom/android/internal/telephony/util/InetAddressUtils;
.super Ljava/lang/Object;
.source "InetAddressUtils.java"


# static fields
.field private static final INET6_ADDR_LENGTH:I = 0x10


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 74
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static parcelInetAddress(Landroid/os/Parcel;Ljava/net/InetAddress;I)V
    .locals 0

    if-eqz p1, :cond_0

    .line 39
    invoke-virtual {p1}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p2

    goto :goto_0

    :cond_0
    const/4 p2, 0x0

    .line 40
    :goto_0
    invoke-virtual {p0, p2}, Landroid/os/Parcel;->writeByteArray([B)V

    .line 41
    instance-of p2, p1, Ljava/net/Inet6Address;

    if-eqz p2, :cond_2

    .line 42
    check-cast p1, Ljava/net/Inet6Address;

    .line 43
    invoke-virtual {p1}, Ljava/net/Inet6Address;->getScopeId()I

    move-result p2

    if-eqz p2, :cond_1

    const/4 p2, 0x1

    goto :goto_1

    :cond_1
    const/4 p2, 0x0

    .line 44
    :goto_1
    invoke-virtual {p0, p2}, Landroid/os/Parcel;->writeBoolean(Z)V

    if-eqz p2, :cond_2

    .line 45
    invoke-virtual {p1}, Ljava/net/Inet6Address;->getScopeId()I

    move-result p1

    invoke-virtual {p0, p1}, Landroid/os/Parcel;->writeInt(I)V

    :cond_2
    return-void
.end method

.method public static unparcelInetAddress(Landroid/os/Parcel;)Ljava/net/InetAddress;
    .locals 4

    .line 56
    invoke-virtual {p0}, Landroid/os/Parcel;->createByteArray()[B

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 62
    :cond_0
    :try_start_0
    array-length v2, v0

    const/16 v3, 0x10

    if-ne v2, v3, :cond_2

    .line 63
    invoke-virtual {p0}, Landroid/os/Parcel;->readBoolean()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 64
    invoke-virtual {p0}, Landroid/os/Parcel;->readInt()I

    move-result p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    .line 65
    :goto_0
    invoke-static {v1, v0, p0}, Ljava/net/Inet6Address;->getByAddress(Ljava/lang/String;[BI)Ljava/net/Inet6Address;

    move-result-object p0

    return-object p0

    .line 68
    :cond_2
    invoke-static {v0}, Ljava/net/InetAddress;->getByAddress([B)Ljava/net/InetAddress;

    move-result-object p0
    :try_end_0
    .catch Ljava/net/UnknownHostException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    return-object v1
.end method
