package com.pri.prizeinterphone.serial;

import android.util.Log;
import com.pri.prizeinterphone.Util.ExecutorManager;
import com.pri.prizeinterphone.handler.AnalogMessageHandler;
import com.pri.prizeinterphone.handler.DigitalAudioMessageHandler;
import com.pri.prizeinterphone.handler.DigitalMessageHandler;
import com.pri.prizeinterphone.handler.EncryptMessageHandler;
import com.pri.prizeinterphone.handler.EnhanceMessageHandler;
import com.pri.prizeinterphone.handler.FetchSmsMessageHandler;
import com.pri.prizeinterphone.handler.InitMessageHandler;
import com.pri.prizeinterphone.handler.InterruptMessageHandler;
import com.pri.prizeinterphone.handler.LaunchMessageHandler;
import com.pri.prizeinterphone.handler.MessageHandler;
import com.pri.prizeinterphone.handler.MicMessageHandler;
import com.pri.prizeinterphone.handler.MixCheckMessageHandler;
import com.pri.prizeinterphone.handler.ModuleStatusMessageHandler;
import com.pri.prizeinterphone.handler.MonitorMessageHandler;
import com.pri.prizeinterphone.handler.PolicyMessageHandler;
import com.pri.prizeinterphone.handler.PowerSaveMessageHandler;
import com.pri.prizeinterphone.handler.QueryInitMessageHandler;
import com.pri.prizeinterphone.handler.RelayMessageHandler;
import com.pri.prizeinterphone.handler.SendSmsMessageHandler;
import com.pri.prizeinterphone.handler.SignalMessageHandler;
import com.pri.prizeinterphone.handler.SmsProtocolMessageHandler;
import com.pri.prizeinterphone.handler.SquelchMessageHandler;
import com.pri.prizeinterphone.handler.TestBiteErrorRateMessageHandler;
import com.pri.prizeinterphone.handler.TotMessageHandler;
import com.pri.prizeinterphone.handler.VersionMessageHandler;
import com.pri.prizeinterphone.handler.VolumeMessageHandler;
import com.pri.prizeinterphone.protocol.Const;
import com.pri.prizeinterphone.protocol.Packet;
import com.pri.prizeinterphone.serial.port.SerialPort;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executor;

public final class MessageDispatcher implements PacketReceiver {
    public static final String TAG = "TAG_MessageDispatcher";
    private final Executor executor = ExecutorManager.INSTANCE.getDispatchThread();
    private final Map<Byte, MessageHandler> handlers = new HashMap();

    public MessageDispatcher() {
        register(Const.Command.MODULE_INIT_CMD, new InitMessageHandler());
        register(Const.Command.SET_DIGITAL_INFO_CMD, new DigitalMessageHandler());
        register(Const.Command.SET_ANALOG_INFO_CMD, new AnalogMessageHandler());
        register(Const.Command.QUERY_DIGITAL_INFO_CMD, new DigitalMessageHandler());
        register(Const.Command.QUERY_ANALOG_INFO_CMD, new AnalogMessageHandler());
        register(Const.Command.SET_LAUNCH_INFO_CMD, new LaunchMessageHandler());
        register(Const.Command.QUERY_INIT_STATUS_CMD, new QueryInitMessageHandler());
        register(Const.Command.SET_ENHANCE_FUNCTION_CMD, new EnhanceMessageHandler());
        register(Const.Command.SET_ENCRYPT_FUNCTION_CMD, new EncryptMessageHandler());
        register(Const.Command.SET_GAIN_MIC_CMD, new MicMessageHandler());
        register(Const.Command.QUERY_DIGITAL_AUDIO_RECEIVE_INFO, new DigitalAudioMessageHandler());
        register(Const.Command.SEND_SMS_CMD, new SendSmsMessageHandler());
        register(Const.Command.RECEIVE_SMS_CMD, new FetchSmsMessageHandler());
        register(Const.Command.SET_VOL_CMD, new VolumeMessageHandler());
        register((byte) 48, new SquelchMessageHandler());
        register(Const.Command.SET_LISTEN_CMD, new MonitorMessageHandler());
        register(Const.Command.SET_POWER_SAVE_MODE_CMD, new PowerSaveMessageHandler());
        register(Const.Command.QUERY_SIGNAL_STRENGTH_CMD, new SignalMessageHandler());
        register(Const.Command.SET_OFFLINE_MODE_CMD, new RelayMessageHandler());
        register(Const.Command.QUERY_VERSION_CMD, new VersionMessageHandler());
        register(Const.Command.INTERRUPT_TRANSMIT_CMD, new InterruptMessageHandler());
        register(Const.Command.MODULE_PRINT_STATUS_INFO_CMD, new ModuleStatusMessageHandler());
        register(Const.Command.SET_POLITE_POLICY_CMD, new PolicyMessageHandler());
        register(Const.Command.SET_MIX_CHECK_INFO_CMD, new MixCheckMessageHandler());
        register(Const.Command.SET_SMS_PROTOCOL_TYPE_CMD, new SmsProtocolMessageHandler());
        register((byte) 59, new TotMessageHandler());
        register((byte) 63, new TestBiteErrorRateMessageHandler());
    }

    public void register(byte b, MessageHandler messageHandler) {
        this.handlers.put(Byte.valueOf(b), messageHandler);
    }

    public void onReceive(Packet packet, SerialPort serialPort) {
        MessageHandler messageHandler = this.handlers.get(Byte.valueOf(packet.getCmd()));
        Log.i(TAG, "onReceive: handler " + messageHandler);
        if (messageHandler != null) {
            this.executor.execute(new MessageDispatcher$$ExternalSyntheticLambda0(messageHandler, packet));
        }
    }
}
