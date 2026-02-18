.class Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$1;
.super Ljava/lang/Object;
.source "MessageContentActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

.field final synthetic val$position:I


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;I)V
    .locals 0

    .line 416
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$1;->this$1:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

    iput p2, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$1;->val$position:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 419
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$1;->this$1:Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;

    iget-object p1, p1, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter;->this$0:Lcom/pri/prizeinterphone/activity/MessageContentActivity;

    iget p0, p0, Lcom/pri/prizeinterphone/activity/MessageContentActivity$MessageListAdapter$1;->val$position:I

    invoke-virtual {p1, p0}, Lcom/pri/prizeinterphone/activity/MessageContentActivity;->showListDialog(I)V

    return-void
.end method
