.class public final synthetic Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda11;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;


# instance fields
.field public final synthetic f$0:Landroid/telephony/ImsiEncryptionInfo;


# direct methods
.method public synthetic constructor <init>(Landroid/telephony/ImsiEncryptionInfo;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda11;->f$0:Landroid/telephony/ImsiEncryptionInfo;

    return-void
.end method


# virtual methods
.method public final callMethod(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda11;->f$0:Landroid/telephony/ImsiEncryptionInfo;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->$r8$lambda$XzENYZNCETjxQY_svycFf9IBfgk(Landroid/telephony/ImsiEncryptionInfo;Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method
