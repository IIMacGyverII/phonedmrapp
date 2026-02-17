.class public final enum Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
.super Ljava/lang/Enum;
.source "ComprehensionTlvTag.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/cat/ComprehensionTlvTag;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum ACTIVATE_DESCRIPTOR:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum ADDRESS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum ALPHA_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum BATTERY_STATE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum BEARER_DESCRIPTION:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum BROWSER_TERMINATION_CAUSE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum BUFFER_SIZE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum CAUSE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum CHANNEL_DATA:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum CHANNEL_DATA_LENGTH:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum CHANNEL_STATUS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum COMMAND_DETAILS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum DATE_TIME_AND_TIMEZONE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum DEFAULT_TEXT:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum DEVICE_IDENTITIES:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum DNS_SERVER_ADDRESS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum DURATION:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum EVENT_LIST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum FILE_LIST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum HELP_REQUEST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum ICON_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum IMMEDIATE_RESPONSE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum ITEM:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum ITEM_ICON_ID_LIST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum ITEM_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum LANGUAGE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum NETWORK_ACCESS_NAME:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum NEXT_ACTION_INDICATOR:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum OTHER_ADDRESS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum RESPONSE_LENGTH:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum RESULT:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum SIM_ME_INTERFACE_TRANSPORT_LEVEL:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum SMS_TPDU:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum TEXT_ATTRIBUTE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum TEXT_STRING:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum TONE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum TRANSACTION_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum URL:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

.field public static final enum USSD_STRING:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field


# instance fields
.field private mValue:I


# direct methods
.method static constructor <clinit>()V
    .locals 42

    .line 29
    new-instance v0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v1, "COMMAND_DETAILS"

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->COMMAND_DETAILS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 31
    new-instance v1, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v2, "DEVICE_IDENTITIES"

    const/4 v4, 0x2

    invoke-direct {v1, v2, v3, v4}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v1, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->DEVICE_IDENTITIES:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 33
    new-instance v2, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v5, "RESULT"

    const/4 v6, 0x3

    invoke-direct {v2, v5, v4, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v2, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->RESULT:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 35
    new-instance v5, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v7, "DURATION"

    const/4 v8, 0x4

    invoke-direct {v5, v7, v6, v8}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v5, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->DURATION:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 36
    new-instance v7, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v9, "ALPHA_ID"

    const/4 v10, 0x5

    invoke-direct {v7, v9, v8, v10}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v7, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ALPHA_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 38
    new-instance v9, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v11, "ADDRESS"

    const/4 v12, 0x6

    invoke-direct {v9, v11, v10, v12}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v9, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ADDRESS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 40
    new-instance v11, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v13, "USSD_STRING"

    const/16 v14, 0xa

    invoke-direct {v11, v13, v12, v14}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v11, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->USSD_STRING:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 42
    new-instance v13, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v15, "SMS_TPDU"

    const/4 v12, 0x7

    const/16 v10, 0xb

    invoke-direct {v13, v15, v12, v10}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v13, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->SMS_TPDU:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 44
    new-instance v12, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v15, "TEXT_STRING"

    const/16 v8, 0x8

    const/16 v6, 0xd

    invoke-direct {v12, v15, v8, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v12, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->TEXT_STRING:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 46
    new-instance v8, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v15, "TONE"

    const/16 v4, 0x9

    const/16 v3, 0xe

    invoke-direct {v8, v15, v4, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v8, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->TONE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 47
    new-instance v4, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v15, "ITEM"

    const/16 v3, 0xf

    invoke-direct {v4, v15, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v4, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ITEM:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 48
    new-instance v15, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "ITEM_ID"

    const/16 v3, 0x10

    invoke-direct {v15, v14, v10, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v15, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ITEM_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 49
    new-instance v14, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "RESPONSE_LENGTH"

    const/16 v3, 0xc

    const/16 v6, 0x11

    invoke-direct {v14, v10, v3, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v14, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->RESPONSE_LENGTH:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 50
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "FILE_LIST"

    const/16 v6, 0x12

    move-object/from16 v16, v14

    const/16 v14, 0xd

    invoke-direct {v3, v10, v14, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->FILE_LIST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 51
    new-instance v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "HELP_REQUEST"

    const/16 v6, 0x15

    move-object/from16 v17, v3

    const/16 v3, 0xe

    invoke-direct {v10, v14, v3, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->HELP_REQUEST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 52
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "DEFAULT_TEXT"

    const/16 v6, 0x17

    move-object/from16 v18, v10

    const/16 v10, 0xf

    invoke-direct {v3, v14, v10, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->DEFAULT_TEXT:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 53
    new-instance v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "EVENT_LIST"

    const/16 v6, 0x19

    move-object/from16 v19, v3

    const/16 v3, 0x10

    invoke-direct {v10, v14, v3, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->EVENT_LIST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 54
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "ICON_ID"

    const/16 v6, 0x1e

    move-object/from16 v20, v10

    const/16 v10, 0x11

    invoke-direct {v3, v14, v10, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ICON_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 56
    new-instance v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "ITEM_ICON_ID_LIST"

    const/16 v6, 0x1f

    move-object/from16 v21, v3

    const/16 v3, 0x12

    invoke-direct {v10, v14, v3, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ITEM_ICON_ID_LIST:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 57
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "IMMEDIATE_RESPONSE"

    const/16 v6, 0x13

    move-object/from16 v22, v10

    const/16 v10, 0x2b

    invoke-direct {v3, v14, v6, v10}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->IMMEDIATE_RESPONSE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 58
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "LANGUAGE"

    const/16 v14, 0x14

    move-object/from16 v23, v3

    const/16 v3, 0x2d

    invoke-direct {v6, v10, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->LANGUAGE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 59
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "URL"

    const/16 v14, 0x31

    move-object/from16 v24, v6

    const/16 v6, 0x15

    invoke-direct {v3, v10, v6, v14}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->URL:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 60
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "BROWSER_TERMINATION_CAUSE"

    const/16 v14, 0x16

    move-object/from16 v25, v3

    const/16 v3, 0x34

    invoke-direct {v6, v10, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->BROWSER_TERMINATION_CAUSE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 61
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "TEXT_ATTRIBUTE"

    const/16 v14, 0x50

    move-object/from16 v26, v6

    const/16 v6, 0x17

    invoke-direct {v3, v10, v6, v14}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->TEXT_ATTRIBUTE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 65
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "CAUSE"

    const/16 v14, 0x18

    move-object/from16 v27, v3

    const/16 v3, 0x1a

    invoke-direct {v6, v10, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->CAUSE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 66
    new-instance v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "TRANSACTION_ID"

    const/16 v3, 0x1c

    move-object/from16 v28, v6

    const/16 v6, 0x19

    invoke-direct {v10, v14, v6, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v10, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->TRANSACTION_ID:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 67
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v14, "BEARER_DESCRIPTION"

    const/16 v3, 0x35

    move-object/from16 v29, v10

    const/16 v10, 0x1a

    invoke-direct {v6, v14, v10, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->BEARER_DESCRIPTION:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 68
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "CHANNEL_DATA"

    const/16 v14, 0x1b

    move-object/from16 v30, v6

    const/16 v6, 0x36

    invoke-direct {v3, v10, v14, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->CHANNEL_DATA:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 69
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "CHANNEL_DATA_LENGTH"

    const/16 v14, 0x37

    move-object/from16 v31, v3

    const/16 v3, 0x1c

    invoke-direct {v6, v10, v3, v14}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->CHANNEL_DATA_LENGTH:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 70
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "CHANNEL_STATUS"

    const/16 v14, 0x1d

    move-object/from16 v32, v6

    const/16 v6, 0x38

    invoke-direct {v3, v10, v14, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->CHANNEL_STATUS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 71
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "BUFFER_SIZE"

    const/16 v14, 0x39

    move-object/from16 v33, v3

    const/16 v3, 0x1e

    invoke-direct {v6, v10, v3, v14}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->BUFFER_SIZE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 72
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "SIM_ME_INTERFACE_TRANSPORT_LEVEL"

    const/16 v14, 0x3c

    move-object/from16 v34, v6

    const/16 v6, 0x1f

    invoke-direct {v3, v10, v6, v14}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->SIM_ME_INTERFACE_TRANSPORT_LEVEL:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 73
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "OTHER_ADDRESS"

    const/16 v14, 0x20

    move-object/from16 v35, v3

    const/16 v3, 0x3e

    invoke-direct {v6, v10, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->OTHER_ADDRESS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 74
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "DNS_SERVER_ADDRESS"

    const/16 v14, 0x21

    move-object/from16 v36, v6

    const/16 v6, 0x40

    invoke-direct {v3, v10, v14, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->DNS_SERVER_ADDRESS:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 75
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "NETWORK_ACCESS_NAME"

    const/16 v14, 0x22

    move-object/from16 v37, v3

    const/16 v3, 0x47

    invoke-direct {v6, v10, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->NETWORK_ACCESS_NAME:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 76
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "NEXT_ACTION_INDICATOR"

    const/16 v14, 0x23

    move-object/from16 v38, v6

    const/16 v6, 0x18

    invoke-direct {v3, v10, v14, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->NEXT_ACTION_INDICATOR:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 77
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "DATE_TIME_AND_TIMEZONE"

    const/16 v14, 0x24

    move-object/from16 v39, v3

    const/16 v3, 0x26

    invoke-direct {v6, v10, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->DATE_TIME_AND_TIMEZONE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 78
    new-instance v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "BATTERY_STATE"

    const/16 v14, 0x25

    move-object/from16 v40, v6

    const/16 v6, 0x63

    invoke-direct {v3, v10, v14, v6}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->BATTERY_STATE:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    .line 79
    new-instance v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const-string v10, "ACTIVATE_DESCRIPTOR"

    const/16 v14, 0x26

    move-object/from16 v41, v3

    const/16 v3, 0x7b

    invoke-direct {v6, v10, v14, v3}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;-><init>(Ljava/lang/String;II)V

    sput-object v6, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->ACTIVATE_DESCRIPTOR:Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const/16 v3, 0x27

    new-array v3, v3, [Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    const/4 v10, 0x0

    aput-object v0, v3, v10

    const/4 v0, 0x1

    aput-object v1, v3, v0

    const/4 v0, 0x2

    aput-object v2, v3, v0

    const/4 v0, 0x3

    aput-object v5, v3, v0

    const/4 v0, 0x4

    aput-object v7, v3, v0

    const/4 v0, 0x5

    aput-object v9, v3, v0

    const/4 v0, 0x6

    aput-object v11, v3, v0

    const/4 v0, 0x7

    aput-object v13, v3, v0

    const/16 v0, 0x8

    aput-object v12, v3, v0

    const/16 v0, 0x9

    aput-object v8, v3, v0

    const/16 v0, 0xa

    aput-object v4, v3, v0

    const/16 v0, 0xb

    aput-object v15, v3, v0

    const/16 v0, 0xc

    aput-object v16, v3, v0

    const/16 v0, 0xd

    aput-object v17, v3, v0

    const/16 v0, 0xe

    aput-object v18, v3, v0

    const/16 v0, 0xf

    aput-object v19, v3, v0

    const/16 v0, 0x10

    aput-object v20, v3, v0

    const/16 v0, 0x11

    aput-object v21, v3, v0

    const/16 v0, 0x12

    aput-object v22, v3, v0

    const/16 v0, 0x13

    aput-object v23, v3, v0

    const/16 v0, 0x14

    aput-object v24, v3, v0

    const/16 v0, 0x15

    aput-object v25, v3, v0

    const/16 v0, 0x16

    aput-object v26, v3, v0

    const/16 v0, 0x17

    aput-object v27, v3, v0

    const/16 v0, 0x18

    aput-object v28, v3, v0

    const/16 v0, 0x19

    aput-object v29, v3, v0

    const/16 v0, 0x1a

    aput-object v30, v3, v0

    const/16 v0, 0x1b

    aput-object v31, v3, v0

    const/16 v0, 0x1c

    aput-object v32, v3, v0

    const/16 v0, 0x1d

    aput-object v33, v3, v0

    const/16 v0, 0x1e

    aput-object v34, v3, v0

    const/16 v0, 0x1f

    aput-object v35, v3, v0

    const/16 v0, 0x20

    aput-object v36, v3, v0

    const/16 v0, 0x21

    aput-object v37, v3, v0

    const/16 v0, 0x22

    aput-object v38, v3, v0

    const/16 v0, 0x23

    aput-object v39, v3, v0

    const/16 v0, 0x24

    aput-object v40, v3, v0

    const/16 v0, 0x25

    aput-object v41, v3, v0

    const/16 v0, 0x26

    aput-object v6, v3, v0

    .line 28
    sput-object v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->$VALUES:[Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;II)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)V"
        }
    .end annotation

    .line 84
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 85
    iput p3, p0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->mValue:I

    return-void
.end method

.method public static fromInt(I)Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .locals 5

    .line 99
    invoke-static {}, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->values()[Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 100
    iget v4, v3, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->mValue:I

    if-ne v4, p0, :cond_0

    return-object v3

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .locals 1

    .line 28
    const-class v0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/cat/ComprehensionTlvTag;
    .locals 1

    .line 28
    sget-object v0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->$VALUES:[Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/cat/ComprehensionTlvTag;

    return-object v0
.end method


# virtual methods
.method public value()I
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 95
    iget p0, p0, Lcom/android/internal/telephony/cat/ComprehensionTlvTag;->mValue:I

    return p0
.end method
