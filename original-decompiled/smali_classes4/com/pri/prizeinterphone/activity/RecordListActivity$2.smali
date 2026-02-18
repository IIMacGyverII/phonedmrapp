.class Lcom/pri/prizeinterphone/activity/RecordListActivity$2;
.super Ljava/lang/Object;
.source "RecordListActivity.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


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

    .line 69
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 0

    if-eqz p2, :cond_0

    .line 73
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordAdapter(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->selectAll()V

    goto :goto_0

    .line 75
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$2;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity;->-$$Nest$fgetrecordAdapter(Lcom/pri/prizeinterphone/activity/RecordListActivity;)Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/activity/RecordListActivity$AudioListAdapter;->unSelectAll()V

    :goto_0
    return-void
.end method
