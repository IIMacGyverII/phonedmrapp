.class public Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;
.super Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
.source "RecordListActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/activity/RecordListActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "ItemViewHolder"
.end annotation


# instance fields
.field fileChannel:Landroid/widget/TextView;

.field fileName:Landroid/widget/TextView;

.field fileSelect:Landroid/widget/CheckBox;

.field fileTimestamp:Landroid/widget/TextView;

.field fileType:Landroid/widget/TextView;

.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/activity/RecordListActivity;Landroid/view/View;)V
    .locals 0

    .line 113
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->this$0:Lcom/pri/prizeinterphone/activity/RecordListActivity;

    .line 114
    invoke-direct {p0, p2}, Landroidx/recyclerview/widget/RecyclerView$ViewHolder;-><init>(Landroid/view/View;)V

    const p1, 0x7f090213

    .line 115
    invoke-virtual {p2, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileName:Landroid/widget/TextView;

    const p1, 0x7f090211

    .line 116
    invoke-virtual {p2, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileChannel:Landroid/widget/TextView;

    const p1, 0x7f090216

    .line 117
    invoke-virtual {p2, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileType:Landroid/widget/TextView;

    const p1, 0x7f090215

    .line 118
    invoke-virtual {p2, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileTimestamp:Landroid/widget/TextView;

    const p1, 0x7f090214

    .line 119
    invoke-virtual {p2, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/CheckBox;

    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/RecordListActivity$ItemViewHolder;->fileSelect:Landroid/widget/CheckBox;

    return-void
.end method
