.class public interface abstract annotation Lcom/pri/prizeinterphone/protocol/Const$ModuleStatus;
.super Ljava/lang/Object;
.source "Const.java"

# interfaces
.implements Ljava/lang/annotation/Annotation;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/pri/prizeinterphone/protocol/Const;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2609
    name = "ModuleStatus"
.end annotation

.annotation runtime Ljava/lang/annotation/Retention;
    value = .enum Ljava/lang/annotation/RetentionPolicy;->CLASS:Ljava/lang/annotation/RetentionPolicy;
.end annotation


# static fields
.field public static final CHANNEL_BUSY:B = 0x7t

.field public static final MIX_CHECK_ANALOG_RECEIVE_START:B = 0xct

.field public static final MIX_CHECK_ANALOG_RECEIVE_STOP:B = 0xdt

.field public static final MIX_CHECK_DIGITAL_RECEIVE_START:B = 0xat

.field public static final MIX_CHECK_DIGITAL_RECEIVE_STOP:B = 0xbt

.field public static final RECEIVE_START:B = 0x1t

.field public static final RECEIVE_STOP:B = 0x2t

.field public static final RELAY_ACTIVITY_TIME_OUT:B = 0x6t

.field public static final SEND_START:B = 0x3t

.field public static final SEND_STOP:B = 0x4t

.field public static final SMS_RECEIVED:B = 0x5t

.field public static final SMS_SENT_FAIL:B = 0x9t

.field public static final SMS_SENT_SUCCESS:B = 0x8t
