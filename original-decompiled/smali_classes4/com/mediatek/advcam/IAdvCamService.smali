.class public interface abstract Lcom/mediatek/advcam/IAdvCamService;
.super Ljava/lang/Object;
.source "IAdvCamService.java"

# interfaces
.implements Landroid/os/IInterface;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/advcam/IAdvCamService$Stub;,
        Lcom/mediatek/advcam/IAdvCamService$Default;
    }
.end annotation


# static fields
.field public static final DESCRIPTOR:Ljava/lang/String; = "com.mediatek.advcam.IAdvCamService"


# virtual methods
.method public abstract setConfigureParam(ILandroid/hardware/camera2/CaptureRequest;)I
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method
