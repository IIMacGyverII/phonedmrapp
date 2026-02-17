.class public Lcom/pri/prizeinterphone/data/MessageData;
.super Ljava/lang/Object;
.source "MessageData.java"

# interfaces
.implements Landroid/os/Parcelable;


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/data/MessageData;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field public isRecieve:I

.field public time:Ljava/lang/String;

.field public value:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 27
    new-instance v0, Lcom/pri/prizeinterphone/data/MessageData$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/data/MessageData$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/data/MessageData;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/data/MessageData;->time:Ljava/lang/String;

    .line 23
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/data/MessageData;->value:Ljava/lang/String;

    .line 24
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result p1

    iput p1, p0, Lcom/pri/prizeinterphone/data/MessageData;->isRecieve:I

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 16
    iput-object p1, p0, Lcom/pri/prizeinterphone/data/MessageData;->time:Ljava/lang/String;

    .line 17
    iput-object p2, p0, Lcom/pri/prizeinterphone/data/MessageData;->value:Ljava/lang/String;

    .line 18
    iput p3, p0, Lcom/pri/prizeinterphone/data/MessageData;->isRecieve:I

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getIsRecieve()Z
    .locals 1

    .line 60
    iget p0, p0, Lcom/pri/prizeinterphone/data/MessageData;->isRecieve:I

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public getTime()Ljava/lang/String;
    .locals 0

    .line 44
    iget-object p0, p0, Lcom/pri/prizeinterphone/data/MessageData;->time:Ljava/lang/String;

    return-object p0
.end method

.method public getValue()Ljava/lang/String;
    .locals 0

    .line 52
    iget-object p0, p0, Lcom/pri/prizeinterphone/data/MessageData;->value:Ljava/lang/String;

    return-object p0
.end method

.method public setIsRecieve(I)V
    .locals 0

    .line 56
    iput p1, p0, Lcom/pri/prizeinterphone/data/MessageData;->isRecieve:I

    return-void
.end method

.method public setTime(Ljava/lang/String;)V
    .locals 0

    .line 40
    iput-object p1, p0, Lcom/pri/prizeinterphone/data/MessageData;->time:Ljava/lang/String;

    return-void
.end method

.method public setValue(Ljava/lang/String;)V
    .locals 0

    .line 48
    iput-object p1, p0, Lcom/pri/prizeinterphone/data/MessageData;->value:Ljava/lang/String;

    return-void
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 71
    iget-object p2, p0, Lcom/pri/prizeinterphone/data/MessageData;->time:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 72
    iget-object p2, p0, Lcom/pri/prizeinterphone/data/MessageData;->value:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 73
    iget p0, p0, Lcom/pri/prizeinterphone/data/MessageData;->isRecieve:I

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeInt(I)V

    return-void
.end method
