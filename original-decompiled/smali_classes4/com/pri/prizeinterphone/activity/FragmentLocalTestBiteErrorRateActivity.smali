.class public Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "FragmentLocalTestBiteErrorRateActivity.java"

# interfaces
.implements Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;


# static fields
.field private static final TAG:Ljava/lang/String; = "FragmentLocalTestBiteErrorRateAc"


# instance fields
.field private mTvInfo:Landroid/widget/TextView;

.field private stringBuilder:Ljava/lang/StringBuilder;


# direct methods
.method public static synthetic $r8$lambda$VZY3ZzLuuBjh2BUViSZsNSordqY(Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;->lambda$dealEvent$0()V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 21
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 24
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;->stringBuilder:Ljava/lang/StringBuilder;

    return-void
.end method

.method private synthetic lambda$dealEvent$0()V
    .locals 1

    .line 60
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;->mTvInfo:Landroid/widget/TextView;

    if-eqz v0, :cond_0

    .line 61
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;->stringBuilder:Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_0
    return-void
.end method


# virtual methods
.method public dealEvent(Lcom/pri/prizeinterphone/message/BaseMessage;)V
    .locals 4

    .line 51
    iget-object v0, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    if-eqz v0, :cond_0

    .line 52
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "baseMessage.packet.body="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-object v1, v1, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    invoke-static {v1}, Lcom/pri/prizeinterphone/Util/Util;->bytesToHex([B)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "FragmentLocalTestBiteErrorRateAc"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 55
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;->stringBuilder:Ljava/lang/StringBuilder;

    new-instance v2, Ljava/lang/String;

    iget-object p1, p1, Lcom/pri/prizeinterphone/message/BaseMessage;->packet:Lcom/pri/prizeinterphone/protocol/Packet;

    iget-object p1, p1, Lcom/pri/prizeinterphone/protocol/Packet;->body:[B

    const-string v3, "GBK"

    invoke-direct {v2, p1, v3}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\n"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v0, "baseMessage.packet.body transform GBK error"

    .line 57
    invoke-static {v1, v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 59
    :goto_0
    new-instance p1, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity$$ExternalSyntheticLambda0;

    invoke-direct {p1, p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;)V

    invoke-virtual {p0, p1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :cond_0
    return-void
.end method

.method public onBackPressed()V
    .locals 0

    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1    # Landroid/os/Bundle;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    .line 28
    invoke-super {p0, p1}, Landroidx/fragment/app/FragmentActivity;->onCreate(Landroid/os/Bundle;)V

    .line 29
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object p1

    const/16 v0, 0x80

    invoke-virtual {p1, v0}, Landroid/view/Window;->addFlags(I)V

    const p1, 0x7f0c0046

    .line 30
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->setContentView(I)V

    const p1, 0x7f09029d

    .line 31
    invoke-virtual {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalTestBiteErrorRateActivity;->mTvInfo:Landroid/widget/TextView;

    .line 32
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->setTestBitErrorRate(Z)V

    .line 33
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p1

    const/16 v0, 0x3f

    invoke-virtual {p1, v0, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->registerEventListener(BLcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    .line 34
    new-instance p0, Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;-><init>()V

    const/4 p1, 0x2

    .line 35
    iput-byte p1, p0, Lcom/pri/prizeinterphone/message/TestBiteErrorRateMessage;->protocol:B

    .line 36
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/message/BaseMessage;->send()V

    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 69
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    .line 70
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    const/16 v1, 0x3f

    invoke-static {v1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v1

    invoke-virtual {v0, v1, p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->unregisterEventListener(Ljava/lang/Byte;Lcom/pri/prizeinterphone/manager/DmrManager$MessageListener;)V

    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 41
    invoke-super {p0}, Landroidx/fragment/app/FragmentActivity;->onResume()V

    return-void
.end method
