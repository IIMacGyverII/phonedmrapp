.class public Lcom/pri/prizeinterphone/protocol/Const;
.super Ljava/lang/Object;
.source "Const.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/protocol/Const$ModuleStatus;,
        Lcom/pri/prizeinterphone/protocol/Const$AnalogCmdType;,
        Lcom/pri/prizeinterphone/protocol/Const$DigitalCmdType;,
        Lcom/pri/prizeinterphone/protocol/Const$CallBackCode;,
        Lcom/pri/prizeinterphone/protocol/Const$SRFlag;,
        Lcom/pri/prizeinterphone/protocol/Const$RWMode;,
        Lcom/pri/prizeinterphone/protocol/Const$Command;
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static moduleStatus2Str(B)Ljava/lang/String;
    .locals 0

    packed-switch p0, :pswitch_data_0

    const-string/jumbo p0, "unknown"

    return-object p0

    :pswitch_0
    const-string p0, "MIX_CHECK_ANALOG_RECEIVE_STOP"

    return-object p0

    :pswitch_1
    const-string p0, "MIX_CHECK_ANALOG_RECEIVE_START"

    return-object p0

    :pswitch_2
    const-string p0, "MIX_CHECK_DIGITAL_RECEIVE_STOP"

    return-object p0

    :pswitch_3
    const-string p0, "MIX_CHECK_DIGITAL_RECEIVE_START"

    return-object p0

    :pswitch_4
    const-string p0, "SMS_SENT_FAIL"

    return-object p0

    :pswitch_5
    const-string p0, "SMS_SENT_SUCCESS"

    return-object p0

    :pswitch_6
    const-string p0, "CHANNEL_BUSY"

    return-object p0

    :pswitch_7
    const-string p0, "RELAY_ACTIVITY_TIME_OUT"

    return-object p0

    :pswitch_8
    const-string p0, "SMS_RECEIVED"

    return-object p0

    :pswitch_9
    const-string p0, "SEND_STOP"

    return-object p0

    :pswitch_a
    const-string p0, "SEND_START"

    return-object p0

    :pswitch_b
    const-string p0, "RECEIVE_STOP"

    return-object p0

    :pswitch_c
    const-string p0, "RECEIVE_START"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static sRFlag2Str(B)Ljava/lang/String;
    .locals 1

    if-eqz p0, :cond_2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    const-string/jumbo p0, "unknown"

    return-object p0

    :cond_0
    const-string p0, "RESULT_CK_SUM_ERROR"

    return-object p0

    :cond_1
    const-string p0, "SET or RESULT_FAIL"

    return-object p0

    :cond_2
    const-string p0, "RESULT_SUCCESS"

    return-object p0
.end method
