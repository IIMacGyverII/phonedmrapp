.class public Lcom/pri/prizeinterphone/serial/data/ContactData;
.super Ljava/lang/Object;
.source "ContactData.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/serial/data/ContactData$ContactType;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/serial/data/ContactData;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field public _id:I

.field public active:I

.field public bitmap:Landroid/graphics/Bitmap;

.field public name:Ljava/lang/String;

.field public number:Ljava/lang/String;

.field public type:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 106
    new-instance v0, Lcom/pri/prizeinterphone/serial/data/ContactData$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/serial/data/ContactData$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/serial/data/ContactData;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 15
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    .line 18
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    return-void
.end method

.method public constructor <init>(IILjava/lang/String;Ljava/lang/String;ILandroid/graphics/Bitmap;)V
    .locals 0

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 26
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->_id:I

    .line 27
    iput-object p3, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->name:Ljava/lang/String;

    .line 28
    iput-object p6, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    .line 29
    iput-object p4, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->number:Ljava/lang/String;

    .line 30
    iput p2, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    .line 31
    iput p5, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 82
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 15
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    .line 18
    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    .line 83
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->_id:I

    .line 84
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    .line 85
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->name:Ljava/lang/String;

    .line 86
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->number:Ljava/lang/String;

    .line 87
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    .line 88
    const-class v0, Landroid/graphics/Bitmap;

    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->readParcelable(Ljava/lang/ClassLoader;)Landroid/os/Parcelable;

    move-result-object p1

    check-cast p1, Landroid/graphics/Bitmap;

    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getActive()I
    .locals 0

    .line 75
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    return p0
.end method

.method public getBitmap()Landroid/graphics/Bitmap;
    .locals 0

    .line 51
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    return-object p0
.end method

.method public getId()I
    .locals 0

    .line 35
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->_id:I

    return p0
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    .line 43
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->name:Ljava/lang/String;

    return-object p0
.end method

.method public getNumber()Ljava/lang/String;
    .locals 0

    .line 59
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->number:Ljava/lang/String;

    return-object p0
.end method

.method public getType()I
    .locals 0

    .line 67
    iget p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    return p0
.end method

.method public setActive(I)V
    .locals 0

    .line 79
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    return-void
.end method

.method public setBitmap(Landroid/graphics/Bitmap;)V
    .locals 0

    .line 55
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    return-void
.end method

.method public setId(I)V
    .locals 0

    .line 39
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->_id:I

    return-void
.end method

.method public setName(Ljava/lang/String;)V
    .locals 0

    .line 47
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->name:Ljava/lang/String;

    return-void
.end method

.method public setNumber(Ljava/lang/String;)V
    .locals 0

    .line 63
    iput-object p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->number:Ljava/lang/String;

    return-void
.end method

.method public setType(I)V
    .locals 0

    .line 71
    iput p1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 119
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ContactData{id=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->_id:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", type="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", name=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->name:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", number=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->number:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, ", active="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", bitmap="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 1

    .line 98
    iget v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->_id:I

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 99
    iget v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->type:I

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 100
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->name:Ljava/lang/String;

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 101
    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->number:Ljava/lang/String;

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 102
    iget v0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->active:I

    invoke-virtual {p1, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 103
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/data/ContactData;->bitmap:Landroid/graphics/Bitmap;

    invoke-virtual {p1, p0, p2}, Landroid/os/Parcel;->writeParcelable(Landroid/os/Parcelable;I)V

    return-void
.end method
