.class Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$2;
.super Ljava/lang/Object;
.source "BaseViewPagerFragment.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;)V
    .locals 0

    .line 198
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 0

    .line 201
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$2;->this$0:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->dismissProgressDialog()V

    return-void
.end method
