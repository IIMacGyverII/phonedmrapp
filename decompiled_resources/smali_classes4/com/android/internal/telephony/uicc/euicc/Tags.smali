.class Lcom/android/internal/telephony/uicc/euicc/Tags;
.super Ljava/lang/Object;
.source "Tags.java"


# static fields
.field static final EUICC_PROFILE_MEP_TAGS:[B

.field static final EUICC_PROFILE_TAGS:[B

.field static final TAG_AR_DO:I = 0xe3

.field static final TAG_AUTHENTICATE_SERVER:I = 0xbf38

.field static final TAG_CANCEL_SESSION:I = 0xbf41

.field static final TAG_CARRIER_PRIVILEGE_RULES:I = 0xbf76

.field static final TAG_CTX_0:I = 0x80

.field static final TAG_CTX_1:I = 0x81

.field static final TAG_CTX_10:I = 0x8a

.field static final TAG_CTX_2:I = 0x82

.field static final TAG_CTX_3:I = 0x83

.field static final TAG_CTX_4:I = 0x84

.field static final TAG_CTX_5:I = 0x85

.field static final TAG_CTX_6:I = 0x86

.field static final TAG_CTX_7:I = 0x87

.field static final TAG_CTX_8:I = 0x88

.field static final TAG_CTX_9:I = 0x89

.field static final TAG_CTX_COMP_0:I = 0xa0

.field static final TAG_CTX_COMP_1:I = 0xa1

.field static final TAG_CTX_COMP_2:I = 0xa2

.field static final TAG_CTX_COMP_3:I = 0xa3

.field static final TAG_DELETE_PROFILE:I = 0xbf33

.field static final TAG_DEVICE_APP_ID_REF_DO:I = 0xc1

.field static final TAG_DISABLE_PROFILE:I = 0xbf32

.field static final TAG_EID:I = 0x5a

.field static final TAG_ENABLE_PROFILE:I = 0xbf31

.field static final TAG_EUICC_MEMORY_RESET:I = 0xbf34

.field static final TAG_EVENT:I = 0x81

.field static final TAG_GET_CONFIGURED_ADDRESSES:I = 0xbf3c

.field static final TAG_GET_EID:I = 0xbf3e

.field static final TAG_GET_EUICC_CHALLENGE:I = 0xbf2e

.field static final TAG_GET_EUICC_INFO_1:I = 0xbf20

.field static final TAG_GET_EUICC_INFO_2:I = 0xbf22

.field static final TAG_GET_PROFILES:I = 0xbf2d

.field static final TAG_GET_RAT:I = 0xbf43

.field static final TAG_ICCID:I = 0x5a

.field static final TAG_INITIALISE_SECURE_CHANNEL:I = 0xbf23

.field static final TAG_LIST_NOTIFICATION:I = 0xbf28

.field static final TAG_NICKNAME:I = 0x90

.field static final TAG_NOTIFICATION_METADATA:I = 0xbf2f

.field static final TAG_OPERATOR_ID:I = 0xb7

.field static final TAG_PERM_AR_DO:I = 0xdb

.field static final TAG_PKG_REF_DO:I = 0xca

.field static final TAG_PORT:I = 0x9f24

.field static final TAG_PREPARE_DOWNLOAD:I = 0xbf21

.field static final TAG_PROFILE_CLASS:I = 0x95

.field static final TAG_PROFILE_INFO:I = 0xe3

.field static final TAG_PROFILE_INSTALLATION_RESULT:I = 0xbf37

.field static final TAG_PROFILE_INSTALLATION_RESULT_DATA:I = 0xbf27

.field static final TAG_PROFILE_NAME:I = 0x92

.field static final TAG_PROFILE_POLICY_RULE:I = 0x99

.field static final TAG_PROFILE_STATE:I = 0x9f70

.field static final TAG_REF_AR_DO:I = 0xe2

.field static final TAG_REF_DO:I = 0xe1

.field static final TAG_REMOVE_NOTIFICATION_FROM_LIST:I = 0xbf30

.field static final TAG_RETRIEVE_NOTIFICATIONS_LIST:I = 0xbf2b

.field static final TAG_SEQ:I = 0x80

.field static final TAG_SEQUENCE:I = 0x30

.field static final TAG_SERVICE_PROVIDER_NAME:I = 0x91

.field static final TAG_SET_DEFAULT_SMDP_ADDRESS:I = 0xbf3f

.field static final TAG_SET_NICKNAME:I = 0xbf29

.field static final TAG_TAG_LIST:I = 0x5c

.field static final TAG_TARGET_ADDR:I = 0xc

.field static final TAG_UNI_2:I = 0x2

.field static final TAG_UNI_4:I = 0x4


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/16 v0, 0xb

    new-array v0, v0, [B

    .line 98
    fill-array-data v0, :array_0

    sput-object v0, Lcom/android/internal/telephony/uicc/euicc/Tags;->EUICC_PROFILE_TAGS:[B

    const/16 v0, 0xd

    new-array v0, v0, [B

    .line 113
    fill-array-data v0, :array_1

    sput-object v0, Lcom/android/internal/telephony/uicc/euicc/Tags;->EUICC_PROFILE_MEP_TAGS:[B

    return-void

    nop

    :array_0
    .array-data 1
        0x5at
        -0x70t
        -0x6ft
        -0x6et
        -0x49t
        -0x61t
        0x70t
        -0x6bt
        -0x67t
        -0x41t
        0x76t
    .end array-data

    :array_1
    .array-data 1
        0x5at
        -0x70t
        -0x6ft
        -0x6et
        -0x49t
        -0x61t
        0x70t
        -0x6bt
        -0x67t
        -0x41t
        0x76t
        -0x61t
        0x24t
    .end array-data
.end method

.method private constructor <init>()V
    .locals 0

    .line 129
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
