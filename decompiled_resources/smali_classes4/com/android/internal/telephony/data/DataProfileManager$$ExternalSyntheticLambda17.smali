.class public final synthetic Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda17;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Predicate;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/data/DataProfileManager;

.field public final synthetic f$1:Landroid/telephony/data/DataProfile;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/telephony/data/DataProfile;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda17;->f$0:Lcom/android/internal/telephony/data/DataProfileManager;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda17;->f$1:Landroid/telephony/data/DataProfile;

    return-void
.end method


# virtual methods
.method public final test(Ljava/lang/Object;)Z
    .locals 1

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda17;->f$0:Lcom/android/internal/telephony/data/DataProfileManager;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda17;->f$1:Landroid/telephony/data/DataProfile;

    check-cast p1, Landroid/telephony/data/DataProfile;

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->$r8$lambda$QvzPI_xVj2YcxKB8afXPRmQNsQU(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/telephony/data/DataProfile;Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method
