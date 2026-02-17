.class public final synthetic Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda8;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/BiConsumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda8;->f$0:Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda8;->f$0:Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    check-cast p1, Ljava/lang/String;

    check-cast p2, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataConfigManager;->$r8$lambda$UAV30vNScrOMJMgqfsNIE25XK_8(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/String;Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;)V

    return-void
.end method
