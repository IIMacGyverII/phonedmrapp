.class public final synthetic Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda2;
.super Ljava/lang/Object;
.source "R8$$SyntheticClass"

# interfaces
.implements Ljava/util/function/Consumer;


# instance fields
.field public final synthetic f$0:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;


# direct methods
.method public synthetic constructor <init>(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;)V
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents$$ExternalSyntheticLambda2;->f$0:Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;

    check-cast p1, Lorg/xmlpull/v1/XmlPullParser;

    invoke-static {p0, p1}, Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;->$r8$lambda$NbAWyv9_i92Qu-bq7geULPcvFIM(Lcom/android/internal/telephony/TelephonyComponentFactory$InjectedComponents;Lorg/xmlpull/v1/XmlPullParser;)V

    return-void
.end method
