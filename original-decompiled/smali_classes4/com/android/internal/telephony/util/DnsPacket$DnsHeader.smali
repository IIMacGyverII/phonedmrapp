.class public Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;
.super Ljava/lang/Object;
.source "DnsPacket.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/util/DnsPacket;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "DnsHeader"
.end annotation


# static fields
.field private static final FLAGS_SECTION_QR_BIT:I = 0xf

.field private static final TAG:Ljava/lang/String; = "DnsHeader"


# instance fields
.field public final flags:I

.field public final id:I

.field private final mRecordCount:[I

.field public final rcode:I

.field final synthetic this$0:Lcom/android/internal/telephony/util/DnsPacket;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/util/DnsPacket;Ljava/nio/ByteBuffer;)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/nio/BufferUnderflowException;
        }
    .end annotation

    .line 76
    iput-object p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->this$0:Lcom/android/internal/telephony/util/DnsPacket;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 77
    invoke-virtual {p2}, Ljava/nio/ByteBuffer;->getShort()S

    move-result p1

    invoke-static {p1}, Ljava/lang/Short;->toUnsignedInt(S)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->id:I

    .line 78
    invoke-virtual {p2}, Ljava/nio/ByteBuffer;->getShort()S

    move-result p1

    invoke-static {p1}, Ljava/lang/Short;->toUnsignedInt(S)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->flags:I

    and-int/lit8 p1, p1, 0xf

    .line 79
    iput p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->rcode:I

    const/4 p1, 0x4

    new-array v0, p1, [I

    .line 80
    iput-object v0, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->mRecordCount:[I

    const/4 v0, 0x0

    :goto_0
    if-ge v0, p1, :cond_0

    .line 82
    iget-object v1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->mRecordCount:[I

    invoke-virtual {p2}, Ljava/nio/ByteBuffer;->getShort()S

    move-result v2

    invoke-static {v2}, Ljava/lang/Short;->toUnsignedInt(S)I

    move-result v2

    aput v2, v1, v0

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method


# virtual methods
.method public getRecordCount(I)I
    .locals 0

    .line 98
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->mRecordCount:[I

    aget p0, p0, p1

    return p0
.end method

.method public isResponse()Z
    .locals 1

    .line 91
    iget p0, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsHeader;->flags:I

    const v0, 0x8000

    and-int/2addr p0, v0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
