.class public final synthetic Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Function;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/PhoneSwitcher;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    return-void
.end method


# virtual methods
.method public final apply(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$$ExternalSyntheticLambda1;->f$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    check-cast p1, Ljava/lang/Integer;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->$r8$lambda$arhEJjJkHI5z9Shae-2IsmJNS14(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;

    move-result-object p0

    return-object p0
.end method
