.class Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules$1;
.super Ljava/lang/Object;
.source "UiccCarrierPrivilegeRules.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;)V
    .locals 0

    .line 205
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules$1;->this$0:Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 208
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules$1;->this$0:Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;->-$$Nest$fgetmAIDInUse(Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;)I

    move-result v0

    invoke-static {p0, v0}, Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;->-$$Nest$mopenChannel(Lcom/android/internal/telephony/uicc/UiccCarrierPrivilegeRules;I)V

    return-void
.end method
