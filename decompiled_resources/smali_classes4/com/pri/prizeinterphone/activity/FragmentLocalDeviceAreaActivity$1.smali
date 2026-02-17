.class Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$1;
.super Ljava/lang/Object;
.source "FragmentLocalDeviceAreaActivity.java"

# interfaces
.implements Landroid/text/TextWatcher;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->showAddDialog()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;


# direct methods
.method constructor <init>(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)V
    .locals 0

    .line 111
    iput-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public afterTextChanged(Landroid/text/Editable;)V
    .locals 2

    .line 122
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmAddEdit(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Landroid/widget/EditText;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "[^a-zA-Z0-9\u4e00-\u9fa5]"

    .line 124
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    .line 125
    invoke-virtual {v0, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    const-string v1, ""

    .line 126
    invoke-virtual {v0, v1}, Ljava/util/regex/Matcher;->replaceAll(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 127
    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_1

    .line 128
    iget-object p1, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p1}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmAddEdit(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Landroid/widget/EditText;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 129
    iget-object p0, p0, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity$1;->this$0:Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;

    invoke-static {p0}, Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;->-$$Nest$fgetmAddEdit(Lcom/pri/prizeinterphone/activity/FragmentLocalDeviceAreaActivity;)Landroid/widget/EditText;

    move-result-object p0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p1

    const/16 v1, 0xd

    if-le p1, v1, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    :goto_0
    invoke-virtual {p0, v1}, Landroid/widget/EditText;->setSelection(I)V

    :cond_1
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
