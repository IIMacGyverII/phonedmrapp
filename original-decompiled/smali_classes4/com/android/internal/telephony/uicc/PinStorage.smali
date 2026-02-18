.class public Lcom/android/internal/telephony/uicc/PinStorage;
.super Landroid/os/Handler;
.source "PinStorage.java"


# static fields
.field private static final ANDROID_KEY_STORE_PROVIDER:Ljava/lang/String; = "AndroidKeyStore"

.field private static final CARRIER_CONFIG_CHANGED_EVENT:I = 0x2

.field private static final CIPHER_TRANSFORMATION:Ljava/lang/String; = "AES/GCM/NoPadding"

.field private static final GCM_PARAMETER_TAG_BIT_LEN:I = 0x80

.field private static final ICC_CHANGED_EVENT:I = 0x1

.field private static final KEYSTORE_ALIAS_LONG_TERM_ALWAYS:Ljava/lang/String; = "PinStorage_longTerm_always_key"

.field private static final KEYSTORE_ALIAS_LONG_TERM_USER_AUTH:Ljava/lang/String; = "PinStorage_longTerm_ua_key"

.field private static final KEYSTORE_ALIAS_SHORT_TERM:Ljava/lang/String; = "PinStorage_shortTerm_key"

.field private static final MAX_PIN_LENGTH:I = 0x8

.field private static final MIN_ICCID_LENGTH:I = 0xc

.field private static final MIN_PIN_LENGTH:I = 0x4

.field private static final SHARED_PREFS_AVAILABLE_PIN_BASE_KEY:Ljava/lang/String; = "encrypted_pin_available_"

.field private static final SHARED_PREFS_NAME:Ljava/lang/String; = "pinstorage_prefs"

.field private static final SHARED_PREFS_REBOOT_PIN_BASE_KEY:Ljava/lang/String; = "encrypted_pin_reboot_"

.field private static final SHARED_PREFS_STORED_PINS:Ljava/lang/String; = "stored_pins"

.field private static final SHORT_TERM_KEY_DURATION_MINUTES:I = 0xf

.field private static final SUPPLY_PIN_COMPLETE:I = 0x5

.field private static final TAG:Ljava/lang/String; = "PinStorage"

.field private static final TIMER_EXPIRATION_EVENT:I = 0x3

.field private static final TIMER_VALUE_AFTER_OTA_MILLIS:I = 0x4e20

.field private static final TIMER_VALUE_BEFORE_OTA_MILLIS:I = 0x4e20

.field private static final USER_UNLOCKED_EVENT:I = 0x4

.field private static final VDBG:Z = false


# instance fields
.field private final mBootCount:I

.field private final mCarrierConfigChangedReceiver:Landroid/content/BroadcastReceiver;

.field private final mContext:Landroid/content/Context;

.field private mIsDeviceLocked:Z

.field private mIsDeviceSecure:Z

.field private final mKeyStore:Ljava/security/KeyStore;

.field private mLastCommitResult:Z

.field private mLongTermSecretKey:Ljavax/crypto/SecretKey;

.field private final mRamStorage:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "[B>;"
        }
    .end annotation
.end field

.field private mShortTermSecretKey:Ljavax/crypto/SecretKey;

.field public mShortTermSecretKeyDurationMinutes:I
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field


# direct methods
.method static bridge synthetic -$$Nest$mvalidateSlotId(Lcom/android/internal/telephony/uicc/PinStorage;I)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->validateSlotId(I)Z

    move-result p0

    return p0
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 5

    .line 181
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    const/4 v0, 0x1

    .line 150
    iput-boolean v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLastCommitResult:Z

    .line 160
    new-instance v1, Lcom/android/internal/telephony/uicc/PinStorage$1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/uicc/PinStorage$1;-><init>(Lcom/android/internal/telephony/uicc/PinStorage;)V

    iput-object v1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mCarrierConfigChangedReceiver:Landroid/content/BroadcastReceiver;

    .line 182
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    .line 183
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getBootCount()I

    move-result v2

    iput v2, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mBootCount:I

    .line 184
    invoke-static {}, Lcom/android/internal/telephony/uicc/PinStorage;->initializeKeyStore()Ljava/security/KeyStore;

    move-result-object v2

    iput-object v2, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mKeyStore:Ljava/security/KeyStore;

    const/16 v2, 0xf

    .line 185
    iput v2, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKeyDurationMinutes:I

    .line 187
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->isDeviceSecure()Z

    move-result v2

    iput-boolean v2, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceSecure:Z

    const/4 v3, 0x0

    if-eqz v2, :cond_0

    .line 188
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->isDeviceLocked()Z

    move-result v2

    goto :goto_0

    :cond_0
    move v2, v3

    :goto_0
    iput-boolean v2, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    .line 191
    new-instance v2, Landroid/content/IntentFilter;

    invoke-direct {v2}, Landroid/content/IntentFilter;-><init>()V

    const-string v4, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 192
    invoke-virtual {v2, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v4, "android.telephony.action.SIM_CARD_STATE_CHANGED"

    .line 193
    invoke-virtual {v2, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v4, "android.telephony.action.SIM_APPLICATION_STATE_CHANGED"

    .line 194
    invoke-virtual {v2, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v4, "android.intent.action.USER_UNLOCKED"

    .line 195
    invoke-virtual {v2, v4}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 196
    invoke-virtual {p1, v1, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 202
    iget-boolean p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceSecure:Z

    if-eqz p1, :cond_2

    iget-boolean p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    if-eqz p1, :cond_1

    goto :goto_1

    :cond_1
    const-string p1, "PinStorage_longTerm_ua_key"

    goto :goto_2

    :cond_2
    :goto_1
    const-string p1, "PinStorage_longTerm_always_key"

    .line 204
    :goto_2
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->initializeSecretKey(Ljava/lang/String;Z)Ljavax/crypto/SecretKey;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLongTermSecretKey:Ljavax/crypto/SecretKey;

    .line 208
    iget-boolean p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceSecure:Z

    if-eqz p1, :cond_4

    iget-boolean p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    if-nez p1, :cond_3

    goto :goto_3

    :cond_3
    new-array p1, v3, [Ljava/lang/Object;

    const-string v0, "Device is locked - Postponing initialization"

    .line 212
    invoke-static {v0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 213
    new-instance p1, Landroid/util/SparseArray;

    invoke-direct {p1}, Landroid/util/SparseArray;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mRamStorage:Landroid/util/SparseArray;

    goto :goto_4

    :cond_4
    :goto_3
    const/4 p1, 0x0

    .line 209
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mRamStorage:Landroid/util/SparseArray;

    .line 210
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->onDeviceReady()V

    :goto_4
    return-void
.end method

.method private cleanRamStorage()V
    .locals 2

    .line 847
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result v0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_0

    .line 849
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->cleanRamStorage(I)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private cleanRamStorage(I)V
    .locals 2

    .line 855
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mRamStorage:Landroid/util/SparseArray;

    if-eqz v0, :cond_1

    .line 856
    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [B

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    .line 858
    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([BB)V

    .line 860
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mRamStorage:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->delete(I)V

    :cond_1
    return-void
.end method

.method private createSecretKey(Ljava/lang/String;Ljava/util/Date;Z)Ljavax/crypto/SecretKey;
    .locals 2

    :try_start_0
    const-string p0, "AES"

    const-string v0, "AndroidKeyStore"

    .line 1101
    invoke-static {p0, v0}, Ljavax/crypto/KeyGenerator;->getInstance(Ljava/lang/String;Ljava/lang/String;)Ljavax/crypto/KeyGenerator;

    move-result-object p0

    .line 1102
    new-instance v0, Landroid/security/keystore/KeyGenParameterSpec$Builder;

    const/4 v1, 0x3

    invoke-direct {v0, p1, v1}, Landroid/security/keystore/KeyGenParameterSpec$Builder;-><init>(Ljava/lang/String;I)V

    const-string p1, "GCM"

    filled-new-array {p1}, [Ljava/lang/String;

    move-result-object p1

    .line 1104
    invoke-virtual {v0, p1}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setBlockModes([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object p1

    const-string v0, "NoPadding"

    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v0

    .line 1105
    invoke-virtual {p1, v0}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setEncryptionPaddings([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object p1

    if-eqz p2, :cond_0

    .line 1108
    invoke-virtual {p1, p2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setKeyValidityEnd(Ljava/util/Date;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object p1

    :cond_0
    if-eqz p3, :cond_1

    const/4 p2, 0x1

    .line 1112
    invoke-virtual {p1, p2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setUserAuthenticationRequired(Z)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object p1

    const p3, 0x7fffffff

    .line 1113
    invoke-virtual {p1, p3, p2}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setUserAuthenticationParameters(II)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object p1

    .line 1115
    :cond_1
    invoke-virtual {p1}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->build()Landroid/security/keystore/KeyGenParameterSpec;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljavax/crypto/KeyGenerator;->init(Ljava/security/spec/AlgorithmParameterSpec;)V

    .line 1116
    invoke-virtual {p0}, Ljavax/crypto/KeyGenerator;->generateKey()Ljavax/crypto/SecretKey;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    const-string p1, "Create key exception"

    .line 1118
    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/4 p0, 0x0

    return-object p0
.end method

.method private decrypt(Ljavax/crypto/SecretKey;[B)[B
    .locals 4

    const/4 p0, 0x0

    if-nez p1, :cond_0

    new-array p1, p0, [Ljava/lang/Object;

    const-string p2, "Decrypt: Secret key is null"

    .line 1175
    invoke-static {p2, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    new-array p0, p0, [B

    return-object p0

    .line 1180
    :cond_0
    :try_start_0
    invoke-static {p2}, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;->parseFrom([B)Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;

    move-result-object p2

    .line 1181
    iget-object v0, p2, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;->encryptedStoredPin:[B

    invoke-static {v0}, Lcom/android/internal/util/ArrayUtils;->isEmpty([B)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p2, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;->iv:[B

    .line 1182
    invoke-static {v0}, Lcom/android/internal/util/ArrayUtils;->isEmpty([B)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "AES/GCM/NoPadding"

    .line 1183
    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v0

    .line 1184
    new-instance v1, Ljavax/crypto/spec/GCMParameterSpec;

    const/16 v2, 0x80

    iget-object v3, p2, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;->iv:[B

    invoke-direct {v1, v2, v3}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V

    const/4 v2, 0x2

    .line 1186
    invoke-virtual {v0, v2, p1, v1}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V

    .line 1187
    iget-object p1, p2, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;->encryptedStoredPin:[B

    invoke-virtual {v0, p1}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p1

    const-string p2, "Decrypt exception"

    .line 1190
    invoke-static {p2, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/16 p1, 0x150

    const/16 p2, 0x8

    const/4 v0, 0x1

    const-string v1, ""

    .line 1191
    invoke-static {p1, p2, v0, v1}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V

    :cond_1
    new-array p0, p0, [B

    return-object p0
.end method

.method private decryptStoredPin([BLjavax/crypto/SecretKey;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 0

    if-eqz p2, :cond_0

    .line 729
    :try_start_0
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->decrypt(Ljavax/crypto/SecretKey;[B)[B

    move-result-object p0

    .line 730
    array-length p1, p0

    if-lez p1, :cond_0

    .line 731
    invoke-static {p0}, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->parseFrom([B)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    const-string p1, "cannot decrypt/parse PIN information"

    .line 734
    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private deleteSecretKey(Ljava/lang/String;)V
    .locals 3

    .line 1138
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mKeyStore:Ljava/security/KeyStore;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    const-string v2, "Delete key: %s"

    .line 1139
    invoke-static {v2, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 1141
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mKeyStore:Ljava/security/KeyStore;

    invoke-virtual {p0, p1}, Ljava/security/KeyStore;->deleteEntry(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    new-array p0, v1, [Ljava/lang/Object;

    const-string p1, "Delete key exception"

    .line 1144
    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    :cond_0
    :goto_0
    return-void
.end method

.method private encrypt(Ljavax/crypto/SecretKey;[B)[B
    .locals 3

    const/4 p0, 0x0

    if-nez p1, :cond_0

    new-array p1, p0, [Ljava/lang/Object;

    const-string p2, "Encrypt: Secret key is null"

    .line 1152
    invoke-static {p2, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    new-array p0, p0, [B

    return-object p0

    :cond_0
    const/4 v0, 0x1

    :try_start_0
    const-string v1, "AES/GCM/NoPadding"

    .line 1157
    invoke-static {v1}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v1

    .line 1158
    invoke-virtual {v1, v0, p1}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;)V

    .line 1160
    new-instance p1, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;

    invoke-direct {p1}, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;-><init>()V

    .line 1161
    invoke-virtual {v1}, Ljavax/crypto/Cipher;->getIV()[B

    move-result-object v2

    iput-object v2, p1, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;->iv:[B

    .line 1162
    invoke-virtual {v1, p2}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object p2

    iput-object p2, p1, Lcom/android/internal/telephony/nano/StoredPinProto$EncryptedPin;->encryptedStoredPin:[B

    .line 1163
    invoke-static {p1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p1

    const-string p2, "Encrypt exception"

    .line 1165
    invoke-static {p2, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    const/16 p1, 0x150

    const/16 p2, 0x9

    const-string v1, ""

    .line 1166
    invoke-static {p1, p2, v0, v1}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V

    new-array p0, p0, [B

    return-object p0
.end method

.method private getBootCount()I
    .locals 2

    .line 903
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    .line 904
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const-string v0, "boot_count"

    const/4 v1, -0x1

    .line 903
    invoke-static {p0, v0, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method private getIccid(I)Ljava/lang/String;
    .locals 0

    .line 941
    invoke-static {p1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 942
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getFullIccSerialNumber()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    return-object p0
.end method

.method private getSecretKey(Ljava/lang/String;)Ljavax/crypto/SecretKey;
    .locals 4

    const/4 v0, 0x0

    .line 1075
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mKeyStore:Ljava/security/KeyStore;

    .line 1076
    invoke-virtual {v1, p1, v0}, Ljava/security/KeyStore;->getEntry(Ljava/lang/String;Ljava/security/KeyStore$ProtectionParameter;)Ljava/security/KeyStore$Entry;

    move-result-object v1

    check-cast v1, Ljava/security/KeyStore$SecretKeyEntry;

    if-eqz v1, :cond_0

    .line 1078
    invoke-virtual {v1}, Ljava/security/KeyStore$SecretKeyEntry;->getSecretKey()Ljavax/crypto/SecretKey;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception v1

    .line 1083
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Exception with getting the key "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 1084
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->deleteSecretKey(Ljava/lang/String;)V

    :cond_0
    return-object v0
.end method

.method private getShortLivedKeyValidityEnd()Ljava/util/Date;
    .locals 2

    .line 1126
    iget v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKeyDurationMinutes:I

    if-lez v0, :cond_0

    .line 1127
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v0

    .line 1128
    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v1}, Ljava/util/Calendar;->setTime(Ljava/util/Date;)V

    const/16 v1, 0xc

    .line 1129
    iget p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKeyDurationMinutes:I

    invoke-virtual {v0, v1, p0}, Ljava/util/Calendar;->add(II)V

    .line 1130
    invoke-virtual {v0}, Ljava/util/Calendar;->getTime()Ljava/util/Date;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private getSlotCount()I
    .locals 0

    .line 915
    :try_start_0
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object p0

    array-length p0, p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    .line 917
    :catch_0
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getActiveModemCount()I

    move-result p0

    return p0
.end method

.method private static initializeKeyStore()Ljava/security/KeyStore;
    .locals 3

    const/4 v0, 0x0

    :try_start_0
    const-string v1, "AndroidKeyStore"

    .line 1023
    invoke-static {v1}, Ljava/security/KeyStore;->getInstance(Ljava/lang/String;)Ljava/security/KeyStore;

    move-result-object v1

    .line 1024
    invoke-virtual {v1, v0}, Ljava/security/KeyStore;->load(Ljava/security/KeyStore$LoadStoreParameter;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    const-string v2, "KeyStore ready"

    .line 1030
    invoke-static {v2, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->logv(Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v1

    :catch_0
    move-exception v1

    const-string v2, "Error loading KeyStore"

    .line 1027
    invoke-static {v2, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-object v0
.end method

.method private initializeSecretKey(Ljava/lang/String;Z)Ljavax/crypto/SecretKey;
    .locals 4

    .line 1043
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mKeyStore:Ljava/security/KeyStore;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 1047
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->getSecretKey(Ljava/lang/String;)Ljavax/crypto/SecretKey;

    move-result-object v0

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v0, :cond_1

    new-array p0, v3, [Ljava/lang/Object;

    aput-object p1, p0, v2

    const-string p1, "KeyStore: alias %s exists"

    .line 1049
    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v0

    :cond_1
    if-eqz p2, :cond_5

    const-string p2, "PinStorage_shortTerm_key"

    .line 1053
    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_2

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getShortLivedKeyValidityEnd()Ljava/util/Date;

    move-result-object v1

    :cond_2
    const-string p2, "PinStorage_longTerm_always_key"

    .line 1055
    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_3

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->isDeviceSecure()Z

    move-result p2

    if-eqz p2, :cond_3

    move p2, v3

    goto :goto_0

    :cond_3
    move p2, v2

    :goto_0
    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    aput-object p1, v0, v2

    if-eqz v1, :cond_4

    .line 1057
    invoke-virtual {v1}, Ljava/util/Date;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    :cond_4
    const-string v2, ""

    :goto_1
    aput-object v2, v0, v3

    const/4 v2, 0x2

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v3

    aput-object v3, v0, v2

    const-string v2, "KeyStore: alias %s does not exist - Creating (exp=%s, auth=%s)"

    .line 1056
    invoke-static {v2, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 1058
    invoke-direct {p0, p1, v1, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->createSecretKey(Ljava/lang/String;Ljava/util/Date;Z)Ljavax/crypto/SecretKey;

    move-result-object p0

    return-object p0

    :cond_5
    new-array p0, v3, [Ljava/lang/Object;

    aput-object p1, p0, v2

    const-string p1, "KeyStore: alias %s does not exist - Nothing to do"

    .line 1061
    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v1
.end method

.method private isCacheAllowed(I)Z
    .locals 0

    .line 984
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->isCacheAllowedByDevice()Z

    move-result p0

    return p0
.end method

.method private isCacheAllowedByCarrier(I)Z
    .locals 1

    .line 1001
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    const-class v0, Landroid/telephony/CarrierConfigManager;

    .line 1002
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/CarrierConfigManager;

    if-eqz p0, :cond_0

    .line 1004
    invoke-static {p1}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 1007
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p1

    invoke-virtual {p0, p1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    if-nez p0, :cond_1

    .line 1011
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object p0

    :cond_1
    const/4 p1, 0x1

    const-string/jumbo v0, "store_sim_pin_for_unattended_reboot_bool"

    .line 1014
    invoke-virtual {p0, v0, p1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method private isCacheAllowedByDevice()Z
    .locals 2

    .line 990
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v0, 0x1110025

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    new-array v0, p0, [Ljava/lang/Object;

    const-string v1, "Pin caching disabled in resources"

    .line 992
    invoke-static {v1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->logv(Ljava/lang/String;[Ljava/lang/Object;)V

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method private isDeviceLocked()Z
    .locals 2

    .line 622
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    const-class v0, Landroid/app/KeyguardManager;

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/KeyguardManager;

    const/4 v0, 0x0

    if-eqz p0, :cond_0

    .line 624
    invoke-virtual {p0}, Landroid/app/KeyguardManager;->isDeviceSecure()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {p0}, Landroid/app/KeyguardManager;->isDeviceLocked()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 v0, 0x1

    :cond_0
    return v0
.end method

.method private isDeviceSecure()Z
    .locals 1

    .line 616
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    const-class v0, Landroid/app/KeyguardManager;

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/KeyguardManager;

    if-eqz p0, :cond_0

    .line 617
    invoke-virtual {p0}, Landroid/app/KeyguardManager;->isDeviceSecure()Z

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isPinState(ILcom/android/internal/telephony/uicc/IccCardStatus$PinState;)Z
    .locals 3

    .line 959
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object p0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccProfileForPhone(I)Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object p0

    const/4 p1, 0x0

    if-eqz p0, :cond_2

    const/4 v0, 0x3

    move v1, p1

    :goto_0
    if-ge v1, v0, :cond_2

    .line 968
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/uicc/UiccProfile;->getApplication(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v2

    if-eqz v2, :cond_1

    .line 970
    invoke-virtual {v2}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getPin1State()Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object p0

    if-ne p0, p2, :cond_0

    const/4 p1, 0x1

    :cond_0
    return p1

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    return p1
.end method

.method private loadPinInformation()Landroid/util/SparseArray;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;",
            ">;"
        }
    .end annotation

    .line 630
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    .line 631
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result v1

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    .line 633
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation(I)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object v3

    if-eqz v3, :cond_0

    .line 635
    invoke-virtual {v0, v2, v3}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method private loadPinInformation(I)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 5

    .line 652
    iget-boolean v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLastCommitResult:Z

    const/4 v1, 0x0

    const/4 v2, 0x0

    if-nez v0, :cond_0

    new-array p0, v2, [Ljava/lang/Object;

    const-string p1, "Last commit failed - returning empty values"

    .line 654
    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    return-object v1

    .line 660
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    if-eqz v0, :cond_1

    .line 662
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mRamStorage:Landroid/util/SparseArray;

    if-eqz v0, :cond_3

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 663
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mRamStorage:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [B

    iget-object v3, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLongTermSecretKey:Ljavax/crypto/SecretKey;

    invoke-direct {p0, v0, v3}, Lcom/android/internal/telephony/uicc/PinStorage;->decryptStoredPin([BLjavax/crypto/SecretKey;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object p0

    goto :goto_0

    .line 669
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLongTermSecretKey:Ljavax/crypto/SecretKey;

    const-string v3, "encrypted_pin_available_"

    invoke-direct {p0, p1, v3, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformationFromDisk(ILjava/lang/String;Ljavax/crypto/SecretKey;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object v0

    .line 671
    iget-object v3, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKey:Ljavax/crypto/SecretKey;

    const-string v4, "encrypted_pin_reboot_"

    invoke-direct {p0, p1, v4, v3}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformationFromDisk(ILjava/lang/String;Ljavax/crypto/SecretKey;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object p0

    if-eqz v0, :cond_2

    if-nez p0, :cond_2

    move-object p0, v0

    goto :goto_0

    :cond_2
    if-nez v0, :cond_3

    if-eqz p0, :cond_3

    goto :goto_0

    :cond_3
    move-object p0, v1

    :goto_0
    const/4 v0, 0x1

    if-eqz p0, :cond_4

    .line 681
    iget v3, p0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    if-eq v3, p1, :cond_4

    const/4 p0, 0x2

    new-array p0, p0, [Ljava/lang/Object;

    .line 682
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, p0, v2

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, p0, v0

    const-string v3, "Load PIN: slot ID does not match (%d != %d)"

    invoke-static {v3, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_1

    :cond_4
    move-object v1, p0

    :goto_1
    if-eqz v1, :cond_5

    new-array p0, v0, [Ljava/lang/Object;

    .line 687
    invoke-virtual {v1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toString()Ljava/lang/String;

    move-result-object p1

    aput-object p1, p0, v2

    const-string p1, "Load PIN: %s"

    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->logv(Ljava/lang/String;[Ljava/lang/Object;)V

    goto :goto_2

    :cond_5
    new-array p0, v0, [Ljava/lang/Object;

    .line 689
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p0, v2

    const-string p1, "Load PIN for slot %d: null"

    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->logv(Ljava/lang/String;[Ljava/lang/Object;)V

    :goto_2
    return-object v1
.end method

.method private loadPinInformationFromDisk(ILjava/lang/String;Ljavax/crypto/SecretKey;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;
    .locals 3

    .line 705
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    const-string v1, "pinstorage_prefs"

    const/4 v2, 0x0

    .line 706
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, ""

    .line 707
    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 708
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-nez p2, :cond_0

    .line 710
    :try_start_0
    invoke-static {p1, v2}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object p1

    .line 711
    invoke-direct {p0, p1, p3}, Lcom/android/internal/telephony/uicc/PinStorage;->decryptStoredPin([BLjavax/crypto/SecretKey;)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static varargs logd(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 0

    .line 1204
    invoke-static {p0, p1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    const-string p1, "PinStorage"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 1

    const-string v0, "PinStorage"

    .line 1212
    invoke-static {v0, p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method private static varargs loge(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 0

    .line 1208
    invoke-static {p0, p1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    const-string p1, "PinStorage"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static varargs logv(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 0

    return-void
.end method

.method private onCarrierConfigChanged(I)V
    .locals 4

    const/4 v0, 0x1

    new-array v1, v0, [Ljava/lang/Object;

    .line 565
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "onCarrierConfigChanged[%d]"

    invoke-static {v2, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->logv(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 566
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->isCacheAllowed(I)Z

    move-result v1

    if-nez v1, :cond_0

    new-array v0, v0, [Ljava/lang/Object;

    .line 567
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v0, v3

    const-string v1, "onCarrierConfigChanged[%d] - PIN caching not allowed"

    invoke-static {v1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 568
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->clearPin(I)V

    :cond_0
    return-void
.end method

.method private onDeviceReady()V
    .locals 8

    const/4 v0, 0x0

    new-array v1, v0, [Ljava/lang/Object;

    const-string v2, "onDeviceReady"

    .line 415
    invoke-static {v2, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    const-string v1, "PinStorage_shortTerm_key"

    .line 420
    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->initializeSecretKey(Ljava/lang/String;Z)Ljavax/crypto/SecretKey;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKey:Ljavax/crypto/SecretKey;

    .line 423
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result v1

    move v2, v0

    move v3, v2

    :goto_0
    if-ge v2, v1, :cond_4

    .line 426
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation(I)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object v4

    if-nez v4, :cond_0

    goto :goto_1

    .line 434
    :cond_0
    iget v5, v4, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    const/4 v6, 0x1

    if-ne v5, v6, :cond_2

    .line 435
    iget v5, v4, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->bootCount:I

    iget v7, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mBootCount:I

    if-eq v5, v7, :cond_1

    new-array v4, v6, [Ljava/lang/Object;

    .line 436
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v0

    const-string v5, "Boot count [%d] does not match - remove PIN"

    invoke-static {v5, v4}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    const/4 v4, 0x0

    .line 437
    invoke-direct {p0, v2, v4}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    goto :goto_1

    :cond_1
    new-array v5, v6, [Ljava/lang/Object;

    .line 440
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v5, v0

    const-string v6, "Boot count [%d] matches - keep stored PIN"

    invoke-static {v6, v5}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 446
    :cond_2
    iget v5, v4, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    const/4 v6, 0x2

    if-ne v5, v6, :cond_3

    const/4 v5, 0x3

    .line 447
    iput v5, v4, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    .line 448
    invoke-direct {p0, v2, v4}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    add-int/lit8 v3, v3, 0x1

    :cond_3
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_4
    if-lez v3, :cond_5

    const/16 v1, 0x4e20

    .line 453
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->startTimer(I)Z

    .line 459
    :cond_5
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->saveNumberOfCachedPins(I)I

    move-result p0

    if-le p0, v3, :cond_6

    const/16 v0, 0x150

    const/4 v1, 0x7

    sub-int/2addr p0, v3

    const-string v2, ""

    .line 461
    invoke-static {v0, v1, p0, v2}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V

    :cond_6
    return-void
.end method

.method private declared-synchronized onSimStatusChange(II)V
    .locals 4
    .param p2    # I
        .annotation build Landroid/telephony/TelephonyManager$SimState;
        .end annotation
    .end param

    monitor-enter p0

    :try_start_0
    const-string v0, "SIM card/application changed[%d]: %s"

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    .line 523
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    invoke-static {p2}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->simStateString(I)Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v1, v3

    .line 522
    invoke-static {v0, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    const/4 v0, 0x0

    packed-switch p2, :pswitch_data_0

    :pswitch_0
    goto :goto_0

    .line 550
    :pswitch_1
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation(I)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object p2

    if-eqz p2, :cond_0

    .line 551
    iget p2, p2, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    if-eq p2, v3, :cond_0

    .line 552
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    goto :goto_0

    .line 541
    :pswitch_2
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->clearPin(I)V

    goto :goto_0

    .line 530
    :pswitch_3
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation(I)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object p2

    if-eqz p2, :cond_0

    .line 531
    iget p2, p2, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    const/4 v1, 0x3

    if-eq p2, v1, :cond_0

    .line 532
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 562
    :cond_0
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_3
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_1
        :pswitch_0
        :pswitch_2
        :pswitch_2
        :pswitch_1
        :pswitch_1
    .end packed-switch
.end method

.method private onSupplyPinComplete(IZ)V
    .locals 4

    const/4 v0, 0x2

    new-array v1, v0, [Ljava/lang/Object;

    .line 573
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/4 v3, 0x0

    aput-object v2, v1, v3

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v1, v3

    const-string v2, "onSupplyPinComplete[%d] - success: %s"

    invoke-static {v2, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    if-nez p2, :cond_0

    .line 577
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->clearPin(I)V

    :cond_0
    const/16 p0, 0x150

    if-eqz p2, :cond_1

    move v0, v3

    :cond_1
    const-string p1, ""

    .line 580
    invoke-static {p0, v0, v3, p1}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V

    return-void
.end method

.method private declared-synchronized onTimerExpiration()V
    .locals 9

    monitor-enter p0

    :try_start_0
    const-string v0, "onTimerExpiration"

    const/4 v1, 0x0

    new-array v2, v1, [Ljava/lang/Object;

    .line 473
    invoke-static {v0, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 476
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result v0

    move v2, v1

    move v3, v2

    :goto_0
    const/4 v4, 0x3

    const/4 v5, 0x0

    if-ge v2, v0, :cond_3

    .line 479
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation(I)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object v6

    if-nez v6, :cond_0

    goto :goto_1

    .line 486
    :cond_0
    iget v7, v6, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    const/4 v8, 0x1

    if-ne v7, v4, :cond_1

    const-string v4, "onTimerExpiration - Discarding PIN in slot %d"

    new-array v6, v8, [Ljava/lang/Object;

    .line 487
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    aput-object v7, v6, v1

    invoke-static {v4, v6}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 488
    invoke-direct {p0, v2, v5}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_1
    const/4 v4, 0x2

    if-ne v7, v4, :cond_2

    const-string v4, "onTimerExpiration - Moving PIN in slot %d back to AVAILABLE"

    new-array v5, v8, [Ljava/lang/Object;

    .line 496
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    aput-object v7, v5, v1

    invoke-static {v4, v5}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 497
    iput v8, v6, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    .line 498
    invoke-direct {p0, v2, v6}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    :cond_2
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_3
    const-string v0, "PinStorage_shortTerm_key"

    .line 506
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->deleteSecretKey(Ljava/lang/String;)V

    .line 507
    iput-object v5, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKey:Ljavax/crypto/SecretKey;

    .line 510
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->saveNumberOfCachedPins(I)I

    if-lez v3, :cond_4

    const/16 v0, 0x150

    const-string v1, ""

    .line 514
    invoke-static {v0, v4, v3, v1}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 518
    :cond_4
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method private declared-synchronized onUserUnlocked()V
    .locals 4

    monitor-enter p0

    .line 373
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_0

    .line 376
    monitor-exit p0

    return-void

    :cond_0
    :try_start_1
    const-string v0, "onUserUnlocked - Device is unlocked"

    const/4 v1, 0x0

    new-array v2, v1, [Ljava/lang/Object;

    .line 379
    invoke-static {v0, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 383
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation()Landroid/util/SparseArray;

    move-result-object v0

    .line 384
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->cleanRamStorage()V

    .line 387
    iput-boolean v1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    const-string v2, "PinStorage_longTerm_ua_key"

    const/4 v3, 0x1

    .line 393
    invoke-direct {p0, v2, v3}, Lcom/android/internal/telephony/uicc/PinStorage;->initializeSecretKey(Ljava/lang/String;Z)Ljavax/crypto/SecretKey;

    move-result-object v2

    iput-object v2, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLongTermSecretKey:Ljavax/crypto/SecretKey;

    .line 396
    :goto_0
    invoke-virtual {v0}, Landroid/util/SparseArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 397
    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v2

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    invoke-direct {p0, v2, v3}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 401
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->onDeviceReady()V

    .line 404
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->verifyPendingPins()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 405
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method private saveNumberOfCachedPins(I)I
    .locals 2

    .line 926
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    const-string v0, "pinstorage_prefs"

    const/4 v1, 0x0

    .line 927
    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string/jumbo v0, "stored_pins"

    .line 929
    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 930
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    return v1
.end method

.method private savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z
    .locals 9

    if-eqz p2, :cond_0

    .line 754
    iget v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mBootCount:I

    iput v0, p2, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->bootCount:I

    .line 759
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    if-eqz v0, :cond_1

    .line 760
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformationToRam(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    move-result p0

    return p0

    .line 764
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mContext:Landroid/content/Context;

    const-string v1, "pinstorage_prefs"

    const/4 v2, 0x0

    .line 765
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 766
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "encrypted_pin_available_"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 767
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "encrypted_pin_reboot_"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 768
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const/4 v1, 0x1

    if-eqz p2, :cond_3

    new-array v3, v1, [Ljava/lang/Object;

    .line 774
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v3, v2

    const-string v4, "Saving PIN for slot %d"

    invoke-static {v4, v3}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 775
    iget v3, p2, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    if-ne v3, v1, :cond_2

    .line 776
    iget-object v8, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLongTermSecretKey:Ljavax/crypto/SecretKey;

    const-string v7, "encrypted_pin_available_"

    move-object v3, p0

    move-object v4, v0

    move v5, p1

    move-object v6, p2

    invoke-direct/range {v3 .. v8}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(Landroid/content/SharedPreferences$Editor;ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;Ljava/lang/String;Ljavax/crypto/SecretKey;)Z

    move-result p1

    goto :goto_0

    .line 779
    :cond_2
    iget-object v8, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKey:Ljavax/crypto/SecretKey;

    const-string v7, "encrypted_pin_reboot_"

    move-object v3, p0

    move-object v4, v0

    move v5, p1

    move-object v6, p2

    invoke-direct/range {v3 .. v8}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(Landroid/content/SharedPreferences$Editor;ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;Ljava/lang/String;Ljavax/crypto/SecretKey;)Z

    move-result p1

    goto :goto_0

    :cond_3
    new-array p2, v1, [Ljava/lang/Object;

    .line 783
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p2, v2

    const-string p1, "Deleting PIN for slot %d (if existed)"

    invoke-static {p1, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->logv(Ljava/lang/String;[Ljava/lang/Object;)V

    move p1, v1

    .line 786
    :goto_0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p2

    if-eqz p2, :cond_4

    if-eqz p1, :cond_4

    move v2, v1

    :cond_4
    iput-boolean v2, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLastCommitResult:Z

    return v2
.end method

.method private savePinInformation(Landroid/content/SharedPreferences$Editor;ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;Ljava/lang/String;Ljavax/crypto/SecretKey;)Z
    .locals 4

    const/4 v0, 0x0

    if-nez p5, :cond_0

    return v0

    .line 807
    :cond_0
    iget v1, p3, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    const/4 v2, 0x1

    if-eq p2, v1, :cond_1

    const/4 p0, 0x2

    new-array p0, p0, [Ljava/lang/Object;

    .line 808
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p0, v0

    iget p1, p3, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p0, v2

    const-string p1, "Save PIN: the slotId does not match (%d != %d)"

    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    return v0

    :cond_1
    new-array v1, v2, [Ljava/lang/Object;

    .line 812
    invoke-virtual {p3}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toString()Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v0

    const-string v3, "Save PIN: %s"

    invoke-static {v3, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->logv(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 814
    invoke-static {p3}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p3

    invoke-direct {p0, p5, p3}, Lcom/android/internal/telephony/uicc/PinStorage;->encrypt(Ljavax/crypto/SecretKey;[B)[B

    move-result-object p0

    .line 815
    array-length p3, p0

    if-lez p3, :cond_2

    .line 816
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 817
    invoke-static {p0, v0}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p0

    .line 816
    invoke-interface {p1, p2, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    return v2

    :cond_2
    return v0
.end method

.method private savePinInformationToRam(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z
    .locals 4

    .line 827
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->cleanRamStorage(I)V

    const/4 v0, 0x1

    if-nez p2, :cond_0

    return v0

    .line 833
    :cond_0
    iget v1, p2, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    const/4 v2, 0x0

    if-ne v1, v0, :cond_1

    .line 834
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLongTermSecretKey:Ljavax/crypto/SecretKey;

    invoke-static {p2}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p2

    invoke-direct {p0, v1, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->encrypt(Ljavax/crypto/SecretKey;[B)[B

    move-result-object p2

    if-eqz p2, :cond_1

    .line 835
    array-length v1, p2

    if-lez v1, :cond_1

    new-array v1, v0, [Ljava/lang/Object;

    .line 836
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    const-string v2, "Saving PIN for slot %d in RAM"

    invoke-static {v2, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 837
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mRamStorage:Landroid/util/SparseArray;

    invoke-virtual {p0, p1, p2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    return v0

    :cond_1
    return v2
.end method

.method private startTimer(I)Z
    .locals 3

    const/4 v0, 0x3

    .line 935
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    if-lez p1, :cond_0

    int-to-long v1, p1

    .line 936
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x1

    :goto_0
    return p0
.end method

.method private validateIccid(Ljava/lang/String;)Z
    .locals 0

    if-eqz p1, :cond_0

    .line 950
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    const/16 p1, 0xc

    if-lt p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private validatePin(Ljava/lang/String;)Z
    .locals 1

    if-eqz p1, :cond_0

    .line 946
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    const/4 v0, 0x4

    if-lt p0, v0, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    const/16 p1, 0x8

    if-gt p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private validateSlotId(I)Z
    .locals 0

    if-ltz p1, :cond_0

    .line 954
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result p0

    if-ge p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private verifyPendingPin(I)V
    .locals 5

    .line 883
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->getIccid(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->getPin(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 884
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    :cond_0
    const/4 v1, 0x1

    new-array v2, v1, [Ljava/lang/Object;

    .line 889
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-string v3, "Perform automatic verification of PIN in slot %d"

    invoke-static {v3, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 891
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v2

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccProfileForPhone(I)Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object v2

    if-eqz v2, :cond_1

    const/4 v1, 0x5

    .line 893
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    .line 894
    iput p1, p0, Landroid/os/Message;->arg2:I

    .line 895
    invoke-virtual {v2, v0, p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->supplyPin(Ljava/lang/String;Landroid/os/Message;)V

    goto :goto_0

    :cond_1
    new-array p0, v1, [Ljava/lang/Object;

    .line 897
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, p0, v4

    const-string p1, "Perform automatic verification of PIN in slot %d not possible"

    invoke-static {p1, p0}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    :goto_0
    return-void
.end method

.method private verifyPendingPins()V
    .locals 3

    .line 871
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result v0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    .line 873
    sget-object v2, Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;->PINSTATE_ENABLED_NOT_VERIFIED:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->isPinState(ILcom/android/internal/telephony/uicc/IccCardStatus$PinState;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 874
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->verifyPendingPin(I)V

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method


# virtual methods
.method public declared-synchronized clearPin(I)V
    .locals 4

    monitor-enter p0

    :try_start_0
    const-string v0, "clearPin[%d]"

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    .line 245
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    invoke-static {v0, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 247
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->validateSlotId(I)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_0

    .line 248
    monitor-exit p0

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 250
    :try_start_1
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 251
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    const-string p1, "PinStorage:"

    .line 1216
    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1217
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mIsDeviceSecure="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p3, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceSecure:Z

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1218
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " mIsDeviceLocked="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p3, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1219
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " isLongTermSecretKey="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mLongTermSecretKey:Ljavax/crypto/SecretKey;

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eqz p3, :cond_0

    move p3, v0

    goto :goto_0

    :cond_0
    move p3, v1

    :goto_0
    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1220
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " isShortTermSecretKey="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKey:Ljavax/crypto/SecretKey;

    if-eqz p3, :cond_1

    goto :goto_1

    :cond_1
    move v0, v1

    :goto_1
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1221
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, " isCacheAllowedByDevice="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->isCacheAllowedByDevice()Z

    move-result p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1222
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result p1

    :goto_2
    if-ge v1, p1, :cond_2

    .line 1224
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " isCacheAllowedByCarrier["

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "]="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->isCacheAllowedByCarrier(I)Z

    move-result v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    :cond_2
    return-void
.end method

.method public declared-synchronized getPin(ILjava/lang/String;)Ljava/lang/String;
    .locals 5

    monitor-enter p0

    .line 262
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->validateSlotId(I)Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->validateIccid(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_1

    .line 266
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation(I)Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 268
    iget-object v1, v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    invoke-virtual {v1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    const/4 v1, 0x1

    if-nez p2, :cond_1

    const/4 p2, 0x0

    .line 271
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    const/16 p1, 0x150

    const/4 p2, 0x6

    const-string v0, ""

    .line 272
    invoke-static {p1, p2, v1, v0}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V

    goto :goto_0

    .line 275
    :cond_1
    iget p2, v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    const/4 v2, 0x3

    if-ne p2, v2, :cond_2

    const-string p2, "getPin[%d] - Found PIN ready for verification"

    new-array v2, v1, [Ljava/lang/Object;

    const/4 v3, 0x0

    .line 276
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    invoke-static {p2, v2}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 278
    iput v1, v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    .line 279
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    .line 280
    iget-object p1, v0, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object p1

    :cond_2
    :goto_0
    :try_start_1
    const-string p1, ""
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 283
    monitor-exit p0

    return-object p1

    :cond_3
    :goto_1
    :try_start_2
    const-string p1, ""
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 263
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 590
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_5

    const/4 v2, 0x2

    if-eq v0, v2, :cond_4

    const/4 v2, 0x3

    if-eq v0, v2, :cond_3

    const/4 v2, 0x4

    if-eq v0, v2, :cond_2

    const/4 v2, 0x5

    if-eq v0, v2, :cond_0

    goto :goto_1

    .line 604
    :cond_0
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Landroid/os/AsyncResult;

    if-eqz v0, :cond_1

    .line 605
    iget-object v0, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    .line 606
    :goto_0
    iget p1, p1, Landroid/os/Message;->arg2:I

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->onSupplyPinComplete(IZ)V

    goto :goto_1

    .line 601
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->onUserUnlocked()V

    goto :goto_1

    .line 598
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->onTimerExpiration()V

    goto :goto_1

    .line 595
    :cond_4
    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->onCarrierConfigChanged(I)V

    goto :goto_1

    .line 592
    :cond_5
    iget v0, p1, Landroid/os/Message;->arg1:I

    iget p1, p1, Landroid/os/Message;->arg2:I

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->onSimStatusChange(II)V

    :goto_1
    return-void
.end method

.method public declared-synchronized prepareUnattendedReboot(Landroid/os/WorkSource;)I
    .locals 11

    monitor-enter p0

    .line 297
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mIsDeviceLocked:Z

    const/4 v1, 0x2

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    const-string p1, "prepareUnattendedReboot - Device is locked"

    new-array v0, v2, [Ljava/lang/Object;

    .line 298
    invoke-static {p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 299
    monitor-exit p0

    return v1

    :cond_0
    const/16 v0, 0x4e20

    .line 303
    :try_start_1
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->startTimer(I)Z

    move-result v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-nez v0, :cond_1

    .line 304
    monitor-exit p0

    return v1

    .line 307
    :cond_1
    :try_start_2
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->getSlotCount()I

    move-result v0

    .line 308
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/PinStorage;->loadPinInformation()Landroid/util/SparseArray;

    move-result-object v3

    const-string v4, "PinStorage_shortTerm_key"

    .line 311
    invoke-direct {p0, v4}, Lcom/android/internal/telephony/uicc/PinStorage;->deleteSecretKey(Ljava/lang/String;)V

    const/4 v4, 0x0

    .line 312
    iput-object v4, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKey:Ljavax/crypto/SecretKey;

    .line 316
    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v4

    const/4 v5, 0x1

    if-lez v4, :cond_2

    const-string v4, "PinStorage_shortTerm_key"

    .line 318
    invoke-direct {p0, v4, v5}, Lcom/android/internal/telephony/uicc/PinStorage;->initializeSecretKey(Ljava/lang/String;Z)Ljavax/crypto/SecretKey;

    move-result-object v4

    iput-object v4, p0, Lcom/android/internal/telephony/uicc/PinStorage;->mShortTermSecretKey:Ljavax/crypto/SecretKey;

    :cond_2
    move v4, v2

    move v6, v4

    move v7, v6

    move v8, v7

    :goto_0
    if-ge v4, v0, :cond_6

    .line 327
    invoke-virtual {v3, v4}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    if-eqz v9, :cond_4

    .line 329
    iput v1, v9, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    .line 330
    invoke-direct {p0, v4, v9}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z

    move-result v9

    if-nez v9, :cond_3

    goto :goto_2

    :cond_3
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 335
    :cond_4
    sget-object v9, Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;->PINSTATE_ENABLED_VERIFIED:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    invoke-direct {p0, v4, v9}, Lcom/android/internal/telephony/uicc/PinStorage;->isPinState(ILcom/android/internal/telephony/uicc/IccCardStatus$PinState;)Z

    move-result v9

    if-eqz v9, :cond_5

    const-string v7, "Slot %d requires PIN and is not cached"

    new-array v9, v5, [Ljava/lang/Object;

    .line 338
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    aput-object v10, v9, v2

    invoke-static {v7, v9}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    add-int/lit8 v8, v8, 0x1

    move v7, v5

    :cond_5
    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_6
    move v1, v7

    :goto_2
    if-eqz p1, :cond_8

    .line 345
    invoke-virtual {p1}, Landroid/os/WorkSource;->size()I

    move-result v0

    if-nez v0, :cond_7

    goto :goto_3

    .line 346
    :cond_7
    invoke-virtual {p1, v2}, Landroid/os/WorkSource;->getPackageName(I)Ljava/lang/String;

    move-result-object p1

    goto :goto_4

    :cond_8
    :goto_3
    const-string p1, ""

    :goto_4
    const/16 v0, 0x150

    if-nez v1, :cond_9

    const-string v3, "prepareUnattendedReboot - Stored %d PINs"

    new-array v4, v5, [Ljava/lang/Object;

    .line 348
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v2

    invoke-static {v3, v4}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    const/4 v2, 0x4

    .line 349
    invoke-static {v0, v2, v6, p1}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V

    goto :goto_5

    :cond_9
    if-ne v1, v5, :cond_a

    const-string v3, "prepareUnattendedReboot - Required %d PINs after reboot"

    new-array v4, v5, [Ljava/lang/Object;

    .line 353
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v2

    invoke-static {v3, v4}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    const/4 v2, 0x5

    .line 354
    invoke-static {v0, v2, v8, p1}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIILjava/lang/String;)V

    .line 360
    :cond_a
    :goto_5
    invoke-direct {p0, v6}, Lcom/android/internal/telephony/uicc/PinStorage;->saveNumberOfCachedPins(I)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 362
    monitor-exit p0

    return v1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized storePin(Ljava/lang/String;I)V
    .locals 6

    monitor-enter p0

    .line 219
    :try_start_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->getIccid(I)Ljava/lang/String;

    move-result-object v0

    .line 221
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/PinStorage;->validatePin(Ljava/lang/String;)Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v1, :cond_2

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->validateIccid(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->validateSlotId(I)Z

    move-result v1

    if-nez v1, :cond_0

    goto :goto_0

    .line 227
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->isCacheAllowed(I)Z

    move-result v1

    if-nez v1, :cond_1

    const-string/jumbo p1, "storePin[%d]: caching it not allowed"

    new-array v0, v3, [Ljava/lang/Object;

    .line 228
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    aput-object p2, v0, v2

    invoke-static {p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 229
    monitor-exit p0

    return-void

    :cond_1
    :try_start_1
    const-string/jumbo v1, "storePin[%d]"

    new-array v4, v3, [Ljava/lang/Object;

    .line 232
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v4, v2

    invoke-static {v1, v4}, Lcom/android/internal/telephony/uicc/PinStorage;->logd(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 234
    new-instance v1, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;-><init>()V

    .line 235
    iput-object v0, v1, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->iccid:Ljava/lang/String;

    .line 236
    iput-object p1, v1, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->pin:Ljava/lang/String;

    .line 237
    iput p2, v1, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->slotId:I

    .line 238
    iput v3, v1, Lcom/android/internal/telephony/nano/StoredPinProto$StoredPin;->status:I

    .line 240
    invoke-direct {p0, p2, v1}, Lcom/android/internal/telephony/uicc/PinStorage;->savePinInformation(ILcom/android/internal/telephony/nano/StoredPinProto$StoredPin;)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 241
    monitor-exit p0

    return-void

    :cond_2
    :goto_0
    :try_start_2
    const-string/jumbo p1, "storePin[%d] - Invalid PIN, slotId or ICCID"

    new-array v0, v3, [Ljava/lang/Object;

    .line 223
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v0, v2

    invoke-static {p1, v0}, Lcom/android/internal/telephony/uicc/PinStorage;->loge(Ljava/lang/String;[Ljava/lang/Object;)V

    .line 224
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/uicc/PinStorage;->clearPin(I)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 225
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
