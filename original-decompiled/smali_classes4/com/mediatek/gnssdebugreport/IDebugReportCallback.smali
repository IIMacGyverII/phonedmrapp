.class public interface abstract Lcom/mediatek/gnssdebugreport/IDebugReportCallback;
.super Ljava/lang/Object;
.source "IDebugReportCallback.java"

# interfaces
.implements Landroid/os/IInterface;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/gnssdebugreport/IDebugReportCallback$Stub;,
        Lcom/mediatek/gnssdebugreport/IDebugReportCallback$Default;
    }
.end annotation


# static fields
.field public static final DESCRIPTOR:Ljava/lang/String; = "com.mediatek.gnssdebugreport.IDebugReportCallback"


# virtual methods
.method public abstract onDebugReportAvailable(Landroid/os/Bundle;)V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method
