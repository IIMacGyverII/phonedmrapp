.class public Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;
.super Ljava/lang/Object;
.source "LinkBandwidthEstimator.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/LinkBandwidthEstimator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "NetworkBandwidth"
.end annotation


# instance fields
.field private final mKey:Ljava/lang/String;

.field final synthetic this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;


# direct methods
.method constructor <init>(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;Ljava/lang/String;)V
    .locals 0

    .line 1218
    iput-object p1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 1219
    iput-object p2, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->mKey:Ljava/lang/String;

    return-void
.end method

.method private getCountKey(II)Ljava/lang/String;
    .locals 1

    .line 1241
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getDataKey(II)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "Count"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private getDataKey(II)Ljava/lang/String;
    .locals 1

    .line 1245
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1246
    iget-object p0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->mKey:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "Link"

    .line 1247
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "Level"

    .line 1248
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 1249
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private getValueKey(II)Ljava/lang/String;
    .locals 1

    .line 1237
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getDataKey(II)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "Data"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public getCount(II)I
    .locals 1

    .line 1262
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-static {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 1263
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1262
    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1264
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getCountKey(II)Ljava/lang/String;

    move-result-object p0

    const/4 p1, 0x0

    .line 1265
    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method public getValue(II)J
    .locals 1

    .line 1254
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-static {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 1255
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1254
    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1256
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getValueKey(II)Ljava/lang/String;

    move-result-object p0

    const-wide/16 p1, 0x0

    .line 1257
    invoke-interface {v0, p0, p1, p2}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide p0

    return-wide p0
.end method

.method public toString()Ljava/lang/String;
    .locals 11

    .line 1270
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1271
    iget-object v1, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->mKey:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n"

    .line 1272
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    const/4 v4, 0x2

    if-ge v3, v4, :cond_4

    if-nez v3, :cond_0

    const-string/jumbo v4, "tx"

    goto :goto_1

    :cond_0
    const-string v4, "rx"

    .line 1274
    :goto_1
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\n avgKbps"

    .line 1275
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v4, v2

    :goto_2
    const-string v5, " "

    const/4 v6, 0x5

    if-ge v4, v6, :cond_2

    .line 1277
    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getCount(II)I

    move-result v6

    if-nez v6, :cond_1

    move v6, v2

    goto :goto_3

    .line 1278
    :cond_1
    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getValue(II)J

    move-result-wide v7

    int-to-long v9, v6

    div-long/2addr v7, v9

    long-to-int v6, v7

    .line 1279
    :goto_3
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    :cond_2
    const-string v4, "\n count"

    .line 1281
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v4, v2

    :goto_4
    if-ge v4, v6, :cond_3

    .line 1283
    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getCount(II)I

    move-result v7

    .line 1284
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    add-int/lit8 v4, v4, 0x1

    goto :goto_4

    .line 1286
    :cond_3
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 1288
    :cond_4
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public update(JII)V
    .locals 4

    .line 1224
    iget-object v0, p0, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->this$0:Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    invoke-static {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->-$$Nest$fgetmPhone(Lcom/android/internal/telephony/data/LinkBandwidthEstimator;)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 1225
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1224
    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1226
    invoke-direct {p0, p3, p4}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getValueKey(II)Ljava/lang/String;

    move-result-object v1

    .line 1227
    invoke-direct {p0, p3, p4}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator$NetworkBandwidth;->getCountKey(II)Ljava/lang/String;

    move-result-object p0

    .line 1228
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p3

    const-wide/16 v2, 0x0

    .line 1229
    invoke-interface {v0, v1, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v2

    const/4 p4, 0x0

    .line 1230
    invoke-interface {v0, p0, p4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p4

    add-long/2addr v2, p1

    .line 1231
    invoke-interface {p3, v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 p4, p4, 0x1

    .line 1232
    invoke-interface {p3, p0, p4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 1233
    invoke-interface {p3}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method
