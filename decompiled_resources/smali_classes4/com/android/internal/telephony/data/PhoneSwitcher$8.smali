.class Lcom/android/internal/telephony/data/PhoneSwitcher$8;
.super Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
.source "PhoneSwitcher.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/data/PhoneSwitcher;->lambda$onMultiSimConfigChanged$2(Ljava/lang/Integer;)Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/util/concurrent/Executor;)V
    .locals 0

    .line 889
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$8;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;-><init>(Ljava/util/concurrent/Executor;)V

    return-void
.end method


# virtual methods
.method public onDataEnabledChanged(ZILjava/lang/String;)V
    .locals 0

    .line 894
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$8;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    const-string p1, "EVENT_DATA_ENABLED_CHANGED"

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->-$$Nest$mevaluateIfDataSwitchIsNeeded(Lcom/android/internal/telephony/data/PhoneSwitcher;Ljava/lang/String;)V

    return-void
.end method
