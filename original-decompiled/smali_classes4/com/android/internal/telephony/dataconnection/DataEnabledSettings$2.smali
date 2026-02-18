.class Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$2;
.super Landroid/telephony/PhoneStateListener;
.source "DataEnabledSettings.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;)V
    .locals 0

    .line 173
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$2;->this$0:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    invoke-direct {p0}, Landroid/telephony/PhoneStateListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onCallStateChanged(ILjava/lang/String;)V
    .locals 0

    .line 176
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings$2;->this$0:Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    const/16 p1, 0x8

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->-$$Nest$mupdateDataEnabledAndNotify(Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;I)V

    return-void
.end method
