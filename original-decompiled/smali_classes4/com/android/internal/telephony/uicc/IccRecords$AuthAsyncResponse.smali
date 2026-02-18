.class Lcom/android/internal/telephony/uicc/IccRecords$AuthAsyncResponse;
.super Ljava/lang/Object;
.source "IccRecords.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/IccRecords;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "AuthAsyncResponse"
.end annotation


# instance fields
.field public authRsp:Lcom/android/internal/telephony/uicc/IccIoResult;

.field public exception:Ljava/lang/Throwable;


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 244
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/uicc/IccRecords$AuthAsyncResponse-IA;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/IccRecords$AuthAsyncResponse;-><init>()V

    return-void
.end method
