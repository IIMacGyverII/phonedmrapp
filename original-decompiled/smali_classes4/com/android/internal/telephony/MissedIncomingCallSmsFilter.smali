.class public Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;
.super Ljava/lang/Object;
.source "MissedIncomingCallSmsFilter.java"


# static fields
.field private static final PSTN_CONNECTION_SERVICE_COMPONENT:Landroid/content/ComponentName;

.field private static final SMS_CALLER_ID_TAG:Ljava/lang/String; = "callerId"

.field private static final SMS_DAY_TAG:Ljava/lang/String; = "day"

.field private static final SMS_HOUR_TAG:Ljava/lang/String; = "hour"

.field private static final SMS_MINUTE_TAG:Ljava/lang/String; = "minute"

.field private static final SMS_MONTH_TAG:Ljava/lang/String; = "month"

.field private static final SMS_YEAR_TAG:Ljava/lang/String; = "year"

.field private static final TAG:Ljava/lang/String; = "MissedIncomingCallSmsFilter"

.field private static final VDBG:Z = false


# instance fields
.field private mCarrierConfig:Landroid/os/PersistableBundle;

.field private final mPhone:Lcom/android/internal/telephony/Phone;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 63
    new-instance v0, Landroid/content/ComponentName;

    const-string v1, "com.android.phone"

    const-string v2, "com.android.services.telephony.TelephonyConnectionService"

    invoke-direct {v0, v1, v2}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    sput-object v0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->PSTN_CONNECTION_SERVICE_COMPONENT:Landroid/content/ComponentName;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 2

    .line 76
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 77
    iput-object p1, p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 79
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    .line 80
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    if-eqz v0, :cond_0

    .line 82
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {v0, p1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->mCarrierConfig:Landroid/os/PersistableBundle;

    :cond_0
    return-void
.end method

.method private createMissedIncomingCallEvent(JLjava/lang/String;)V
    .locals 4

    .line 245
    iget-object v0, p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string/jumbo v1, "telecom"

    .line 246
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telecom/TelecomManager;

    if-eqz v0, :cond_1

    .line 249
    new-instance v1, Landroid/os/Bundle;

    invoke-direct {v1}, Landroid/os/Bundle;-><init>()V

    if-eqz p3, :cond_0

    const/4 v2, 0x0

    const-string/jumbo v3, "tel"

    .line 252
    invoke-static {v3, p3, v2}, Landroid/net/Uri;->fromParts(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p3

    const-string v2, "android.telecom.extra.INCOMING_CALL_ADDRESS"

    .line 254
    invoke-virtual {v1, v2, p3}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    :cond_0
    const-string p3, "android.telecom.extra.CALL_CREATED_EPOCH_TIME_MILLIS"

    .line 259
    invoke-virtual {v1, p3, p1, p2}, Landroid/os/Bundle;->putLong(Ljava/lang/String;J)V

    .line 260
    iget-object p0, p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {p0}, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->makePstnPhoneAccountHandle(Lcom/android/internal/telephony/Phone;)Landroid/telecom/PhoneAccountHandle;

    move-result-object p0

    invoke-virtual {v0, p0, v1}, Landroid/telecom/TelecomManager;->addNewIncomingCall(Landroid/telecom/PhoneAccountHandle;Landroid/os/Bundle;)V

    :cond_1
    return-void
.end method

.method private getEpochTime(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)J
    .locals 2

    .line 127
    invoke-static {}, Ljava/time/LocalDateTime;->now()Ljava/time/LocalDateTime;

    move-result-object p0

    .line 128
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 130
    invoke-virtual {p0}, Ljava/time/LocalDateTime;->getYear()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    :cond_0
    const-string/jumbo v0, "yyyyMMddHHmm"

    .line 138
    invoke-static {v0}, Ljava/time/format/DateTimeFormatter;->ofPattern(Ljava/lang/String;)Ljava/time/format/DateTimeFormatter;

    move-result-object v0

    .line 139
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Ljava/time/LocalDateTime;->parse(Ljava/lang/CharSequence;Ljava/time/format/DateTimeFormatter;)Ljava/time/LocalDateTime;

    move-result-object v0

    .line 140
    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p1

    add-int/lit8 p1, p1, -0x1

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    .line 141
    invoke-virtual {v0, p0}, Ljava/time/LocalDateTime;->isAfter(Ljava/time/chrono/ChronoLocalDateTime;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 143
    invoke-static {}, Ljava/time/ZoneId;->systemDefault()Ljava/time/ZoneId;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/time/LocalDateTime;->atZone(Ljava/time/ZoneId;)Ljava/time/ZonedDateTime;

    move-result-object p0

    invoke-virtual {p0}, Ljava/time/ZonedDateTime;->toInstant()Ljava/time/Instant;

    move-result-object p0

    .line 144
    invoke-virtual {p0}, Ljava/time/Instant;->toEpochMilli()J

    move-result-wide p0

    return-wide p0
.end method

.method private static makePstnPhoneAccountHandle(Lcom/android/internal/telephony/Phone;)Landroid/telecom/PhoneAccountHandle;
    .locals 2

    .line 233
    new-instance v0, Landroid/telecom/PhoneAccountHandle;

    sget-object v1, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->PSTN_CONNECTION_SERVICE_COMPONENT:Landroid/content/ComponentName;

    .line 234
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getFullIccSerialNumber()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, v1, p0}, Landroid/telecom/PhoneAccountHandle;-><init>(Landroid/content/ComponentName;Ljava/lang/String;)V

    return-object v0
.end method

.method private processSms(Landroid/telephony/SmsMessage;)Z
    .locals 14

    .line 158
    iget-object v0, p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v1, "missed_incoming_call_sms_pattern_string_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_4

    .line 160
    array-length v2, v0

    if-nez v2, :cond_0

    goto/16 :goto_7

    .line 165
    :cond_0
    array-length v2, v0

    move v3, v1

    :goto_0
    if-ge v3, v2, :cond_3

    aget-object v4, v0, v3

    const/16 v5, 0x21

    .line 168
    :try_start_0
    invoke-static {v4, v5}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;I)Ljava/util/regex/Pattern;

    move-result-object v4
    :try_end_0
    .catch Ljava/util/regex/PatternSyntaxException; {:try_start_0 .. :try_end_0} :catch_7

    .line 175
    invoke-virtual {p1}, Landroid/telephony/SmsMessage;->getMessageBody()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v4

    .line 177
    invoke-virtual {v4}, Ljava/util/regex/Matcher;->find()Z

    move-result v5

    if-eqz v5, :cond_2

    const-wide/16 v0, 0x0

    const/4 p1, 0x0

    :try_start_1
    const-string v2, "month"

    .line 179
    invoke-virtual {v4, v2}, Ljava/util/regex/Matcher;->group(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2
    :try_end_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_2

    :try_start_2
    const-string v3, "day"

    .line 180
    invoke-virtual {v4, v3}, Ljava/util/regex/Matcher;->group(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3
    :try_end_2
    .catch Ljava/lang/IllegalArgumentException; {:try_start_2 .. :try_end_2} :catch_1

    :try_start_3
    const-string v5, "hour"

    .line 181
    invoke-virtual {v4, v5}, Ljava/util/regex/Matcher;->group(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5
    :try_end_3
    .catch Ljava/lang/IllegalArgumentException; {:try_start_3 .. :try_end_3} :catch_0

    :try_start_4
    const-string v6, "minute"

    .line 182
    invoke-virtual {v4, v6}, Ljava/util/regex/Matcher;->group(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6
    :try_end_4
    .catch Ljava/lang/IllegalArgumentException; {:try_start_4 .. :try_end_4} :catch_3

    move-object v10, v2

    move-object v11, v3

    move-object v12, v5

    move-object v13, v6

    move-wide v6, v0

    goto :goto_3

    :catch_0
    move-object v5, p1

    goto :goto_2

    :catch_1
    move-object v3, p1

    goto :goto_1

    :catch_2
    move-object v2, p1

    move-object v3, v2

    :goto_1
    move-object v5, v3

    .line 192
    :catch_3
    :goto_2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    move-object v13, p1

    move-object v10, v2

    move-object v11, v3

    move-object v12, v5

    :goto_3
    :try_start_5
    const-string/jumbo v2, "year"

    .line 197
    invoke-virtual {v4, v2}, Ljava/util/regex/Matcher;->group(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2
    :try_end_5
    .catch Ljava/lang/IllegalArgumentException; {:try_start_5 .. :try_end_5} :catch_4

    move-object v9, v2

    goto :goto_4

    :catch_4
    move-object v9, p1

    :goto_4
    cmp-long v2, v6, v0

    if-nez v2, :cond_1

    move-object v8, p0

    .line 204
    :try_start_6
    invoke-direct/range {v8 .. v13}, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->getEpochTime(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)J

    move-result-wide v6

    cmp-long v0, v6, v0

    if-nez v0, :cond_1

    .line 206
    sget-object v0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->TAG:Ljava/lang/String;

    const-string v1, "Can\'t get the time. Use the current time."

    invoke-static {v0, v1}, Landroid/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 207
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_5

    goto :goto_5

    .line 213
    :catch_5
    sget-object v0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->TAG:Ljava/lang/String;

    const-string v1, "Can\'t get the time for missed incoming call"

    invoke-static {v0, v1}, Landroid/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    :goto_5
    :try_start_7
    const-string v0, "callerId"

    .line 217
    invoke-virtual {v4, v0}, Ljava/util/regex/Matcher;->group(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1
    :try_end_7
    .catch Ljava/lang/IllegalArgumentException; {:try_start_7 .. :try_end_7} :catch_6

    goto :goto_6

    .line 220
    :catch_6
    sget-object v0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->TAG:Ljava/lang/String;

    const-string v1, "Caller id is not provided or can\'t be parsed."

    invoke-static {v0, v1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 222
    :goto_6
    invoke-direct {p0, v6, v7, p1}, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->createMissedIncomingCallEvent(JLjava/lang/String;)V

    const/4 p0, 0x1

    return p0

    :catch_7
    move-exception v5

    .line 170
    sget-object v6, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->TAG:Ljava/lang/String;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Configuration error. Unexpected missed incoming call sms pattern: "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", e="

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v6, v4}, Landroid/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_0

    .line 227
    :cond_3
    sget-object p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->TAG:Ljava/lang/String;

    const-string p1, "SMS did not match any missed incoming call SMS pattern."

    invoke-static {p0, p1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 161
    :cond_4
    :goto_7
    sget-object p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->TAG:Ljava/lang/String;

    const-string p1, "Missed incoming call SMS pattern is not configured!"

    invoke-static {p0, p1}, Landroid/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    return v1
.end method


# virtual methods
.method public filter([[BLjava/lang/String;)Z
    .locals 3

    .line 96
    array-length v0, p1

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eq v0, v2, :cond_0

    return v1

    .line 100
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->mCarrierConfig:Landroid/os/PersistableBundle;

    if-eqz v0, :cond_1

    const-string v2, "missed_incoming_call_sms_originator_string_array"

    .line 101
    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 104
    aget-object p1, p1, v1

    invoke-static {p1, p2}, Landroid/telephony/SmsMessage;->createFromPdu([BLjava/lang/String;)Landroid/telephony/SmsMessage;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 106
    invoke-virtual {p1}, Landroid/telephony/SmsMessage;->getOriginatingAddress()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p2

    if-nez p2, :cond_1

    .line 107
    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p2

    invoke-virtual {p1}, Landroid/telephony/SmsMessage;->getOriginatingAddress()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 108
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/MissedIncomingCallSmsFilter;->processSms(Landroid/telephony/SmsMessage;)Z

    move-result p0

    return p0

    :cond_1
    return v1
.end method
