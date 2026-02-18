.class Lcom/pri/prizeinterphone/serial/data/ConversationData$1;
.super Ljava/lang/Object;
.source "ConversationData.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/serial/data/ConversationData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/pri/prizeinterphone/serial/data/ConversationData;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 99
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/serial/data/ConversationData;
    .locals 0

    .line 102
    new-instance p0, Lcom/pri/prizeinterphone/serial/data/ConversationData;

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData;-><init>(Landroid/os/Parcel;)V

    return-object p0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 99
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData$1;->createFromParcel(Landroid/os/Parcel;)Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-result-object p0

    return-object p0
.end method

.method public newArray(I)[Lcom/pri/prizeinterphone/serial/data/ConversationData;
    .locals 0

    .line 107
    new-array p0, p1, [Lcom/pri/prizeinterphone/serial/data/ConversationData;

    return-object p0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 99
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/serial/data/ConversationData$1;->newArray(I)[Lcom/pri/prizeinterphone/serial/data/ConversationData;

    move-result-object p0

    return-object p0
.end method
