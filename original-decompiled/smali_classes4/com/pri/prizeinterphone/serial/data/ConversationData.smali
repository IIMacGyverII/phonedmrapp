.class public Lcom/pri/prizeinterphone/serial/data/ConversationData;
.super Ljava/lang/Object;
.source "ConversationData.java"

# interfaces
.implements Landroid/os/Parcelable;


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field _id:I

.field convTarget:I

.field convType:I

.field name:Ljava/lang/String;

.field timestamp:Ljava/lang/Long;

.field unReadCount:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 99
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/ConversationData$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/ConversationData$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 8
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    .line 9
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    .line 10
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    const-string v1, ""

    .line 11
    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    const-wide/16 v1, 0x0

    .line 12
    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    .line 13
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    return-void
.end method

.method public constructor <init>(IIILjava/lang/String;Ljava/lang/Long;I)V
    .locals 1

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 8
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    .line 9
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    .line 10
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    const-string v0, ""

    .line 11
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    .line 19
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    .line 20
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    .line 21
    iput p3, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    .line 22
    iput-object p4, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    .line 23
    iput-object p5, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    .line 24
    iput p6, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 3

    .line 90
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 8
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    .line 9
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    .line 10
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    const-string v1, ""

    .line 11
    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    const-wide/16 v1, 0x0

    .line 12
    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    iput-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    .line 13
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    .line 91
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    .line 92
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    .line 93
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    .line 94
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    .line 95
    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    .line 96
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result p1

    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getConvTarget()I
    .locals 0

    .line 44
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    return p0
.end method

.method public getConvType()I
    .locals 0

    .line 36
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    return p0
.end method

.method public getId()I
    .locals 0

    .line 28
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    return p0
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    .line 52
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    return-object p0
.end method

.method public getTimestamp()Ljava/lang/Long;
    .locals 0

    .line 60
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    return-object p0
.end method

.method public getUnReadCount()I
    .locals 0

    .line 68
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    return p0
.end method

.method public setConvTarget(I)V
    .locals 0

    .line 48
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    return-void
.end method

.method public setConvType(I)V
    .locals 0

    .line 40
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    return-void
.end method

.method public setId(I)V
    .locals 0

    .line 32
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    return-void
.end method

.method public setName(Ljava/lang/String;)V
    .locals 0

    .line 56
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    return-void
.end method

.method public setTimestamp(Ljava/lang/Long;)V
    .locals 0

    .line 64
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    return-void
.end method

.method public setUnReadCount(I)V
    .locals 0

    .line 72
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 113
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ConversationData{_id="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", convType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", convTarget="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", name=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, ", timestamp="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", unReadCount="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 2

    .line 82
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->_id:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 83
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convType:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 84
    iget p2, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->convTarget:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 85
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->name:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 86
    iget-object p2, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->timestamp:Ljava/lang/Long;

    invoke-virtual {p2}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    invoke-virtual {p1, v0, v1}, Landroid/os/Parcel;->writeLong(J)V

    .line 87
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;->unReadCount:I

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeInt(I)V

    return-void
.end method
