.class Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;
.super Ljava/lang/Object;
.source "PhoneNumberUtil.java"

# interfaces
.implements Ljava/lang/Iterable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;->findNumbers(Ljava/lang/CharSequence;Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;J)Ljava/lang/Iterable;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/lang/Iterable<",
        "Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;

.field final synthetic val$defaultRegion:Ljava/lang/String;

.field final synthetic val$leniency:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

.field final synthetic val$maxTries:J

.field final synthetic val$text:Ljava/lang/CharSequence;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;Ljava/lang/CharSequence;Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;J)V
    .locals 0

    .line 3165
    iput-object p1, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->this$0:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;

    iput-object p2, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$text:Ljava/lang/CharSequence;

    iput-object p3, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$defaultRegion:Ljava/lang/String;

    iput-object p4, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$leniency:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    iput-wide p5, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$maxTries:J

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public iterator()Ljava/util/Iterator;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Iterator<",
            "Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatch;",
            ">;"
        }
    .end annotation

    .line 3168
    new-instance v7, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;

    iget-object v1, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->this$0:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;

    iget-object v2, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$text:Ljava/lang/CharSequence;

    iget-object v3, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$defaultRegion:Ljava/lang/String;

    iget-object v4, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$leniency:Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;

    iget-wide v5, p0, Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$1;->val$maxTries:J

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/phonenumbers/PhoneNumberMatcher;-><init>(Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil;Ljava/lang/CharSequence;Ljava/lang/String;Lcom/android/internal/telephony/phonenumbers/PhoneNumberUtil$Leniency;J)V

    return-object v7
.end method
