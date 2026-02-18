.class Lcom/android/internal/telephony/CarrierResolver$3;
.super Landroid/telephony/PhoneStateListener;
.source "CarrierResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/CarrierResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/CarrierResolver;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/CarrierResolver;)V
    .locals 0

    .line 250
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierResolver$3;->this$0:Lcom/android/internal/telephony/CarrierResolver;

    invoke-direct {p0}, Landroid/telephony/PhoneStateListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onCallStateChanged(ILjava/lang/String;)V
    .locals 0

    return-void
.end method
