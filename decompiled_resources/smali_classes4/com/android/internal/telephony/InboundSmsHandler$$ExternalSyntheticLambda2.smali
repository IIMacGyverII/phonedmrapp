.class public final synthetic Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Lcom/android/internal/telephony/InboundSmsHandler$SmsFilter;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/InboundSmsHandler;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/InboundSmsHandler;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/InboundSmsHandler;

    return-void
.end method


# virtual methods
.method public final filterSms([[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z
    .locals 8

    iget-object v0, p0, Lcom/android/internal/telephony/InboundSmsHandler$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/InboundSmsHandler;

    move-object v1, p1

    move v2, p2

    move-object v3, p3

    move-object v4, p4

    move v5, p5

    move v6, p6

    move-object v7, p7

    invoke-static/range {v0 .. v7}, Lcom/android/internal/telephony/InboundSmsHandler;->$r8$lambda$N05ImwMSSGeMVf_UvqK62v1wmKE(Lcom/android/internal/telephony/InboundSmsHandler;[[BILcom/android/internal/telephony/InboundSmsTracker;Lcom/android/internal/telephony/InboundSmsHandler$SmsBroadcastReceiver;ZZLjava/util/List;)Z

    move-result p0

    return p0
.end method
