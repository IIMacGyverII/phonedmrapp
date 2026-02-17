.class public Lcom/pri/prizeinterphone/serial/data/AudioRecordData;
.super Ljava/lang/Object;
.source "AudioRecordData.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/serial/data/AudioRecordData$SmsDirection;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/serial/data/AudioRecordData;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field public channelName:Ljava/lang/String;

.field public direction:I

.field public filePath:Ljava/lang/String;

.field public id:J

.field public isplay:Z

.field public name:Ljava/lang/String;

.field public timestamp:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 43
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/AudioRecordData$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-wide/16 v0, 0x0

    .line 8
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    const-string v2, ""

    .line 9
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    .line 10
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    .line 11
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    const/4 v0, 0x0

    .line 12
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    .line 13
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    .line 14
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->isplay:Z

    return-void
.end method

.method public constructor <init>(JLjava/lang/String;Ljava/lang/String;JILjava/lang/String;)V
    .locals 1

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 14
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->isplay:Z

    .line 17
    iput-wide p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    .line 18
    iput-object p3, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    .line 19
    iput-object p4, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    .line 20
    iput-wide p5, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    .line 21
    iput p7, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    .line 22
    iput-object p8, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 3

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-wide/16 v0, 0x0

    .line 8
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    const-string v2, ""

    .line 9
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    .line 10
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    .line 11
    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    const/4 v0, 0x0

    .line 12
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    .line 13
    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    .line 14
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->isplay:Z

    .line 35
    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    .line 36
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    .line 37
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    .line 38
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    int-to-long v0, v0

    iput-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    .line 39
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    .line 40
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getChannelName()Ljava/lang/String;
    .locals 0

    .line 88
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    return-object p0
.end method

.method public getDirection()I
    .locals 0

    .line 104
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    return p0
.end method

.method public getFilePath()Ljava/lang/String;
    .locals 0

    .line 112
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    return-object p0
.end method

.method public getId()J
    .locals 2

    .line 72
    iget-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    return-wide v0
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    .line 80
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    return-object p0
.end method

.method public getTimestamp()J
    .locals 2

    .line 96
    iget-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    return-wide v0
.end method

.method public isIsplay()Z
    .locals 0

    .line 120
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->isplay:Z

    return p0
.end method

.method public setChannelName(Ljava/lang/String;)V
    .locals 0

    .line 92
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    return-void
.end method

.method public setDirection(I)V
    .locals 0

    .line 108
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    return-void
.end method

.method public setFilePath(Ljava/lang/String;)V
    .locals 0

    .line 116
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    return-void
.end method

.method public setId(J)V
    .locals 0

    .line 76
    iput-wide p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    return-void
.end method

.method public setIsplay(Z)V
    .locals 0

    .line 124
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->isplay:Z

    return-void
.end method

.method public setName(Ljava/lang/String;)V
    .locals 0

    .line 84
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    return-void
.end method

.method public setTimestamp(J)V
    .locals 0

    .line 100
    iput-wide p1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    .line 129
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "AudioRecordData{id="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, ", name=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", channelName=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", timestamp="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, ", direction="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", filePath=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 2

    .line 62
    iget-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->id:J

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    .line 63
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->name:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 64
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->channelName:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 65
    iget-wide v0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->timestamp:J

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    .line 66
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->direction:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 67
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/AudioRecordData;->filePath:Ljava/lang/String;

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    return-void
.end method
