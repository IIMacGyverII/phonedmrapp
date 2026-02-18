.class public final synthetic Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback$$ExternalSyntheticLambda0;->f$0:Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback;

    check-cast p1, Landroid/telephony/data/ThrottleStatus;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback;->$r8$lambda$h8W8KSTjwkwFDkgrGqWpA-eMURA(Lcom/android/internal/telephony/data/AccessNetworksManager$ThrottleStatusChangedCallback;Landroid/telephony/data/ThrottleStatus;)Z

    move-result p0

    return p0
.end method
