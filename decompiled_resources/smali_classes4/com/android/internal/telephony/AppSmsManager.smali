.class public Lcom/android/internal/telephony/AppSmsManager;
.super Ljava/lang/Object;
.source "AppSmsManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;
    }
.end annotation


# static fields
.field private static final LOG_TAG:Ljava/lang/String; = "AppSmsManager"

.field private static final TIMEOUT_MILLIS:J


# instance fields
.field private final mContext:Landroid/content/Context;

.field private final mLock:Ljava/lang/Object;

.field private final mPackageMap:Ljava/util/Map;
    .annotation build Lcom/android/internal/annotations/GuardedBy;
        value = {
            "mLock"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;",
            ">;"
        }
    .end annotation
.end field

.field private final mRandom:Ljava/security/SecureRandom;

.field private final mTokenMap:Ljava/util/Map;
    .annotation build Lcom/android/internal/annotations/GuardedBy;
        value = {
            "mLock"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 55
    sget-object v0, Ljava/util/concurrent/TimeUnit;->MINUTES:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x5

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/AppSmsManager;->TIMEOUT_MILLIS:J

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 65
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 58
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mLock:Ljava/lang/Object;

    .line 66
    new-instance v0, Ljava/security/SecureRandom;

    invoke-direct {v0}, Ljava/security/SecureRandom;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mRandom:Ljava/security/SecureRandom;

    .line 67
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mTokenMap:Ljava/util/Map;

    .line 68
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    .line 69
    iput-object p1, p0, Lcom/android/internal/telephony/AppSmsManager;->mContext:Landroid/content/Context;

    return-void
.end method

.method private addRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V
    .locals 2

    .line 267
    iget-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mTokenMap:Ljava/util/Map;

    iget-object v1, p1, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->token:Ljava/lang/String;

    invoke-interface {v0, v1, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 268
    iget-object p0, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    iget-object v0, p1, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->packageName:Ljava/lang/String;

    invoke-interface {p0, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private extractMessage(Landroid/content/Intent;)Ljava/lang/String;
    .locals 4

    .line 215
    invoke-static {p1}, Landroid/provider/Telephony$Sms$Intents;->getMessagesFromIntent(Landroid/content/Intent;)[Landroid/telephony/SmsMessage;

    move-result-object p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 219
    :cond_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    .line 220
    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_3

    aget-object v2, p0, v1

    if-eqz v2, :cond_2

    .line 221
    invoke-virtual {v2}, Landroid/telephony/SmsMessage;->getMessageBody()Ljava/lang/String;

    move-result-object v3

    if-nez v3, :cond_1

    goto :goto_1

    .line 224
    :cond_1
    invoke-virtual {v2}, Landroid/telephony/SmsMessage;->getMessageBody()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_2
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 227
    :cond_3
    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private findAppRequestInfoSmsIntentLocked(Ljava/lang/String;)Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;
    .locals 3

    .line 232
    iget-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mTokenMap:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 233
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-direct {p0, v1, p1}, Lcom/android/internal/telephony/AppSmsManager;->hasPrefix(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 234
    iget-object p0, p0, Lcom/android/internal/telephony/AppSmsManager;->mTokenMap:Ljava/util/Map;

    invoke-interface {p0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    return-object p0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private generateNonce()Ljava/lang/String;
    .locals 1

    const/16 v0, 0x8

    new-array v0, v0, [B

    .line 242
    iget-object p0, p0, Lcom/android/internal/telephony/AppSmsManager;->mRandom:Ljava/security/SecureRandom;

    invoke-virtual {p0, v0}, Ljava/security/SecureRandom;->nextBytes([B)V

    const/16 p0, 0xb

    .line 243
    invoke-static {v0, p0}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private hasPrefix(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 4

    .line 247
    iget-object p0, p0, Lcom/android/internal/telephony/AppSmsManager;->mTokenMap:Ljava/util/Map;

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    .line 248
    iget-object p1, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->prefixes:Ljava/lang/String;

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p1

    const/4 v0, 0x1

    if-eqz p1, :cond_0

    return v0

    .line 252
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->prefixes:Ljava/lang/String;

    const-string p1, ","

    invoke-virtual {p0, p1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 253
    array-length p1, p0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, p1, :cond_2

    aget-object v3, p0, v2

    .line 254
    invoke-virtual {p2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    return v0

    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    return v1
.end method

.method private removeExpiredTokenLocked()V
    .locals 9

    .line 189
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 191
    iget-object v2, p0, Lcom/android/internal/telephony/AppSmsManager;->mTokenMap:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    .line 192
    :cond_0
    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 193
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/Map$Entry;

    .line 194
    invoke-interface {v3}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    .line 195
    iget-boolean v5, v4, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->packageBasedToken:Z

    if-eqz v5, :cond_0

    sget-wide v5, Lcom/android/internal/telephony/AppSmsManager;->TIMEOUT_MILLIS:J

    sub-long v5, v0, v5

    iget-wide v7, v4, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->timestamp:J

    cmp-long v5, v5, v7

    if-lez v5, :cond_0

    .line 199
    :try_start_0
    new-instance v5, Landroid/content/Intent;

    invoke-direct {v5}, Landroid/content/Intent;-><init>()V

    const-string v6, "android.telephony.extra.STATUS"

    const/4 v7, 0x1

    .line 200
    invoke-virtual {v5, v6, v7}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    move-result-object v5

    const/high16 v6, 0x200000

    .line 202
    invoke-virtual {v5, v6}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object v5

    .line 203
    iget-object v4, v4, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->pendingIntent:Landroid/app/PendingIntent;

    iget-object v6, p0, Lcom/android/internal/telephony/AppSmsManager;->mContext:Landroid/content/Context;

    const/4 v7, 0x0

    invoke-virtual {v4, v6, v7, v5}, Landroid/app/PendingIntent;->send(Landroid/content/Context;ILandroid/content/Intent;)V
    :try_end_0
    .catch Landroid/app/PendingIntent$CanceledException; {:try_start_0 .. :try_end_0} :catch_0

    .line 208
    :catch_0
    iget-object v4, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    invoke-interface {v3}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    iget-object v3, v3, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->packageName:Ljava/lang/String;

    invoke-interface {v4, v3}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 209
    invoke-interface {v2}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    :cond_1
    return-void
.end method

.method private removeRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V
    .locals 2

    .line 262
    iget-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mTokenMap:Ljava/util/Map;

    iget-object v1, p1, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->token:Ljava/lang/String;

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 263
    iget-object p0, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    iget-object p1, p1, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->packageName:Ljava/lang/String;

    invoke-interface {p0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public createAppSpecificSmsToken(Ljava/lang/String;Landroid/app/PendingIntent;)Ljava/lang/String;
    .locals 3

    .line 86
    iget-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mContext:Landroid/content/Context;

    const-string v1, "appops"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AppOpsManager;

    .line 87
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v1

    invoke-virtual {v0, v1, p1}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 90
    invoke-direct {p0}, Lcom/android/internal/telephony/AppSmsManager;->generateNonce()Ljava/lang/String;

    move-result-object v0

    .line 91
    iget-object v1, p0, Lcom/android/internal/telephony/AppSmsManager;->mLock:Ljava/lang/Object;

    monitor-enter v1

    .line 93
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    invoke-interface {v2, p1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 94
    iget-object v2, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    invoke-interface {v2, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/AppSmsManager;->removeRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V

    .line 97
    :cond_0
    new-instance v2, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    invoke-direct {v2, p0, p1, p2, v0}, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;-><init>(Lcom/android/internal/telephony/AppSmsManager;Ljava/lang/String;Landroid/app/PendingIntent;Ljava/lang/String;)V

    .line 98
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/AppSmsManager;->addRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V

    .line 99
    monitor-exit v1

    return-object v0

    :catchall_0
    move-exception p0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public createAppSpecificSmsTokenWithPackageInfo(ILjava/lang/String;Ljava/lang/String;Landroid/app/PendingIntent;)Ljava/lang/String;
    .locals 11

    .line 119
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    const-string v0, "intent cannot be null"

    .line 122
    invoke-static {p4, v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    .line 124
    iget-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mContext:Landroid/content/Context;

    const-string v1, "appops"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AppOpsManager;

    .line 125
    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v1

    invoke-virtual {v0, v1, p2}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 128
    iget-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mContext:Landroid/content/Context;

    invoke-static {v0, p2}, Lcom/android/internal/telephony/PackageBasedTokenUtil;->generateToken(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 130
    iget-object v9, p0, Lcom/android/internal/telephony/AppSmsManager;->mLock:Ljava/lang/Object;

    monitor-enter v9

    .line 132
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    invoke-interface {v1, p2}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 133
    iget-object v1, p0, Lcom/android/internal/telephony/AppSmsManager;->mPackageMap:Ljava/util/Map;

    invoke-interface {v1, p2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/AppSmsManager;->removeRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V

    .line 136
    :cond_0
    new-instance v10, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    const/4 v8, 0x1

    move-object v1, v10

    move-object v2, p0

    move-object v3, p2

    move-object v4, p4

    move-object v5, v0

    move-object v6, p3

    move v7, p1

    invoke-direct/range {v1 .. v8}, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;-><init>(Lcom/android/internal/telephony/AppSmsManager;Ljava/lang/String;Landroid/app/PendingIntent;Ljava/lang/String;Ljava/lang/String;IZ)V

    .line 138
    invoke-direct {p0, v10}, Lcom/android/internal/telephony/AppSmsManager;->addRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V

    .line 139
    monitor-exit v9

    goto :goto_0

    :catchall_0
    move-exception p0

    monitor-exit v9
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    :cond_1
    :goto_0
    return-object v0

    .line 120
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "callingPackageName cannot be null or empty."

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public handleSmsReceivedIntent(Landroid/content/Intent;)Z
    .locals 5

    .line 149
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    const-string v1, "android.provider.Telephony.SMS_DELIVER"

    const/4 v2, 0x0

    if-eq v0, v1, :cond_0

    const-string p0, "AppSmsManager"

    .line 150
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Got intent with incorrect action: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 154
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/AppSmsManager;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 155
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/AppSmsManager;->removeExpiredTokenLocked()V

    .line 157
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/AppSmsManager;->extractMessage(Landroid/content/Intent;)Ljava/lang/String;

    move-result-object v1

    .line 158
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 159
    monitor-exit v0

    return v2

    .line 162
    :cond_1
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/AppSmsManager;->findAppRequestInfoSmsIntentLocked(Ljava/lang/String;)Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;

    move-result-object v3

    if-nez v3, :cond_2

    .line 165
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return v2

    .line 169
    :cond_2
    :try_start_1
    new-instance v4, Landroid/content/Intent;

    invoke-direct {v4}, Landroid/content/Intent;-><init>()V

    .line 170
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object p1

    invoke-virtual {v4, p1}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;

    move-result-object p1

    const-string v4, "android.telephony.extra.STATUS"

    .line 171
    invoke-virtual {p1, v4, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    move-result-object p1

    const-string v4, "android.telephony.extra.SMS_MESSAGE"

    .line 172
    invoke-virtual {p1, v4, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    move-result-object p1

    const-string v1, "android.telephony.extra.SIM_SUBSCRIPTION_ID"

    iget v4, v3, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->subId:I

    .line 173
    invoke-virtual {p1, v1, v4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    move-result-object p1

    const/high16 v1, 0x200000

    .line 174
    invoke-virtual {p1, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    move-result-object p1

    .line 176
    iget-object v1, v3, Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;->pendingIntent:Landroid/app/PendingIntent;

    iget-object v4, p0, Lcom/android/internal/telephony/AppSmsManager;->mContext:Landroid/content/Context;

    invoke-virtual {v1, v4, v2, p1}, Landroid/app/PendingIntent;->send(Landroid/content/Context;ILandroid/content/Intent;)V
    :try_end_1
    .catch Landroid/app/PendingIntent$CanceledException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 183
    :try_start_2
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/AppSmsManager;->removeRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V

    const/4 p0, 0x1

    .line 184
    monitor-exit v0

    return p0

    .line 179
    :catch_0
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/AppSmsManager;->removeRequestLocked(Lcom/android/internal/telephony/AppSmsManager$AppRequestInfo;)V

    .line 180
    monitor-exit v0

    return v2

    :catchall_0
    move-exception p0

    .line 185
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method
