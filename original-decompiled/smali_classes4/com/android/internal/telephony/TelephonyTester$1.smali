.class Lcom/android/internal/telephony/TelephonyTester$1;
.super Landroid/content/BroadcastReceiver;
.source "TelephonyTester.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/TelephonyTester;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/TelephonyTester;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/TelephonyTester;)V
    .locals 0

    .line 168
    iput-object p1, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 3

    .line 171
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    .line 173
    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "sIntentReceiver.onReceive: action="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 174
    iget-object v1, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {v1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/TelephonyTester;)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getActionDetached()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    const-string/jumbo p1, "simulate detaching"

    .line 175
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 176
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p0}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/TelephonyTester;)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p0, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/RegistrantList;

    .line 177
    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    goto/16 :goto_0

    .line 178
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {v1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/TelephonyTester;)Lcom/android/internal/telephony/Phone;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getActionAttached()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string/jumbo p1, "simulate attaching"

    .line 179
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 180
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p0}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/TelephonyTester;)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p0, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/RegistrantList;

    .line 181
    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    goto/16 :goto_0

    :cond_1
    const-string v1, "com.android.internal.telephony.TestConferenceEventPackage"

    .line 182
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v0, "inject simulated conference event package"

    .line 183
    invoke-static {v0}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 184
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    const-string v0, "filename"

    .line 185
    invoke-virtual {p2, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "bypassImsCall"

    const/4 v2, 0x0

    .line 186
    invoke-virtual {p2, v1, v2}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result p2

    .line 184
    invoke-static {p0, p1, v0, p2}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$mhandleTestConferenceEventPackage(Lcom/android/internal/telephony/TelephonyTester;Landroid/content/Context;Ljava/lang/String;Z)V

    goto/16 :goto_0

    :cond_2
    const-string p1, "com.android.internal.telephony.TestDialogEventPackage"

    .line 187
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p1, "handle test dialog event package intent"

    .line 188
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 189
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$mhandleTestDialogEventPackageIntent(Lcom/android/internal/telephony/TelephonyTester;Landroid/content/Intent;)V

    goto/16 :goto_0

    :cond_3
    const-string p1, "com.android.internal.telephony.TestSuppSrvcFail"

    .line 190
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    const-string p1, "handle test supp svc failed intent"

    .line 191
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 192
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$mhandleSuppServiceFailedIntent(Lcom/android/internal/telephony/TelephonyTester;Landroid/content/Intent;)V

    goto/16 :goto_0

    :cond_4
    const-string p1, "com.android.internal.telephony.TestHandoverFail"

    .line 193
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_5

    const-string p1, "handle handover fail test intent"

    .line 194
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 195
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p0}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$mhandleHandoverFailedIntent(Lcom/android/internal/telephony/TelephonyTester;)V

    goto/16 :goto_0

    :cond_5
    const-string p1, "com.android.internal.telephony.TestSuppSrvcNotification"

    .line 196
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_6

    const-string p1, "handle supp service notification test intent"

    .line 197
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 198
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p0, p2}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$msendTestSuppServiceNotification(Lcom/android/internal/telephony/TelephonyTester;Landroid/content/Intent;)V

    goto/16 :goto_0

    :cond_6
    const-string p1, "com.android.internal.telephony.TestServiceState"

    .line 199
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_7

    const-string p1, "handle test service state changed intent"

    .line 200
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 203
    iget-object p1, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p1, p2}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$fputmServiceStateTestIntent(Lcom/android/internal/telephony/TelephonyTester;Landroid/content/Intent;)V

    .line 204
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-static {p0}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/TelephonyTester;)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    const/4 p1, 0x2

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    goto :goto_0

    :cond_7
    const-string p1, "com.android.internal.telephony.TestImsECall"

    .line 206
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_8

    const-string p1, "handle test IMS ecall intent"

    .line 207
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 208
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-virtual {p0}, Lcom/android/internal/telephony/TelephonyTester;->testImsECall()V

    goto :goto_0

    :cond_8
    const-string p1, "com.android.internal.telephony.TestReceiveDtmf"

    .line 209
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_9

    const-string p1, "handle test DTMF intent"

    .line 210
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 211
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/TelephonyTester;->testImsReceiveDtmf(Landroid/content/Intent;)V

    goto :goto_0

    :cond_9
    const-string p1, "com.android.internal.telephony.TestChangeNumber"

    .line 212
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_a

    const-string p1, "handle test change number intent"

    .line 213
    invoke-static {p1}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V

    .line 214
    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyTester$1;->this$0:Lcom/android/internal/telephony/TelephonyTester;

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/TelephonyTester;->testChangeNumber(Landroid/content/Intent;)V

    goto :goto_0

    .line 216
    :cond_a
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "onReceive: unknown action="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/TelephonyTester;->-$$Nest$smlog(Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/os/BadParcelableException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "TelephonyTester"

    .line 219
    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_0
    return-void
.end method
