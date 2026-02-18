.class public Lcom/pri/prizeinterphone/config/data/InsertChannel;
.super Ljava/lang/Object;
.source "InsertChannel.java"

# interfaces
.implements Landroid/os/Parcelable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;
    }
.end annotation


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/pri/prizeinterphone/config/data/InsertChannel;",
            ">;"
        }
    .end annotation
.end field

.field private static final TAG:Ljava/lang/String; = "InsertChannel"


# instance fields
.field private band:Ljava/lang/String;

.field protected channeltype:Ljava/lang/String;

.field private colorcode:Ljava/lang/String;

.field private contactype:Ljava/lang/String;

.field private encryptSwitch:Ljava/lang/String;

.field private encryptText:Ljava/lang/String;

.field private groupvalue:Ljava/lang/String;

.field protected name:Ljava/lang/String;

.field private number:Ljava/lang/String;

.field protected power:Ljava/lang/String;

.field private recGroup:Ljava/lang/String;

.field protected recfreq:Ljava/lang/String;

.field private recvsubaudiofreq:Ljava/lang/String;

.field private recvsubaudiotype:Ljava/lang/String;

.field protected sendfreq:Ljava/lang/String;

.field private sendsubaudiofreq:Ljava/lang/String;

.field private sendsubaudiotype:Ljava/lang/String;

.field private slotmode:Ljava/lang/String;

.field private squelchlevel:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 404
    new-instance v0, Lcom/pri/prizeinterphone/config/data/InsertChannel$1;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel$1;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method protected constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 380
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 381
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->name:Ljava/lang/String;

    .line 382
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendfreq:Ljava/lang/String;

    .line 383
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recfreq:Ljava/lang/String;

    .line 384
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->channeltype:Ljava/lang/String;

    .line 385
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->power:Ljava/lang/String;

    .line 386
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->band:Ljava/lang/String;

    .line 387
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->squelchlevel:Ljava/lang/String;

    .line 388
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiotype:Ljava/lang/String;

    .line 389
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiotype:Ljava/lang/String;

    .line 390
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->colorcode:Ljava/lang/String;

    .line 391
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->slotmode:Ljava/lang/String;

    .line 392
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->contactype:Ljava/lang/String;

    .line 393
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptSwitch:Ljava/lang/String;

    .line 394
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptText:Ljava/lang/String;

    .line 395
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->groupvalue:Ljava/lang/String;

    .line 398
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiofreq:Ljava/lang/String;

    .line 399
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiofreq:Ljava/lang/String;

    .line 400
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->number:Ljava/lang/String;

    .line 401
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recGroup:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)V
    .locals 1

    .line 160
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 161
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetname(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->name:Ljava/lang/String;

    .line 162
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetsendfreq(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendfreq:Ljava/lang/String;

    .line 163
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetrecfreq(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recfreq:Ljava/lang/String;

    .line 164
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetchanneltype(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->channeltype:Ljava/lang/String;

    .line 165
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetpower(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->power:Ljava/lang/String;

    .line 167
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetband(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->band:Ljava/lang/String;

    .line 168
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetsquelchlevel(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->squelchlevel:Ljava/lang/String;

    .line 169
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetrecvsubaudiotype(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiotype:Ljava/lang/String;

    .line 170
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetsendsubaudiotype(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiotype:Ljava/lang/String;

    .line 173
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetcolorcode(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->colorcode:Ljava/lang/String;

    .line 174
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetslotmode(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->slotmode:Ljava/lang/String;

    .line 175
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetcontactype(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->contactype:Ljava/lang/String;

    .line 176
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetencryptSwitch(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptSwitch:Ljava/lang/String;

    .line 177
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetencryptText(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptText:Ljava/lang/String;

    .line 178
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetgroupvalue(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->groupvalue:Ljava/lang/String;

    .line 181
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetrecvsubaudiofreq(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->setRecvsubaudiofreq(Ljava/lang/String;)V

    .line 182
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetsendsubaudiofreq(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->setSendsubaudiofreq(Ljava/lang/String;)V

    .line 184
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetrecvsubaudiofreq(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiofreq:Ljava/lang/String;

    .line 185
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetsendsubaudiofreq(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiofreq:Ljava/lang/String;

    .line 188
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetnumber(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->setNumber(Ljava/lang/String;)V

    .line 189
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetnumber(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->number:Ljava/lang/String;

    .line 190
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetrecGroup(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/config/data/InsertChannel;->setRecGroup(Ljava/lang/String;)V

    .line 191
    invoke-static {p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;->-$$Nest$fgetrecGroup(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recGroup:Ljava/lang/String;

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;Lcom/pri/prizeinterphone/config/data/InsertChannel-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/config/data/InsertChannel;-><init>(Lcom/pri/prizeinterphone/config/data/InsertChannel$Builder;)V

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public getBand()Ljava/lang/String;
    .locals 0

    .line 62
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->band:Ljava/lang/String;

    return-object p0
.end method

.method public getChanneltype()Ljava/lang/String;
    .locals 0

    .line 54
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->channeltype:Ljava/lang/String;

    return-object p0
.end method

.method public getColorcode()Ljava/lang/String;
    .locals 0

    .line 78
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->colorcode:Ljava/lang/String;

    return-object p0
.end method

.method public getContactype()Ljava/lang/String;
    .locals 0

    .line 86
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->contactype:Ljava/lang/String;

    return-object p0
.end method

.method public getEncryptSwitch()Ljava/lang/String;
    .locals 0

    .line 90
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptSwitch:Ljava/lang/String;

    return-object p0
.end method

.method public getEncryptText()Ljava/lang/String;
    .locals 0

    .line 94
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptText:Ljava/lang/String;

    return-object p0
.end method

.method public getGroupvalue()Ljava/lang/String;
    .locals 0

    .line 98
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->groupvalue:Ljava/lang/String;

    return-object p0
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->name:Ljava/lang/String;

    return-object p0
.end method

.method public getNumber()Ljava/lang/String;
    .locals 0

    .line 124
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->number:Ljava/lang/String;

    return-object p0
.end method

.method public getPower()Ljava/lang/String;
    .locals 0

    .line 58
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->power:Ljava/lang/String;

    return-object p0
.end method

.method public getRecGroup()Ljava/lang/String;
    .locals 0

    .line 128
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recGroup:Ljava/lang/String;

    return-object p0
.end method

.method public getRecfreq()Ljava/lang/String;
    .locals 0

    .line 50
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recfreq:Ljava/lang/String;

    return-object p0
.end method

.method public getRecvsubaudiofreq()Ljava/lang/String;
    .locals 0

    .line 111
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiofreq:Ljava/lang/String;

    return-object p0
.end method

.method public getRecvsubaudiotype()Ljava/lang/String;
    .locals 0

    .line 70
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiotype:Ljava/lang/String;

    return-object p0
.end method

.method public getSendfreq()Ljava/lang/String;
    .locals 0

    .line 46
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendfreq:Ljava/lang/String;

    return-object p0
.end method

.method public getSendsubaudiofreq()Ljava/lang/String;
    .locals 0

    .line 115
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiofreq:Ljava/lang/String;

    return-object p0
.end method

.method public getSendsubaudiotype()Ljava/lang/String;
    .locals 0

    .line 74
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiotype:Ljava/lang/String;

    return-object p0
.end method

.method public getSlotmode()Ljava/lang/String;
    .locals 0

    .line 82
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->slotmode:Ljava/lang/String;

    return-object p0
.end method

.method public getSquelchlevel()Ljava/lang/String;
    .locals 0

    .line 66
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->squelchlevel:Ljava/lang/String;

    return-object p0
.end method

.method public readFromParcel(Landroid/os/Parcel;)V
    .locals 1

    .line 357
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->name:Ljava/lang/String;

    .line 358
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendfreq:Ljava/lang/String;

    .line 359
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recfreq:Ljava/lang/String;

    .line 360
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->channeltype:Ljava/lang/String;

    .line 361
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->power:Ljava/lang/String;

    .line 362
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->band:Ljava/lang/String;

    .line 363
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->squelchlevel:Ljava/lang/String;

    .line 364
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiotype:Ljava/lang/String;

    .line 365
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiotype:Ljava/lang/String;

    .line 366
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->colorcode:Ljava/lang/String;

    .line 367
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->slotmode:Ljava/lang/String;

    .line 368
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->contactype:Ljava/lang/String;

    .line 369
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptSwitch:Ljava/lang/String;

    .line 370
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptText:Ljava/lang/String;

    .line 371
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->groupvalue:Ljava/lang/String;

    .line 374
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiofreq:Ljava/lang/String;

    .line 375
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiofreq:Ljava/lang/String;

    .line 376
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->number:Ljava/lang/String;

    .line 377
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recGroup:Ljava/lang/String;

    return-void
.end method

.method public setNumber(Ljava/lang/String;)V
    .locals 0

    .line 120
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->number:Ljava/lang/String;

    return-void
.end method

.method public setRecGroup(Ljava/lang/String;)V
    .locals 0

    .line 132
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recGroup:Ljava/lang/String;

    return-void
.end method

.method public setRecvsubaudiofreq(Ljava/lang/String;)V
    .locals 0

    .line 103
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiofreq:Ljava/lang/String;

    return-void
.end method

.method public setSendsubaudiofreq(Ljava/lang/String;)V
    .locals 0

    .line 107
    iput-object p1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiofreq:Ljava/lang/String;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 137
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "InsertChannel{name=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", sendfreq=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendfreq:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", recfreq=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recfreq:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", channeltype=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->channeltype:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", power=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->power:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", band=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->band:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", squelchlevel=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->squelchlevel:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", recvsubaudiotype=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiotype:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", sendsubaudiotype=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiotype:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", recvsubaudiofreq=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiofreq:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", sendsubaudiofreq=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiofreq:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", colorcode=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->colorcode:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", slotmode=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->slotmode:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", contactype=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->contactype:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", number=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->number:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", recGroup=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recGroup:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", encryptSwitch=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptSwitch:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", encryptText=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptText:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", groupvalue=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->groupvalue:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 333
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->name:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 334
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendfreq:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 335
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recfreq:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 336
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->channeltype:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 337
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->power:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 338
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->band:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 339
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->squelchlevel:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 340
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiotype:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 341
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiotype:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 342
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->colorcode:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 343
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->slotmode:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 344
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->contactype:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 345
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptSwitch:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 346
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->encryptText:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 347
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->groupvalue:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 350
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recvsubaudiofreq:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 351
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->sendsubaudiofreq:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 352
    iget-object p2, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->number:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 353
    iget-object p0, p0, Lcom/pri/prizeinterphone/config/data/InsertChannel;->recGroup:Ljava/lang/String;

    invoke-virtual {p1, p0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    return-void
.end method
