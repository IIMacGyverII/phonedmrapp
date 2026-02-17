.class Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$3;
.super Ljava/lang/Object;
.source "FragmentNewContactsActivity.java"

# interfaces
.implements Landroid/view/View$OnFocusChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->initView()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;)V
    .locals 0

    .line 111
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFocusChange(Landroid/view/View;Z)V
    .locals 1

    .line 114
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "mEditGroupName onFocusChange  hasFocus = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "FragmentNewContactsActivity"

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p2, :cond_0

    .line 116
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity$3;->this$0:Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;

    const/4 p1, 0x2

    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/activity/FragmentNewContactsActivity;->updateSeletedItm(I)V

    :cond_0
    return-void
.end method
