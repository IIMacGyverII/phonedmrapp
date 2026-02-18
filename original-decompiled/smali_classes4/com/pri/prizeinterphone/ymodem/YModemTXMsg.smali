.class public Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;
.super Ljava/lang/Object;
.source "YModemTXMsg.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$YModemTXMsgBuilder;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private currentSent:I

.field private step:I

.field private total:I


# direct methods
.method static bridge synthetic -$$Nest$fputcurrentSent(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->currentSent:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputstep(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->step:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputtotal(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;I)V
    .locals 0

    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->total:I

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 51
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 42
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 46
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->step:I

    .line 47
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->currentSent:I

    .line 48
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result p1

    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->total:I

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/ymodem/YModemTXMsg-IA;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;-><init>()V

    return-void
.end method

.method public static step2Str(I)Ljava/lang/String;
    .locals 1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_5

    const/4 v0, 0x4

    if-eq p0, v0, :cond_4

    const/16 v0, 0x8

    if-eq p0, v0, :cond_3

    const/16 v0, 0x10

    if-eq p0, v0, :cond_2

    const/16 v0, 0x20

    if-eq p0, v0, :cond_1

    const/16 v0, 0x40

    if-eq p0, v0, :cond_0

    const-string p0, "STEP_UNKNOWN"

    return-object p0

    :cond_0
    const-string p0, "STEP_ERROR"

    return-object p0

    :cond_1
    const-string p0, "STEP_END"

    return-object p0

    :cond_2
    const-string p0, "STEP_EOT"

    return-object p0

    :cond_3
    const-string p0, "STEP_FILE_BODY"

    return-object p0

    :cond_4
    const-string p0, "STEP_FILE_NAME"

    return-object p0

    :cond_5
    const-string p0, "STEP_HELLO"

    return-object p0
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getCurrentSent()I
    .locals 0

    .line 22
    iget p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->currentSent:I

    return p0
.end method

.method public getStep()I
    .locals 0

    .line 18
    iget p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->step:I

    return p0
.end method

.method public getTotal()I
    .locals 0

    .line 26
    iget p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->total:I

    return p0
.end method

.method public readFromParcel(Landroid/os/Parcel;)V
    .locals 1

    .line 37
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->step:I

    .line 38
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->currentSent:I

    .line 39
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result p1

    iput p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->total:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 101
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "YModemTXMsg{step="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->step:I

    .line 102
    invoke-static {v1}, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->step2Str(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", currentSent="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->currentSent:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", total="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->total:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 31
    iget p2, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->step:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 32
    iget p2, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->currentSent:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 33
    iget p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemTXMsg;->total:I

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeInt(I)V

    return-void
.end method
