.class Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;
.super Ljava/lang/Object;
.source "ImsResolver.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/ims/ImsResolver;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "OverrideConfig"
.end annotation


# instance fields
.field public final featureTypeToPackageMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field public final isCarrierService:Z

.field public final slotId:I


# direct methods
.method constructor <init>(IZLjava/util/Map;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(IZ",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 169
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 170
    iput p1, p0, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;->slotId:I

    .line 171
    iput-boolean p2, p0, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;->isCarrierService:Z

    .line 172
    iput-object p3, p0, Lcom/android/internal/telephony/ims/ImsResolver$OverrideConfig;->featureTypeToPackageMap:Ljava/util/Map;

    return-void
.end method
