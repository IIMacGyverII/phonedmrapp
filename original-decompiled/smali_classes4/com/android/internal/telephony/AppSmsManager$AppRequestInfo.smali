.class final Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;
.super Ljava/lang/Object;
.source "AppSmsManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/AppSmsManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "AppRequestInfo"
.end annotation


# instance fields
.field public final packageBasedToken:Z

.field public final packageName:Ljava/lang/String;

.field public final pendingIntent:Landroid/app/PendingIntent;

.field public final prefixes:Ljava/lang/String;

.field public final subId:I

.field final synthetic this$0:Lcom/android/internal/telephony/AppSmsManager;

.field public final timestamp:J

.field public final token:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/AppSmsManager;Ljava/lang/String;Landroid/app/PendingIntent;Ljava/lang/String;)V
    .locals 8

    const/4 v5, 0x0

    const/4 v6, -0x1

    const/4 v7, 0x0

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    .line 281
    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;-><init>(Lcom/android/internal/telephony/AppSmsManager;Ljava/lang/String;Landroid/app/PendingIntent;Ljava/lang/String;Ljava/lang/String;IZ)V

    return-void
.end method

.method constructor <init>(Lcom/android/internal/telephony/AppSmsManager;Ljava/lang/String;Landroid/app/PendingIntent;Ljava/lang/String;Ljava/lang/String;IZ)V
    .locals 0

    .line 286
    iput-object p1, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->this$0:Lcom/android/internal/telephony/AppSmsManager;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 287
    iput-object p2, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->packageName:Ljava/lang/String;

    .line 288
    iput-object p3, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->pendingIntent:Landroid/app/PendingIntent;

    .line 289
    iput-object p4, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->token:Ljava/lang/String;

    .line 290
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    iput-wide p1, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->timestamp:J

    .line 291
    iput-object p5, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->prefixes:Ljava/lang/String;

    .line 292
    iput p6, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->subId:I

    .line 293
    iput-boolean p7, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->packageBasedToken:Z

    return-void
.end method
