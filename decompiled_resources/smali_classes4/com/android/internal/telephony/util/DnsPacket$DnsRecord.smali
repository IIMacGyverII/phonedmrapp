.class public Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;
.super Ljava/lang/Object;
.source "DnsPacket.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/util/DnsPacket;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "DnsRecord"
.end annotation


# static fields
.field private static final MAXNAMESIZE:I = 0xff

.field public static final NAME_COMPRESSION:I = 0xc0

.field public static final NAME_NORMAL:I = 0x0

.field private static final TAG:Ljava/lang/String; = "DnsRecord"


# instance fields
.field public final dName:Ljava/lang/String;

.field private final mRdata:[B

.field public final nsClass:I

.field public final nsType:I

.field final synthetic this$0:Lcom/android/internal/telephony/util/DnsPacket;

.field public final ttl:J


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/util/DnsPacket;ILjava/nio/ByteBuffer;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/nio/BufferUnderflowException;,
            Lcom/android/internal/telephony/util/DnsPacket$ParseException;
        }
    .end annotation

    .line 133
    iput-object p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->this$0:Lcom/android/internal/telephony/util/DnsPacket;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 p1, 0x0

    const/4 v0, 0x1

    .line 134
    invoke-static {p3, p1, v0}, Lcom/android/internal/telephony/util/DnsPacketUtils$DnsRecordParser;->parseName(Ljava/nio/ByteBuffer;IZ)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->dName:Ljava/lang/String;

    .line 136
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0xff

    if-gt v0, v1, :cond_1

    .line 140
    invoke-virtual {p3}, Ljava/nio/ByteBuffer;->getShort()S

    move-result p1

    invoke-static {p1}, Ljava/lang/Short;->toUnsignedInt(S)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->nsType:I

    .line 141
    invoke-virtual {p3}, Ljava/nio/ByteBuffer;->getShort()S

    move-result p1

    invoke-static {p1}, Ljava/lang/Short;->toUnsignedInt(S)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->nsClass:I

    if-eqz p2, :cond_0

    .line 144
    invoke-virtual {p3}, Ljava/nio/ByteBuffer;->getInt()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->toUnsignedLong(I)J

    move-result-wide p1

    iput-wide p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->ttl:J

    .line 145
    invoke-virtual {p3}, Ljava/nio/ByteBuffer;->getShort()S

    move-result p1

    invoke-static {p1}, Ljava/lang/Short;->toUnsignedInt(S)I

    move-result p1

    .line 146
    new-array p1, p1, [B

    iput-object p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->mRdata:[B

    .line 147
    invoke-virtual {p3, p1}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    goto :goto_0

    :cond_0
    const-wide/16 p1, 0x0

    .line 149
    iput-wide p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->ttl:J

    const/4 p1, 0x0

    .line 150
    iput-object p1, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->mRdata:[B

    :goto_0
    return-void

    .line 137
    :cond_1
    new-instance p0, Lcom/android/internal/telephony/util/DnsPacket$ParseException;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Parse name fail, name size is too long: "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 138
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/util/DnsPacket$ParseException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public getRR()[B
    .locals 0

    .line 159
    iget-object p0, p0, Lcom/android/internal/telephony/util/DnsPacket$DnsRecord;->mRdata:[B

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, [B->clone()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [B

    :goto_0
    return-object p0
.end method
