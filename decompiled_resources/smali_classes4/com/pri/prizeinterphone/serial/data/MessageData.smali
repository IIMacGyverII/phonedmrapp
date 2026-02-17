.class public Lcom/pri/prizeinterphone/serial/data/MessageData;
.super Ljava/lang/Object;
.source "MessageData.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/serial/data/MessageData$SmsDirection;,
        Lcom/pri/prizeinterphone/serial/data/MessageData$SmsStatus;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/serial/data/MessageData;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field public content:Ljava/lang/String;

.field public convType:I

.field public conv_target:I

.field public direction:I

.field public from:I

.field public id:J

.field public status:I

.field public timestamp:J

.field public to:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 74
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/MessageData$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/MessageData$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/serial/data/MessageData;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>()V
    .locals 4

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-wide/16 v0, 0x0

    .line 25
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->id:J

    const/4 v2, 0x0

    .line 26
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    const/4 v3, 0x1

    .line 27
    iput v3, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    .line 28
    iput v3, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    .line 29
    iput v3, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    .line 31
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    .line 32
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    .line 33
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    return-void
.end method

.method public constructor <init>(JIIIILjava/lang/String;IJI)V
    .locals 0

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 36
    iput-wide p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->id:J

    .line 37
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    .line 38
    iput p4, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    .line 39
    iput p5, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    .line 40
    iput p6, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    .line 41
    iput-object p7, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->content:Ljava/lang/String;

    .line 42
    iput p8, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    .line 43
    iput-wide p9, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    .line 44
    iput p11, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 4

    .line 62
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-wide/16 v0, 0x0

    .line 25
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->id:J

    const/4 v2, 0x0

    .line 26
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    const/4 v3, 0x1

    .line 27
    iput v3, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    .line 28
    iput v3, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    .line 29
    iput v3, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    .line 31
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    .line 32
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    .line 33
    iput v2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    .line 63
    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->id:J

    .line 64
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    .line 65
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    .line 66
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    .line 67
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    .line 68
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->content:Ljava/lang/String;

    .line 69
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    .line 70
    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    .line 71
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result p1

    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getContent()Ljava/lang/String;
    .locals 0

    .line 119
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->content:Ljava/lang/String;

    return-object p0
.end method

.method public getConvType()I
    .locals 0

    .line 87
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    return p0
.end method

.method public getConv_target()I
    .locals 0

    .line 95
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    return p0
.end method

.method public getDirection()I
    .locals 0

    .line 143
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    return p0
.end method

.method public getFrom()I
    .locals 0

    .line 103
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    return p0
.end method

.method public getStatus()I
    .locals 0

    .line 127
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    return p0
.end method

.method public getTimestamp()J
    .locals 2

    .line 135
    iget-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    return-wide v0
.end method

.method public getTo()I
    .locals 0

    .line 111
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    return p0
.end method

.method public setContent(Ljava/lang/String;)V
    .locals 0

    .line 123
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->content:Ljava/lang/String;

    return-void
.end method

.method public setConvType(I)V
    .locals 0

    .line 91
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    return-void
.end method

.method public setConv_target(I)V
    .locals 0

    .line 99
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    return-void
.end method

.method public setDirection(I)V
    .locals 0

    .line 147
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    return-void
.end method

.method public setFrom(I)V
    .locals 0

    .line 107
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    return-void
.end method

.method public setStatus(I)V
    .locals 0

    .line 131
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    return-void
.end method

.method public setTimestamp(J)V
    .locals 0

    .line 139
    iput-wide p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    return-void
.end method

.method public setTo(I)V
    .locals 0

    .line 115
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 169
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "MessageData{id="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->id:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, ", convType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", conv_target="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", from="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", to="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", content=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->content:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, ", status="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", timestamp="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, ", direction="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 2

    .line 157
    iget-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->id:J

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    .line 158
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->convType:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 159
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->conv_target:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 160
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->from:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 161
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->to:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 162
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->content:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 163
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->status:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 164
    iget-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->timestamp:J

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    .line 165
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/MessageData;->direction:I

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeInt(I)V

    return-void
.end method
