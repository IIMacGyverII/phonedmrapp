.class public final synthetic Lcom/android/internal/telephony/uicc/euicc/EuiccPort$$ExternalSyntheticLambda19;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/uicc/euicc/EuiccPort$ApduResponseHandler;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/uicc/euicc/EuiccPort;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/uicc/euicc/EuiccPort;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$$ExternalSyntheticLambda19;->f$0:Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    return-void
.end method


# virtual methods
.method public final handleResult([B)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort$$ExternalSyntheticLambda19;->f$0:Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->$r8$lambda$QT_7ymMLOw5wJCMIDqDKKk7aZtw(Lcom/android/internal/telephony/uicc/euicc/EuiccPort;[B)Lcom/android/internal/telephony/uicc/euicc/EuiccSpecVersion;

    move-result-object p0

    return-object p0
.end method
