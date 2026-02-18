.class public Lcom/android/internal/telephony/metrics/SimSlotState;
.super Ljava/lang/Object;
.source "SimSlotState.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "SimSlotState"


# instance fields
.field public final numActiveEsims:I

.field public final numActiveSims:I

.field public final numActiveSlots:I


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method private constructor <init>(III)V
    .locals 0

    .line 70
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 71
    iput p1, p0, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveSlots:I

    .line 72
    iput p2, p0, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveSims:I

    .line 73
    iput p3, p0, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveEsims:I

    return-void
.end method

.method public static getCurrentState()Lcom/android/internal/telephony/metrics/SimSlotState;
    .locals 10

    .line 39
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    move v3, v2

    move v4, v3

    move v5, v4

    .line 41
    :goto_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlots()[Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v6

    array-length v6, v6

    if-ge v2, v6, :cond_3

    .line 42
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlot(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v6

    if-eqz v6, :cond_2

    .line 43
    invoke-virtual {v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->isActive()Z

    move-result v7

    if-eqz v7, :cond_2

    add-int/lit8 v3, v3, 0x1

    .line 46
    invoke-virtual {v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object v7

    sget-object v8, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_PRESENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-ne v7, v8, :cond_2

    .line 47
    invoke-virtual {v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->isEuicc()Z

    move-result v7

    if-eqz v7, :cond_1

    .line 49
    invoke-virtual {v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->getUiccCard()Lcom/android/internal/telephony/uicc/UiccCard;

    move-result-object v6

    if-eqz v6, :cond_2

    .line 52
    invoke-virtual {v6}, Lcom/android/internal/telephony/uicc/UiccCard;->getUiccPortList()[Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v6

    .line 53
    array-length v7, v6

    move v8, v1

    :goto_1
    if-ge v8, v7, :cond_2

    aget-object v9, v6, v8

    if-eqz v9, :cond_0

    .line 54
    invoke-virtual {v9}, Lcom/android/internal/telephony/uicc/UiccPort;->getNumApplications()I

    move-result v9

    if-lez v9, :cond_0

    add-int/lit8 v4, v4, 0x1

    add-int/lit8 v5, v5, 0x1

    :cond_0
    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    :cond_1
    add-int/lit8 v4, v4, 0x1

    :cond_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 67
    :cond_3
    new-instance v0, Lcom/android/internal/telephony/metrics/SimSlotState;

    invoke-direct {v0, v3, v4, v5}, Lcom/android/internal/telephony/metrics/SimSlotState;-><init>(III)V

    return-object v0
.end method

.method public static isEsim(I)Z
    .locals 3

    .line 78
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlotForPhone(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 80
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->isEuicc()Z

    move-result p0

    return p0

    .line 83
    :cond_0
    sget-object v0, Lcom/android/internal/telephony/metrics/SimSlotState;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isEsim: slot=null for phone "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0
.end method

.method public static isMultiSim()Z
    .locals 2

    .line 90
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->getCurrentState()Lcom/android/internal/telephony/metrics/SimSlotState;

    move-result-object v0

    iget v0, v0, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveSims:I

    const/4 v1, 0x1

    if-le v0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method
