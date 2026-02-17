.class Lcom/android/internal/telephony/data/PhoneSwitcher$3;
.super Landroid/telephony/ims/RegistrationManager$RegistrationCallback;
.source "PhoneSwitcher.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/PhoneSwitcher;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/PhoneSwitcher;)V
    .locals 0

    .line 355
    iput-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-direct {p0}, Landroid/telephony/ims/RegistrationManager$RegistrationCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onRegistered(Landroid/telephony/ims/ImsRegistrationAttributes;)V
    .locals 1

    .line 358
    invoke-virtual {p1}, Landroid/telephony/ims/ImsRegistrationAttributes;->getRegistrationTechnology()I

    move-result p1

    .line 359
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-static {v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->-$$Nest$fgetmImsRegistrationTech(Lcom/android/internal/telephony/data/PhoneSwitcher;)I

    move-result v0

    if-eq p1, v0, :cond_0

    .line 360
    iget-object v0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-static {v0, p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->-$$Nest$fputmImsRegistrationTech(Lcom/android/internal/telephony/data/PhoneSwitcher;I)V

    .line 361
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    const/16 p1, 0x78

    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_0
    return-void
.end method

.method public onUnregistered(Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 1

    .line 367
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-static {p1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->-$$Nest$fgetmImsRegistrationTech(Lcom/android/internal/telephony/data/PhoneSwitcher;)I

    move-result p1

    const/4 v0, -0x1

    if-eq p1, v0, :cond_0

    .line 368
    iget-object p1, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    invoke-static {p1, v0}, Lcom/android/internal/telephony/data/PhoneSwitcher;->-$$Nest$fputmImsRegistrationTech(Lcom/android/internal/telephony/data/PhoneSwitcher;I)V

    .line 369
    iget-object p0, p0, Lcom/android/internal/telephony/data/PhoneSwitcher$3;->this$0:Lcom/android/internal/telephony/data/PhoneSwitcher;

    const/16 p1, 0x78

    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_0
    return-void
.end method
