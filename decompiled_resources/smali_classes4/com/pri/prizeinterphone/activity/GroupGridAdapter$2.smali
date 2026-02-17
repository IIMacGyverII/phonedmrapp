.class Lcom/pri/prizeinterphone/activity/GroupGridAdapter$2;
.super Ljava/lang/Object;
.source "GroupGridAdapter.java"

# interfaces
.implements Landroid/text/TextWatcher;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->getView(ILandroid/view/View;Landroid/view/ViewGroup;)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

.field final synthetic val$position:I


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;I)V
    .locals 0

    .line 80
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$2;->this$0:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    iput p2, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$2;->val$position:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public afterTextChanged(Landroid/text/Editable;)V
    .locals 2

    if-eqz p1, :cond_0

    .line 93
    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 94
    iget-object v0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$2;->this$0:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    iget p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$2;->val$position:I

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p1

    invoke-virtual {v0, p0, p1}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->updateData(II)V

    :cond_0
    return-void
.end method

.method public beforeTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0

    return-void
.end method

.method public onTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0

    return-void
.end method
