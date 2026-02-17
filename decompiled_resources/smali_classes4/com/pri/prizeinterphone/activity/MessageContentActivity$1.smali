.class Lcom/pri/prizeinterphone/activity/MessageContentActivity$1;
.super Ljava/lang/Object;
.source "MessageContentActivity.java"

# interfaces
.implements Landroid/widget/AbsListView$OnScrollListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/MessageContentActivity;->initView()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)V
    .locals 0

    .line 104
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onScroll(Landroid/widget/AbsListView;III)V
    .locals 0

    return-void
.end method

.method public onScrollStateChanged(Landroid/widget/AbsListView;I)V
    .locals 0

    if-nez p2, :cond_0

    .line 108
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fgetmListView(Lcom/pri/prizeinterphone/activity/MessageContentActivity;)Landroid/widget/ListView;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/ListView;->getFirstVisiblePosition()I

    move-result p1

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->-$$Nest$fputmCurrentScrollPosition(Lcom/pri/prizeinterphone/activity/MessageContentActivity;I)V

    :cond_0
    return-void
.end method
