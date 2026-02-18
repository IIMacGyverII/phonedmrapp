.class public final synthetic Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda24;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/PhoneSubInfoController$CallPhoneMethodHelper;


# instance fields
.field public final synthetic f$0:I


# direct methods
.method public synthetic constructor <init>(I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda24;->f$0:I

    return-void
.end method


# virtual methods
.method public final callMethod(Lcom/android/internal/telephony/Phone;)Ljava/lang/Object;
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/PhoneSubInfoController$$ExternalSyntheticLambda24;->f$0:I

    invoke-static {p0, p1}, Lcom/android/internal/telephony/PhoneSubInfoController;->$r8$lambda$C0XIWfHmI-AYshyzmnjTOqsSEbQ(ILcom/android/internal/telephony/Phone;)Landroid/telephony/ImsiEncryptionInfo;

    move-result-object p0

    return-object p0
.end method
