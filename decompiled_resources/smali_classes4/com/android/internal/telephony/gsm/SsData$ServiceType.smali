.class public final enum Lcom/android/internal/telephony/gsm/SsData$ServiceType;
.super Ljava/lang/Enum;
.source "SsData.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/gsm/SsData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "ServiceType"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/gsm/SsData$ServiceType;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_ALL_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_BAIC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_BAIC_ROAMING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_BAOC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_BAOIC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_BAOIC_EXC_HOME:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CFU:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CF_ALL:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CF_ALL_CONDITIONAL:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CF_BUSY:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CF_NOT_REACHABLE:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CF_NO_REPLY:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CLIP:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_CLIR:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_COLP:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_COLR:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_INCOMING_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_OUTGOING_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

.field public static final enum SS_WAIT:Lcom/android/internal/telephony/gsm/SsData$ServiceType;


# direct methods
.method static constructor <clinit>()V
    .locals 22

    .line 33
    new-instance v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v1, "SS_CFU"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CFU:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 34
    new-instance v1, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v3, "SS_CF_BUSY"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_BUSY:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 35
    new-instance v3, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v5, "SS_CF_NO_REPLY"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_NO_REPLY:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 36
    new-instance v5, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v7, "SS_CF_NOT_REACHABLE"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_NOT_REACHABLE:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 37
    new-instance v7, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v9, "SS_CF_ALL"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_ALL:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 38
    new-instance v9, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v11, "SS_CF_ALL_CONDITIONAL"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_ALL_CONDITIONAL:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 39
    new-instance v11, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v13, "SS_CLIP"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v11, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CLIP:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 40
    new-instance v13, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v15, "SS_CLIR"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v13, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CLIR:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 41
    new-instance v15, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v14, "SS_COLP"

    const/16 v12, 0x8

    invoke-direct {v15, v14, v12}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v15, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_COLP:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 42
    new-instance v14, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v12, "SS_COLR"

    const/16 v10, 0x9

    invoke-direct {v14, v12, v10}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v14, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_COLR:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 43
    new-instance v12, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v10, "SS_WAIT"

    const/16 v8, 0xa

    invoke-direct {v12, v10, v8}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v12, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_WAIT:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 44
    new-instance v10, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v8, "SS_BAOC"

    const/16 v6, 0xb

    invoke-direct {v10, v8, v6}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v10, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAOC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 45
    new-instance v8, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v6, "SS_BAOIC"

    const/16 v4, 0xc

    invoke-direct {v8, v6, v4}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v8, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAOIC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 46
    new-instance v6, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v4, "SS_BAOIC_EXC_HOME"

    const/16 v2, 0xd

    invoke-direct {v6, v4, v2}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v6, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAOIC_EXC_HOME:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 47
    new-instance v4, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v2, "SS_BAIC"

    move-object/from16 v17, v6

    const/16 v6, 0xe

    invoke-direct {v4, v2, v6}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v4, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAIC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 48
    new-instance v2, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v6, "SS_BAIC_ROAMING"

    move-object/from16 v18, v4

    const/16 v4, 0xf

    invoke-direct {v2, v6, v4}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v2, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAIC_ROAMING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 49
    new-instance v6, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v4, "SS_ALL_BARRING"

    move-object/from16 v19, v2

    const/16 v2, 0x10

    invoke-direct {v6, v4, v2}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v6, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_ALL_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 50
    new-instance v4, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v2, "SS_OUTGOING_BARRING"

    move-object/from16 v20, v6

    const/16 v6, 0x11

    invoke-direct {v4, v2, v6}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v4, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_OUTGOING_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 51
    new-instance v2, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const-string v6, "SS_INCOMING_BARRING"

    move-object/from16 v21, v4

    const/16 v4, 0x12

    invoke-direct {v2, v6, v4}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;-><init>(Ljava/lang/String;I)V

    sput-object v2, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_INCOMING_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const/16 v6, 0x13

    new-array v6, v6, [Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    const/16 v16, 0x0

    aput-object v0, v6, v16

    const/4 v0, 0x1

    aput-object v1, v6, v0

    const/4 v0, 0x2

    aput-object v3, v6, v0

    const/4 v0, 0x3

    aput-object v5, v6, v0

    const/4 v0, 0x4

    aput-object v7, v6, v0

    const/4 v0, 0x5

    aput-object v9, v6, v0

    const/4 v0, 0x6

    aput-object v11, v6, v0

    const/4 v0, 0x7

    aput-object v13, v6, v0

    const/16 v0, 0x8

    aput-object v15, v6, v0

    const/16 v0, 0x9

    aput-object v14, v6, v0

    const/16 v0, 0xa

    aput-object v12, v6, v0

    const/16 v0, 0xb

    aput-object v10, v6, v0

    const/16 v0, 0xc

    aput-object v8, v6, v0

    const/16 v0, 0xd

    aput-object v17, v6, v0

    const/16 v0, 0xe

    aput-object v18, v6, v0

    const/16 v0, 0xf

    aput-object v19, v6, v0

    const/16 v0, 0x10

    aput-object v20, v6, v0

    const/16 v0, 0x11

    aput-object v21, v6, v0

    aput-object v2, v6, v4

    .line 32
    sput-object v6, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->$VALUES:[Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 32
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/gsm/SsData$ServiceType;
    .locals 1

    .line 32
    const-class v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/gsm/SsData$ServiceType;
    .locals 1

    .line 32
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->$VALUES:[Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/gsm/SsData$ServiceType;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    return-object v0
.end method


# virtual methods
.method public isTypeBarring()Z
    .locals 1

    .line 76
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAOC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAOIC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAOIC_EXC_HOME:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAIC:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_BAIC_ROAMING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_ALL_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_OUTGOING_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_INCOMING_BARRING:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public isTypeCF()Z
    .locals 1

    .line 54
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CFU:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_BUSY:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_NO_REPLY:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_NOT_REACHABLE:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_ALL:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_ALL_CONDITIONAL:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public isTypeCW()Z
    .locals 1

    .line 64
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_WAIT:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isTypeClip()Z
    .locals 1

    .line 68
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CLIP:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isTypeClir()Z
    .locals 1

    .line 72
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CLIR:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isTypeUnConditional()Z
    .locals 1

    .line 60
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CFU:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->SS_CF_ALL:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method
