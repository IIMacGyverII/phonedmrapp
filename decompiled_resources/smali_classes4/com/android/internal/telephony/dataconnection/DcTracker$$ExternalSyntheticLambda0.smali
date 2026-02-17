.class public final synthetic Lcom/android/internal/telephony/dataconnection/DcTracker$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$$ExternalSyntheticLambda0;->f$0:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$$ExternalSyntheticLambda0;->f$0:Ljava/lang/String;

    check-cast p1, Landroid/telephony/data/ApnSetting;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->$r8$lambda$jvxDOsYnS12U-wcJAvBFF2ultyQ(Ljava/lang/String;Landroid/telephony/data/ApnSetting;)Z

    move-result p0

    return p0
.end method
