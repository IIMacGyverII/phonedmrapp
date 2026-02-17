.class public Lcom/android/internal/telephony/uicc/SIMFileHandler;
.super Lcom/android/internal/telephony/uicc/IccFileHandler;
.source "SIMFileHandler.java"

# interfaces
.implements Lcom/android/internal/telephony/uicc/IccConstants;


# static fields
.field static final LOG_TAG:Ljava/lang/String; = "SIMFileHandler"


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/uicc/UiccCardApplication;Ljava/lang/String;Lcom/android/internal/telephony/CommandsInterface;)V
    .locals 0

    .line 35
    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/uicc/IccFileHandler;-><init>(Lcom/android/internal/telephony/uicc/UiccCardApplication;Ljava/lang/String;Lcom/android/internal/telephony/CommandsInterface;)V

    return-void
.end method


# virtual methods
.method protected getEFPath(I)Ljava/lang/String;
    .locals 1

    const/16 v0, 0x6f11

    if-eq p1, v0, :cond_2

    const/16 v0, 0x6f38

    if-eq p1, v0, :cond_2

    const/16 v0, 0x6f3c

    if-eq p1, v0, :cond_1

    const/16 v0, 0x6f46

    if-eq p1, v0, :cond_2

    const/16 v0, 0x6fad

    if-eq p1, v0, :cond_2

    const/16 v0, 0x6fc5

    if-eq p1, v0, :cond_2

    const/16 v0, 0x6fcd

    if-eq p1, v0, :cond_2

    const/16 v0, 0x6f3e

    if-eq p1, v0, :cond_2

    const/16 v0, 0x6f3f

    if-eq p1, v0, :cond_2

    packed-switch p1, :pswitch_data_0

    packed-switch p1, :pswitch_data_1

    .line 69
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/IccFileHandler;->getCommonIccEFPath(I)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_0

    const-string p1, "SIMFileHandler"

    const-string v0, "Error: EF Path being returned in null"

    .line 71
    invoke-static {p1, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-object p0

    :cond_1
    const-string p0, "3F007F10"

    return-object p0

    :cond_2
    :pswitch_0
    const-string p0, "3F007F20"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x6f13
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x6fc7
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method

.method protected logd(Ljava/lang/String;)V
    .locals 0

    const-string p0, "SIMFileHandler"

    .line 78
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 0

    const-string p0, "SIMFileHandler"

    .line 83
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
