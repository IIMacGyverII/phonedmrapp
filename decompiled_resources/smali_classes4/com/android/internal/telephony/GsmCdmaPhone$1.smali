.class Lcom/android/internal/telephony/GsmCdmaPhone$1;
.super Ljava/lang/Object;
.source "GsmCdmaPhone.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/GsmCdmaPhone;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/GsmCdmaPhone;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/GsmCdmaPhone;)V
    .locals 0

    .line 193
    iput-object p1, p0, Lcom/android/internal/telephony/GsmCdmaPhone$1;->this$0:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 196
    iget-object p0, p0, Lcom/android/internal/telephony/GsmCdmaPhone$1;->this$0:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->exitEmergencyCallbackMode()V

    return-void
.end method
