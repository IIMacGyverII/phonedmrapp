.class public Lcom/pri/prizeinterphone/constant/Constants;
.super Ljava/lang/Object;
.source "Constants.java"


# static fields
.field public static final CHANNEL_FRQC_BAND_U_LIMIT_MAX:I = 0x1c9c3800

.field public static final CHANNEL_FRQC_BAND_U_LIMIT_MIN:I = 0x17d78400

.field public static final CHANNEL_FRQC_BAND_V_LIMIT_MAX:I = 0xa5f0780

.field public static final CHANNEL_FRQC_BAND_V_LIMIT_MIN:I = 0x81b3200

.field public static DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field public static final DEF_MODULE_VERSION:Ljava/lang/String; = "DMR003.UV4T.V022"

.field public static final KEY_CHANNEL_AREA_AUS:Ljava/lang/String; = "channel_area_aus"

.field public static final KEY_CHANNEL_AREA_CHINA:Ljava/lang/String; = "channel_area_cn"

.field public static final KEY_CHANNEL_AREA_CHINA_TW:Ljava/lang/String; = "channel_area_tw"

.field public static final KEY_CHANNEL_AREA_DEFAULT:Ljava/lang/String; = "channel_area_default"

.field public static final KEY_CHANNEL_AREA_DEFAULT_UHF:Ljava/lang/String; = "channel_area_default_uhf"

.field public static final KEY_CHANNEL_AREA_DEFAULT_VHF:Ljava/lang/String; = "channel_area_default_vhf"

.field public static final KEY_CHANNEL_AREA_EU:Ljava/lang/String; = "channel_area_eu"

.field public static final KEY_CHANNEL_AREA_IRAN:Ljava/lang/String; = "channel_area_iran"

.field public static final KEY_CHANNEL_AREA_JAPAN:Ljava/lang/String; = "channel_area_japan"

.field public static final KEY_CHANNEL_AREA_KOREA:Ljava/lang/String; = "channel_area_ko"

.field public static final KEY_CHANNEL_AREA_MALAYSIA:Ljava/lang/String; = "channel_area_malaysia"

.field public static final KEY_CHANNEL_AREA_NORWAY:Ljava/lang/String; = "channel_area_norway"

.field public static final KEY_CHANNEL_AREA_PREFIX:Ljava/lang/String; = "channel_area_"

.field public static final KEY_CHANNEL_AREA_RUS:Ljava/lang/String; = "channel_area_rus"

.field public static final KEY_CHANNEL_AREA_SOUTH_AF:Ljava/lang/String; = "channel_area_south_af"

.field public static final KEY_CHANNEL_AREA_USA:Ljava/lang/String; = "channel_area_usa"

.field public static final KEY_DEF_AREA:Ljava/lang/String;

.field public static final KEY_EXTRA_AREA_CHANNEL:Ljava/lang/String; = "extra_channel_area_"

.field public static final MODULE_FRQC_BAND_U:Ljava/lang/String; = "U"

.field public static final MODULE_FRQC_BAND_UV:Ljava/lang/String; = "UV"

.field public static final MODULE_FRQC_BAND_V:Ljava/lang/String; = "V"

.field private static final TAG:Ljava/lang/String; = "Constants"


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 78
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    .line 136
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "channel_area_default_uhf"

    goto :goto_0

    :cond_0
    const-string v0, "channel_area_default"

    .line 137
    :goto_0
    sput-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getChannelAreaName(Landroid/content/Context;)Ljava/lang/String;
    .locals 1

    .line 245
    invoke-static {p0}, Lcom/pri/prizeinterphone/constant/Constants;->getSelectedChannelArea(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 246
    invoke-static {p0, v0}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static getChannelAreaName(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 235
    invoke-static {p0}, Lcom/pri/prizeinterphone/constant/Constants;->getSavedChannelAreas(Landroid/content/Context;)Ljava/util/LinkedHashMap;

    move-result-object v0

    .line 236
    invoke-static {p0, v0, p1}, Lcom/pri/prizeinterphone/constant/Constants;->getChannelAreaName(Landroid/content/Context;Ljava/util/LinkedHashMap;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static getChannelAreaName(Landroid/content/Context;Ljava/util/LinkedHashMap;Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/String;"
        }
    .end annotation

    if-eqz p1, :cond_2

    .line 208
    invoke-virtual {p1}, Ljava/util/LinkedHashMap;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    .line 209
    invoke-virtual {p1}, Ljava/util/LinkedHashMap;->entrySet()Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    .line 210
    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 211
    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 212
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    const-string p1, "channel_area_"

    .line 213
    invoke-virtual {v0, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 214
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    const-string/jumbo p2, "string"

    const-string v1, "com.pri.prizeinterphone"

    invoke-virtual {p1, v0, p2, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 215
    invoke-virtual {p0, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_1
    const-string p0, "extra_channel_area_"

    .line 216
    invoke-virtual {p2, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    return-object v0

    :cond_2
    const-string p0, ""

    return-object p0
.end method

.method public static getSavedChannelAreas(Landroid/content/Context;)Ljava/util/LinkedHashMap;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 169
    new-instance v0, Lcom/google/gson/Gson;

    invoke-direct {v0}, Lcom/google/gson/Gson;-><init>()V

    const-string v1, "pref_person_device_area_list"

    const-string v2, ""

    .line 170
    invoke-static {p0, v1, v2}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 172
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 173
    sget-object v2, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    invoke-virtual {v0, v2}, Lcom/google/gson/Gson;->toJson(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 174
    sget-object p0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    return-object p0

    .line 176
    :cond_0
    new-instance p0, Lcom/pri/prizeinterphone/constant/Constants$1;

    invoke-direct {p0}, Lcom/pri/prizeinterphone/constant/Constants$1;-><init>()V

    .line 177
    invoke-virtual {p0}, Lcom/google/gson/reflect/TypeToken;->getType()Ljava/lang/reflect/Type;

    move-result-object p0

    .line 178
    invoke-virtual {v0, v2, p0}, Lcom/google/gson/Gson;->fromJson(Ljava/lang/String;Ljava/lang/reflect/Type;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/LinkedHashMap;

    return-object p0
.end method

.method public static getSelectedChannelArea(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 255
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->KEY_DEF_AREA:Ljava/lang/String;

    const-string v1, "pref_person_channel_area_selected_index"

    invoke-static {p0, v1, v0}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static initDefChannelAreas()V
    .locals 2

    const-string v0, "Constants"

    const-string v1, "initDefChannelAreas"

    .line 141
    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 142
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->clear()V

    .line 143
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->isSupportUVFrequencyBand()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 144
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_default_uhf"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 145
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_default_vhf"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 147
    :cond_0
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_default"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 149
    :goto_0
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_cn"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 150
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_tw"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 151
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_eu"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 152
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_usa"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 153
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_aus"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 154
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_rus"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 155
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_iran"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 156
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_ko"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 157
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_malaysia"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 158
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_japan"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 159
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_norway"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 160
    sget-object v0, Lcom/pri/prizeinterphone/constant/Constants;->DEF_CHANNEL_AREAS:Ljava/util/LinkedHashMap;

    const-string v1, "channel_area_south_af"

    invoke-virtual {v0, v1, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public static randExtraChannelAreaName()Ljava/lang/String;
    .locals 3

    .line 100
    new-instance v0, Ljava/text/SimpleDateFormat;

    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v1

    const-string/jumbo v2, "yyyyMMdd_HHmmss"

    invoke-direct {v0, v2, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;Ljava/util/Locale;)V

    .line 101
    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v1}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    .line 102
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "extra_channel_area_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static saveChannelAreas(Landroid/content/Context;Ljava/util/LinkedHashMap;)Z
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)Z"
        }
    .end annotation

    const-string v0, "Constants"

    if-eqz p1, :cond_1

    .line 189
    invoke-virtual {p1}, Ljava/util/LinkedHashMap;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    .line 193
    :cond_0
    new-instance v1, Lcom/google/gson/Gson;

    invoke-direct {v1}, Lcom/google/gson/Gson;-><init>()V

    .line 194
    invoke-virtual {v1, p1}, Lcom/google/gson/Gson;->toJson(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 195
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "saveChannelAreas,savedStr="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "pref_person_device_area_list"

    .line 196
    invoke-static {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    const-string p0, "saveChannelAreas,data is null or empty"

    .line 190
    invoke-static {v0, p0}, Lcom/pri/prizeinterphone/Util/Clog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method public static saveSelectedChannelArea(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1

    const-string v0, "pref_person_channel_area_selected_index"

    .line 264
    invoke-static {p0, v0, p1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->putStringData(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
