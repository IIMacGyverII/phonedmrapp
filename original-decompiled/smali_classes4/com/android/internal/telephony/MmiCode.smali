.class public interface abstract Lcom/android/internal/telephony/MmiCode;
.super Ljava/lang/Object;
.source "MmiCode.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/MmiCode$State;
    }
.end annotation


# static fields
.field public static final MATCH_GROUP_CDMA_MMI_CODE_NUMBER:I = 0x3

.field public static final MATCH_GROUP_CDMA_MMI_CODE_NUMBER_PREFIX:I = 0x2

.field public static final MATCH_GROUP_CDMA_MMI_CODE_SERVICE_CODE:I = 0x1

.field public static final sPatternCdmaMmiCodeWhileRoaming:Ljava/util/regex/Pattern;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "\\*(\\d{2})(\\+{0,1})(\\d{0,})"

    .line 102
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/MmiCode;->sPatternCdmaMmiCodeWhileRoaming:Ljava/util/regex/Pattern;

    return-void
.end method


# virtual methods
.method public abstract cancel()V
.end method

.method public abstract getDialString()Ljava/lang/String;
.end method

.method public abstract getMessage()Ljava/lang/CharSequence;
.end method

.method public abstract getPhone()Lcom/android/internal/telephony/Phone;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end method

.method public abstract getState()Lcom/android/internal/telephony/MmiCode$State;
.end method

.method public abstract getUssdCallbackReceiver()Landroid/os/ResultReceiver;
.end method

.method public abstract isCancelable()Z
.end method

.method public abstract isNetworkInitiatedUssd()Z
.end method

.method public abstract isPinPukCommand()Z
.end method

.method public abstract isUssdRequest()Z
.end method

.method public abstract processCode()V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/android/internal/telephony/CallStateException;
        }
    .end annotation
.end method
