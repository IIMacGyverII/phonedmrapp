.class public Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
.super Ljava/lang/Object;
.source "YModem.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/ymodem/YModem;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Builder"
.end annotation


# instance fields
.field private context:Landroid/content/Context;

.field private fileMd5String:Ljava/lang/String;

.field private fileNameString:Ljava/lang/String;

.field private filePath:Ljava/lang/String;

.field private listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

.field private size:Ljava/lang/Integer;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 359
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public build()Lcom/pri/prizeinterphone/ymodem/YModem;
    .locals 9

    .line 398
    new-instance v8, Lcom/pri/prizeinterphone/ymodem/YModem;

    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->context:Landroid/content/Context;

    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->filePath:Ljava/lang/String;

    iget-object v3, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->fileNameString:Ljava/lang/String;

    iget-object v4, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->fileMd5String:Ljava/lang/String;

    iget-object v5, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->size:Ljava/lang/Integer;

    iget-object v6, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    const/4 v7, 0x0

    move-object v0, v8

    invoke-direct/range {v0 .. v7}, Lcom/pri/prizeinterphone/ymodem/YModem;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Lcom/pri/prizeinterphone/ymodem/YModemListener;Lcom/pri/prizeinterphone/ymodem/YModem-IA;)V

    return-object v8
.end method

.method public callback(Lcom/pri/prizeinterphone/ymodem/YModemListener;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
    .locals 0

    .line 393
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->listener:Lcom/pri/prizeinterphone/ymodem/YModemListener;

    return-object p0
.end method

.method public checkMd5(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
    .locals 0

    .line 388
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->fileMd5String:Ljava/lang/String;

    return-object p0
.end method

.method public fileName(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
    .locals 0

    .line 378
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->fileNameString:Ljava/lang/String;

    return-object p0
.end method

.method public filePath(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
    .locals 0

    .line 373
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->filePath:Ljava/lang/String;

    return-object p0
.end method

.method public sendSize(Ljava/lang/Integer;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
    .locals 0

    .line 383
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->size:Ljava/lang/Integer;

    return-object p0
.end method

.method public with(Landroid/content/Context;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;
    .locals 0

    .line 368
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->context:Landroid/content/Context;

    return-object p0
.end method
