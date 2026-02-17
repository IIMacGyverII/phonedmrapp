.class final Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;
.super Ljava/lang/Object;
.source "SimPhonebookRecordCache.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "UpdateRequest"
.end annotation


# instance fields
.field private adnRecord:Lcom/android/internal/telephony/uicc/AdnRecord;

.field private myRecordId:I

.field private phonebookRecord:Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

.field private response:Landroid/os/Message;


# direct methods
.method static bridge synthetic -$$Nest$fgetadnRecord(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)Lcom/android/internal/telephony/uicc/AdnRecord;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->adnRecord:Lcom/android/internal/telephony/uicc/AdnRecord;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmyRecordId(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->myRecordId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetphonebookRecord(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->phonebookRecord:Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

    return-object p0
.end method

.method constructor <init>(ILcom/android/internal/telephony/uicc/AdnRecord;Lcom/android/internal/telephony/uicc/SimPhonebookRecord;Landroid/os/Message;)V
    .locals 0

    .line 631
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 632
    iput p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->myRecordId:I

    .line 633
    iput-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->adnRecord:Lcom/android/internal/telephony/uicc/AdnRecord;

    .line 634
    iput-object p3, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->phonebookRecord:Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

    .line 635
    iput-object p4, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->response:Landroid/os/Message;

    return-void
.end method


# virtual methods
.method responseResult(Ljava/lang/Exception;)V
    .locals 2

    .line 639
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->response:Landroid/os/Message;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 640
    invoke-static {v0, v1, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 641
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->response:Landroid/os/Message;

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    :cond_0
    return-void
.end method
