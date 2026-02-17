.class public final synthetic Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

.field public final synthetic f$1:Z

.field public final synthetic f$2:I


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZI)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;->f$0:Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;->f$1:Z

    iput p3, p0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;->f$2:I

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 2

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;->f$0:Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;->f$1:Z

    iget p0, p0, Lcom/android/internal/telephony/data/DataSettingsManager$$ExternalSyntheticLambda6;->f$2:I

    invoke-static {v0, v1, p0}, Lcom/android/internal/telephony/data/DataSettingsManager;->$r8$lambda$-Qt-brMc5U8qz4T12yH3dNsGX8Y(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;ZI)V

    return-void
.end method
