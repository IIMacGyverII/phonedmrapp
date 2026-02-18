.class Lcom/pri/prizeinterphone/activity/RecordListActivity$1;
.super Ljava/lang/Object;
.source "RecordListActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/RecordListActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/RecordListActivity;)V
    .locals 0

    .line 57
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 60
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$misTalkSend(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetdeleteList(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    if-lez p1, :cond_0

    .line 61
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    const p1, 0x7f11011c

    invoke-static {p0, p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$mshowToast(Lcom/pri/prizeinterphone/activity/RecordListActivity;I)V

    return-void

    .line 64
    :cond_0
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordAdapter(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

    move-result-object p1

    invoke-virtual {p1}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->deleteSelectFiles()V

    .line 65
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetselectAll(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Landroid/widget/CheckBox;

    move-result-object p0

    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Landroid/widget/CheckBox;->setChecked(Z)V

    return-void
.end method
