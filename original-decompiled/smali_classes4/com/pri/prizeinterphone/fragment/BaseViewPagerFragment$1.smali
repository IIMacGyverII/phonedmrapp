.class Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$1;
.super Ljava/lang/Object;
.source "BaseViewPagerFragment.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->initView(Landroid/view/View;)V
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

    .line 103
    iput-object p1, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 106
    iget-object p0, p0, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment$1;->this$0:Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/fragment/BaseViewPagerFragment;->doAddAction()V

    return-void
.end method
