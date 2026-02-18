.class public Lcom/pri/prizeinterphone/config/data/InsertConfig;
.super Ljava/lang/Object;
.source "InsertConfig.java"

# interfaces
.implements Landroid/os/Parcelable;


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/config/data/InsertConfig;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private insertChannels:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/pri/prizeinterphone/config/data/InsertChannels;",
            ">;"
        }
    .end annotation
.end field

.field private localNumber:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 60
    new-instance v0, Lcom/pri/prizeinterphone/config/data/InsertConfig$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/data/InsertConfig$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 52
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->insertChannels:Landroid/util/SparseArray;

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 55
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 56
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->localNumber:I

    .line 57
    const-class v0, Lcom/pri/prizeinterphone/config/data/InsertChannels;

    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->readSparseArray(Ljava/lang/ClassLoader;)Landroid/util/SparseArray;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->insertChannels:Landroid/util/SparseArray;

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getInsertChannels()Landroid/util/SparseArray;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Landroid/util/SparseArray<",
            "Lcom/pri/prizeinterphone/config/data/InsertChannels;",
            ">;"
        }
    .end annotation

    .line 28
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->insertChannels:Landroid/util/SparseArray;

    return-object p0
.end method

.method public getLocalNumber()I
    .locals 0

    .line 20
    iget p0, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->localNumber:I

    return p0
.end method

.method public readFromParcel(Landroid/os/Parcel;)V
    .locals 1

    .line 47
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->localNumber:I

    .line 48
    const-class v0, Lcom/pri/prizeinterphone/config/data/InsertChannels;

    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->readSparseArray(Ljava/lang/ClassLoader;)Landroid/util/SparseArray;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->insertChannels:Landroid/util/SparseArray;

    return-void
.end method

.method public setInsertChannels(Landroid/util/SparseArray;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/util/SparseArray<",
            "Lcom/pri/prizeinterphone/config/data/InsertChannels;",
            ">;)V"
        }
    .end annotation

    .line 32
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->insertChannels:Landroid/util/SparseArray;

    return-void
.end method

.method public setLocalNumber(I)V
    .locals 0

    .line 24
    iput p1, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->localNumber:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 13
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "InsertConfig{localNumber="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->localNumber:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", insertChannels="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->insertChannels:Landroid/util/SparseArray;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 42
    iget p2, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->localNumber:I

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeInt(I)V

    .line 43
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertConfig;->insertChannels:Landroid/util/SparseArray;

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeSparseArray(Landroid/util/SparseArray;)V

    return-void
.end method
