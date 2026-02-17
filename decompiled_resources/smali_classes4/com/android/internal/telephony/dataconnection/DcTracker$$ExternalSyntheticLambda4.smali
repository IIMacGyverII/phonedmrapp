.class public final synthetic Lcom/android/internal/telephony/dataconnection/DcTracker$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/Comparator;


# direct methods
.method public synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    check-cast p1, Lcom/android/internal/telephony/dataconnection/ApnContext;

    check-cast p2, Lcom/android/internal/telephony/dataconnection/ApnContext;

    invoke-static {p1, p2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->$r8$lambda$4uzwx4LUdjZ6ICqyhlyU4T6FlZ8(Lcom/android/internal/telephony/dataconnection/ApnContext;Lcom/android/internal/telephony/dataconnection/ApnContext;)I

    move-result p0

    return p0
.end method
