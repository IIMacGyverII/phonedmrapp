.class public Lcom/android/internal/telephony/dataconnection/DcFailBringUp;
.super Ljava/lang/Object;
.source "DcFailBringUp.java"


# static fields
.field static final ACTION_FAIL_BRINGUP:Ljava/lang/String; = "action_fail_bringup"

.field static final COUNTER:Ljava/lang/String; = "counter"

.field private static final DBG:Z = true

.field static final DEFAULT_COUNTER:I = 0x2

.field static final DEFAULT_FAIL_CAUSE:I = 0xffff

.field static final DEFAULT_SUGGESTED_RETRY_TIME:J = -0x1L

.field static final FAIL_CAUSE:Ljava/lang/String; = "fail_cause"

.field static final INTENT_BASE:Ljava/lang/String;

.field private static final LOG_TAG:Ljava/lang/String; = "DcFailBringUp"

.field static final SUGGESTED_RETRY_TIME:Ljava/lang/String; = "suggested_retry_time"


# instance fields
.field mCounter:I

.field mFailCause:I

.field mSuggestedRetryTime:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 34
    const-class v0, Lcom/android/internal/telephony/dataconnection/DataConnection;

    invoke-virtual {v0}, Ljava/lang/Class;->getPackage()Ljava/lang/Package;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Package;->getName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->INTENT_BASE:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static log(Ljava/lang/String;)V
    .locals 1

    const-string v0, "DcFailBringUp"

    .line 83
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public saveParameters(IIJ)V
    .locals 0

    .line 69
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mCounter:I

    .line 70
    invoke-static {p2}, Landroid/telephony/DataFailCause;->getFailCause(I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mFailCause:I

    .line 71
    iput-wide p3, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mSuggestedRetryTime:J

    return-void
.end method

.method saveParameters(Landroid/content/Intent;Ljava/lang/String;)V
    .locals 3

    .line 56
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".saveParameters: action="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->log(Ljava/lang/String;)V

    const-string v0, "counter"

    const/4 v1, 0x2

    .line 57
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mCounter:I

    const-string v0, "fail_cause"

    const v1, 0xffff

    .line 59
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result v0

    .line 58
    invoke-static {v0}, Landroid/telephony/DataFailCause;->getFailCause(I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mFailCause:I

    const-string/jumbo v0, "suggested_retry_time"

    const-wide/16 v1, -0x1

    .line 61
    invoke-virtual {p1, v0, v1, v2}, Landroid/content/Intent;->getLongExtra(Ljava/lang/String;J)J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mSuggestedRetryTime:J

    .line 63
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ".saveParameters: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->log(Ljava/lang/String;)V

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 76
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "{mCounter="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mCounter:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mFailCause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mFailCause:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mSuggestedRetryTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mSuggestedRetryTime:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string/jumbo p0, "}"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
