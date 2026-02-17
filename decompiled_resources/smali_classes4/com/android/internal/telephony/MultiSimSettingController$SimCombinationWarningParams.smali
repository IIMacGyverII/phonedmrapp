.class public Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;
.super Ljava/lang/Object;
.source "MultiSimSettingController.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/MultiSimSettingController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "SimCombinationWarningParams"
.end annotation


# instance fields
.field mSimNames:Ljava/lang/String;

.field mWarningType:I

.field final synthetic this$0:Lcom/android/internal/telephony/MultiSimSettingController;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/MultiSimSettingController;)V
    .locals 0

    .line 788
    iput-object p1, p0, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->this$0:Lcom/android/internal/telephony/MultiSimSettingController;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 p1, 0x0

    .line 789
    iput p1, p0, Lcom/android/internal/telephony/MultiSimSettingController$SimCombinationWarningParams;->mWarningType:I

    return-void
.end method
