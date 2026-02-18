.class public final synthetic Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/PhoneSubInfoController;

.field public final synthetic f$1:I

.field public final synthetic f$2:I

.field public final synthetic f$3:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/PhoneSubInfoController;IILjava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/PhoneSubInfoController;

    iput p2, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$1:I

    iput p3, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$2:I

    iput-object p4, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$3:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final callMethod(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;
    .locals 3

    iget-object v0, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/PhoneSubInfoController;

    iget v1, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$1:I

    iget v2, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$2:I

    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda2;->f$3:Ljava/lang/String;

    invoke-static {v0, v1, v2, p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->$r8$lambda$MPAoBQu9fd9P_AxSsUyjgKK17Xs(Lcom/android/internal/telephony/PhoneSubInfoController;IILjava/lang/String;Lcom/android/internal/telephony/Phone;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
