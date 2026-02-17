.class public Lcom/android/internal/telephony/dataconnection/ApnConfigType;
.super Ljava/lang/Object;
.source "ApnConfigType.java"


# instance fields
.field private final mPriority:I

.field private final mType:I


# direct methods
.method public constructor <init>(II)V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigType;->mType:I

    .line 32
    iput p2, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigType;->mPriority:I

    return-void
.end method


# virtual methods
.method public getPriority()I
    .locals 0

    .line 48
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigType;->mPriority:I

    return p0
.end method

.method public getType()I
    .locals 0

    .line 40
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigType;->mType:I

    return p0
.end method
