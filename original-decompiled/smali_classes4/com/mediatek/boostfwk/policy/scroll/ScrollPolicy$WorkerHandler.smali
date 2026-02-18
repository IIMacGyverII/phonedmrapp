.class Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;
.super Landroid/os/Handler;
.source "ScrollPolicy.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "WorkerHandler"
.end annotation


# static fields
.field public static final MSG_RELEASE_BEGIN:I = 0x1

.field public static final MSG_RELEASE_END:I = 0x2

.field public static final MSG_RELEASE_FPS_CHECK:I = 0x3

.field public static final MSG_RELEASE_FPS_TIMEOUT:I = 0x4

.field public static final MSG_SBE_DELAY_RELEASE_FPSGO:I = 0xb

.field public static final MSG_SBE_DELAY_RELEASE_TARGET_FPS:I = 0xe

.field public static final MSG_SBE_DISABLE_FPSGO_COUNT_DOWN:I = 0xc

.field public static final MSG_SBE_FLING_POLICY_BEGIN:I = 0x8

.field public static final MSG_SBE_FLING_POLICY_END:I = 0x9

.field public static final MSG_SBE_FLING_POLICY_FLAG_END:I = 0xa

.field public static final MSG_SBE_POLICY_BEGIN:I = 0x5

.field public static final MSG_SBE_POLICY_END:I = 0x6

.field public static final MSG_SBE_POLICY_FLAG_END:I = 0x7

.field public static final MSG_SBE_SCROLL_COMMON_POLICY_COUNT_DOWN:I = 0xd


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Landroid/os/Looper;)V
    .locals 0

    .line 225
    iput-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    .line 226
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 231
    iget p1, p1, Landroid/os/Message;->what:I

    const/4 v0, 0x1

    const/4 v1, 0x0

    packed-switch p1, :pswitch_data_0

    goto/16 :goto_0

    .line 281
    :pswitch_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mdelayReleaseTargetFPSInternal(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)V

    goto/16 :goto_0

    .line 278
    :pswitch_1
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mscrollCommonPolicyCheck(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)V

    goto/16 :goto_0

    .line 274
    :pswitch_2
    sput-boolean v1, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->useFPSGo:Z

    .line 275
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fgetscrollingFingStep(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)I

    move-result p1

    invoke-static {p0, v1, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$menableFPSGo(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;ZI)V

    goto :goto_0

    .line 269
    :pswitch_3
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p1, v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fputwaitingForReleaseFpsgo(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    .line 270
    iget-object p1, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fgetwaitingForReleaseFpsgoStep(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)I

    move-result v0

    invoke-static {p1, v1, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$menableFPSGo(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;ZI)V

    .line 271
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    const/4 p1, -0x1

    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fputwaitingForReleaseFpsgoStep(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;I)V

    goto :goto_0

    .line 263
    :pswitch_4
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$sfgetmFlingPolicyExeCount()I

    move-result p1

    if-lez p1, :cond_0

    .line 264
    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$sfputmFlingPolicyExeCount(I)V

    .line 265
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$fgetscrollingFingStep(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;)I

    move-result p1

    invoke-static {p0, v1, p1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$menableFPSGo(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;ZI)V

    goto :goto_0

    .line 254
    :pswitch_5
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mmtkScrollingFlingPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    goto :goto_0

    .line 251
    :pswitch_6
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mmtkScrollingFlingPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    goto :goto_0

    .line 257
    :pswitch_7
    invoke-static {}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$sfgetmPolicyExeCount()I

    move-result p1

    if-lez p1, :cond_0

    .line 258
    invoke-static {v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$sfputmPolicyExeCount(I)V

    .line 259
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v1, v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$menableFPSGo(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;ZI)V

    goto :goto_0

    .line 248
    :pswitch_8
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mmtkScrollingPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    goto :goto_0

    .line 245
    :pswitch_9
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mmtkScrollingPolicy(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    goto :goto_0

    .line 242
    :pswitch_a
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mreleaseTargetFPSInternel(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    goto :goto_0

    .line 239
    :pswitch_b
    invoke-static {v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$sfputisCorrectFPS(Z)V

    goto :goto_0

    .line 236
    :pswitch_c
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v1}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mreleaseTargetFPSInternel(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    goto :goto_0

    .line 233
    :pswitch_d
    iget-object p0, p0, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy$WorkerHandler;->this$0:Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;

    invoke-static {p0, v0}, Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;->-$$Nest$mreleaseTargetFPSInternel(Lcom/mediatek/boostfwk/policy/scroll/ScrollPolicy;Z)V

    :cond_0
    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
