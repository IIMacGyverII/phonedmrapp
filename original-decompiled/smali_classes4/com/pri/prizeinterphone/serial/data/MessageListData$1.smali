.class Lcom/pri/prizeinterphone/serial/data/MessageListData$1;
.super Ljava/lang/Object;
.source "MessageListData.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/serial/data/MessageListData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/pri/prizeinterphone/serial/data/MessageListData;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/serial/data/MessageListData;
    .locals 0

    .line 25
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/MessageListData;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/serial/data/MessageListData;-><init>(Landroid/os/Parcel;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 22
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/MessageListData$1;->createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/serial/data/MessageListData;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/pri/prizeinterphone/serial/data/MessageListData;
    .locals 0

    .line 30
    new-array p0, p1, [Lcom/pri/prizeinterphone/serial/data/MessageListData;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 22
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/MessageListData$1;->newArray(I)[Lcom/pri/prizeinterphone/serial/data/MessageListData;

    move-result-object p0

    return-object p0
.end method
