.class public Lcom/android/internal/telephony/cat/SetEventListParams;
.super Lcom/android/internal/telephony/cat/CommandParams;
.source "SetEventListParams.java"


# instance fields
.field public mEventInfo:[I


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/cat/CommandDetails;[I)V
    .locals 0

    .line 21
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/cat/CommandParams;-><init>(Lcom/android/internal/telephony/cat/CommandDetails;)V

    .line 22
    iput-object p2, p0, Lcom/android/internal/telephony/cat/SetEventListParams;->mEventInfo:[I

    return-void
.end method
