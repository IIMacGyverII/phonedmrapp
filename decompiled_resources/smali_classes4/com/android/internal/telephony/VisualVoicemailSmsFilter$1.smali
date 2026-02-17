.class Lcom/android/internal/telephony/VisualVoicemailSmsFilter$1;
.super Ljava/lang/Object;
.source "VisualVoicemailSmsFilter.java"

# interfaces
.implements Lcom/android/internal/telephony/VisualVoicemailSmsFilter$PhoneAccountHandleConverter;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/VisualVoicemailSmsFilter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 75
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public fromSubId(I)Landroid/telecom/PhoneAccountHandle;
    .locals 1

    .line 79
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 82
    :cond_0
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->getPhoneId(I)I

    move-result p0

    const/4 p1, -0x1

    if-ne p0, p1, :cond_1

    return-object v0

    .line 86
    :cond_1
    new-instance p1, Landroid/telecom/PhoneAccountHandle;

    invoke-static {}, Lcom/android/internal/telephony/VisualVoicemailSmsFilter;->-$$Nest$sfgetPSTN_CONNECTION_SERVICE_COMPONENT()Landroid/content/ComponentName;

    move-result-object v0

    .line 87
    invoke-static {p0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    invoke-direct {p1, v0, p0}, Landroid/telecom/PhoneAccountHandle;-><init>(Landroid/content/ComponentName;Ljava/lang/String;)V

    return-object p1
.end method
