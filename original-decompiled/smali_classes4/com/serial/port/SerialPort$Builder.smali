.class public final Lcom/serial/port/SerialPort$Builder;
.super Ljava/lang/Object;
.source "SerialPort.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/serial/port/SerialPort;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation


# instance fields
.field private baudrate:I

.field private dataBits:I

.field private device:Ljava/io/File;

.field private flags:I

.field private parity:I

.field private stopBits:I


# direct methods
.method private constructor <init>(Ljava/io/File;I)V
    .locals 2

    .line 329
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x8

    .line 324
    iput v0, p0, Lcom/serial/port/SerialPort$Builder;->dataBits:I

    const/4 v0, 0x0

    .line 325
    iput v0, p0, Lcom/serial/port/SerialPort$Builder;->parity:I

    const/4 v1, 0x1

    .line 326
    iput v1, p0, Lcom/serial/port/SerialPort$Builder;->stopBits:I

    .line 327
    iput v0, p0, Lcom/serial/port/SerialPort$Builder;->flags:I

    .line 330
    iput-object p1, p0, Lcom/serial/port/SerialPort$Builder;->device:Ljava/io/File;

    .line 331
    iput p2, p0, Lcom/serial/port/SerialPort$Builder;->baudrate:I

    return-void
.end method

.method synthetic constructor <init>(Ljava/io/File;ILcom/serial/port/SerialPort$Builder-IA;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/serial/port/SerialPort$Builder;-><init>(Ljava/io/File;I)V

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 1

    .line 335
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-direct {p0, v0, p2}, Lcom/serial/port/SerialPort$Builder;-><init>(Ljava/io/File;I)V

    return-void
.end method

.method synthetic constructor <init>(Ljava/lang/String;ILcom/serial/port/SerialPort$Builder-IA;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/serial/port/SerialPort$Builder;-><init>(Ljava/lang/String;I)V

    return-void
.end method


# virtual methods
.method public build()Lcom/serial/port/SerialPort;
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/SecurityException;,
            Ljava/io/IOException;
        }
    .end annotation

    .line 390
    new-instance v7, Lcom/serial/port/SerialPort;

    iget-object v1, p0, Lcom/serial/port/SerialPort$Builder;->device:Ljava/io/File;

    iget v2, p0, Lcom/serial/port/SerialPort$Builder;->baudrate:I

    iget v3, p0, Lcom/serial/port/SerialPort$Builder;->dataBits:I

    iget v4, p0, Lcom/serial/port/SerialPort$Builder;->parity:I

    iget v5, p0, Lcom/serial/port/SerialPort$Builder;->stopBits:I

    iget v6, p0, Lcom/serial/port/SerialPort$Builder;->flags:I

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Lcom/serial/port/SerialPort;-><init>(Ljava/io/File;IIIII)V

    return-object v7
.end method

.method public dataBits(I)Lcom/serial/port/SerialPort$Builder;
    .locals 0

    .line 345
    iput p1, p0, Lcom/serial/port/SerialPort$Builder;->dataBits:I

    return-object p0
.end method

.method public flags(I)Lcom/serial/port/SerialPort$Builder;
    .locals 0

    .line 378
    iput p1, p0, Lcom/serial/port/SerialPort$Builder;->flags:I

    return-object p0
.end method

.method public parity(I)Lcom/serial/port/SerialPort$Builder;
    .locals 0

    .line 356
    iput p1, p0, Lcom/serial/port/SerialPort$Builder;->parity:I

    return-object p0
.end method

.method public stopBits(I)Lcom/serial/port/SerialPort$Builder;
    .locals 0

    .line 367
    iput p1, p0, Lcom/serial/port/SerialPort$Builder;->stopBits:I

    return-object p0
.end method
