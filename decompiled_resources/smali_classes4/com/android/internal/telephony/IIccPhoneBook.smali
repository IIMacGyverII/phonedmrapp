.class public interface abstract Lcom/android/internal/telephony/IIccPhoneBook;
.super Ljava/lang/Object;
.source "IIccPhoneBook.java"

# interfaces
.implements Landroid/os/IInterface;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/IIccPhoneBook$Stub;,
        Lcom/android/internal/telephony/IIccPhoneBook$Default;
    }
.end annotation


# static fields
.field public static final DESCRIPTOR:Ljava/lang/String; = "com.android.internal.telephony.IIccPhoneBook"


# virtual methods
.method public abstract getAdnRecordsCapacityForSubscriber(I)Lcom/android/internal/telephony/uicc/AdnCapacity;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method

.method public abstract getAdnRecordsInEf(I)Ljava/util/List;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:36:1:36:25"
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/AdnRecord;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method

.method public abstract getAdnRecordsInEfForSubscriber(II)Ljava/util/List;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:47:1:47:25"
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(II)",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/AdnRecord;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method

.method public abstract getAdnRecordsSize(I)[I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:114:1:114:25"
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method

.method public abstract getAdnRecordsSizeForSubscriber(II)[I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:127:1:127:25"
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method

.method public abstract updateAdnRecordsInEfByIndexForSubscriber(IILandroid/content/ContentValues;ILjava/lang/String;)Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method

.method public abstract updateAdnRecordsInEfBySearch(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        overrideSourcePosition = "frameworks/opt/telephony/src/java/com/android/internal/telephony/IIccPhoneBook.aidl:68:1:68:25"
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method

.method public abstract updateAdnRecordsInEfBySearchForSubscriber(IILandroid/content/ContentValues;Ljava/lang/String;)Z
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation
.end method
