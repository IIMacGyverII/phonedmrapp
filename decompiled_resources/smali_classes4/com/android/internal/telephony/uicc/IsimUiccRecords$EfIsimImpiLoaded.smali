.class public Lcom/android/internal/telephony/uicc/IsimUiccRecords$EfIsimImpiLoaded;
.super Ljava/lang/Object;
.source "IsimUiccRecords.java"

# interfaces
.implements Lcom/android/internal/telephony/uicc/IccRecords$IccRecordLoaded;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/IsimUiccRecords;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "EfIsimImpiLoaded"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/IsimUiccRecords;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/uicc/IsimUiccRecords;)V
    .locals 0

    .line 171
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/IsimUiccRecords$EfIsimImpiLoaded;->this$0:Lcom/android/internal/telephony/uicc/IsimUiccRecords;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getEfName()Ljava/lang/String;
    .locals 0

    const-string p0, "EF_ISIM_IMPI"

    return-object p0
.end method

.method public onRecordLoaded(Landroid/os/AsyncResult;)V
    .locals 0

    .line 177
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [B

    .line 178
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IsimUiccRecords$EfIsimImpiLoaded;->this$0:Lcom/android/internal/telephony/uicc/IsimUiccRecords;

    invoke-static {p1}, Lcom/android/internal/telephony/uicc/IsimUiccRecords;->-$$Nest$smisimTlvToString([B)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/uicc/IsimUiccRecords;->-$$Nest$fputmIsimImpi(Lcom/android/internal/telephony/uicc/IsimUiccRecords;Ljava/lang/String;)V

    return-void
.end method
