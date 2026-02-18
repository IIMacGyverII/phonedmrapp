.class Lcom/pri/prizeinterphone/activity/GroupGridAdapter$1;
.super Ljava/lang/Object;
.source "GroupGridAdapter.java"

# interfaces
.implements Landroid/view/View$OnFocusChangeListener;


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


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;)V
    .locals 0

    .line 71
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$1;->this$0:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFocusChange(Landroid/view/View;Z)V
    .locals 0

    if-eqz p2, :cond_0

    .line 75
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/GroupGridAdapter$1;->this$0:Lcom/pri/prizeinterphone/activity/GroupGridAdapter;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/GroupGridAdapter;->-$$Nest$fgetactivity(Lcom/pri/prizeinterphone/activity/GroupGridAdapter;)Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;

    move-result-object p0

    const p1, 0x7f09011a

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/InterPhoneChannelActivity;->updateSelectedItem(I)V

    :cond_0
    return-void
.end method
