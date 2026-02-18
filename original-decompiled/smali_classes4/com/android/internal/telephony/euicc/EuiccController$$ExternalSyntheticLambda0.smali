.class public final synthetic Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/euicc/EuiccController;

.field public final synthetic f$1:Landroid/app/PendingIntent;

.field public final synthetic f$2:I

.field public final synthetic f$3:Landroid/content/Intent;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$1:Landroid/app/PendingIntent;

    iput p3, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$2:I

    iput-object p4, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$3:Landroid/content/Intent;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/euicc/EuiccController;

    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$1:Landroid/app/PendingIntent;

    iget v2, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$2:I

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;->f$3:Landroid/content/Intent;

    invoke-static {v0, v1, v2, p0}, Lcom/android/internal/telephony/euicc/EuiccController;->$r8$lambda$V_ySsFE-Cog52iEv7sNhriidFcc(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;ILandroid/content/Intent;)V

    return-void
.end method
