.class Lcom/pri/prizeinterphone/manager/PrizePcmManager$2;
.super Ljava/lang/Object;
.source "PrizePcmManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/manager/PrizePcmManager;->startRecord()Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)V
    .locals 0

    .line 146
    iput-object p1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$2;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 148
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$2;->this$0:Lcom/pri/prizeinterphone/manager/PrizePcmManager;

    invoke-static {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->-$$Nest$mnotifyRecordThread(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)V

    return-void
.end method
