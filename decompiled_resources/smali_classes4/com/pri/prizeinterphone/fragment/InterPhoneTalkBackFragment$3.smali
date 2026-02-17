.class Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$3;
.super Ljava/lang/Object;
.source "InterPhoneTalkBackFragment.java"

# interfaces
.implements Landroid/media/SoundPool$OnLoadCompleteListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)V
    .locals 0

    .line 460
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLoadComplete(Landroid/media/SoundPool;II)V
    .locals 7

    .line 463
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment$3;->this$0:Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;

    invoke-static {p0}, Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;->-$$Nest$fgetsoundId(Lcom/pri/prizeinterphone/fragment/InterPhoneTalkBackFragment;)I

    move-result v1

    const v2, 0x3f333333    # 0.7f

    const v3, 0x3f333333    # 0.7f

    const/4 v4, 0x1

    const/4 v5, 0x0

    const/high16 v6, 0x3f800000    # 1.0f

    move-object v0, p1

    invoke-virtual/range {v0 .. v6}, Landroid/media/SoundPool;->play(IFFIIF)I

    return-void
.end method
