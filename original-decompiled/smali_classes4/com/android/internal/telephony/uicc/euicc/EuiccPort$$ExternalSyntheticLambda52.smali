.class public final synthetic Lcom/android/internal/telephony/uicc/euicc/EuiccPort$$ExternalSyntheticLambda52;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduExceptionHandler;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$$ExternalSyntheticLambda52;->f$0:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;

    return-void
.end method


# virtual methods
.method public final handleException(Ljava/lang/Throwable;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$$ExternalSyntheticLambda52;->f$0:Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->$r8$lambda$8x9Mw_LfktrBXDaDFYF0Xl8vpps(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Ljava/lang/Throwable;)V

    return-void
.end method
