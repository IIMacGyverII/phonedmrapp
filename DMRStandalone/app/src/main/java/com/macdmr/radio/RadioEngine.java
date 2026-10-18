package com.macdmr.radio;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.Charset;
import java.util.Locale;

/**
 * The shared protocol layer: module power, boot banner, commands, acks, status events.
 * Command set and bodies per docs/deep-dive/01, 02 (PriInterPhone) — identical in the Blackview SDK.
 */
public final class RadioEngine implements UartPort.Listener {
    // commands (A→M unless noted)
    public static final int CMD_SET_DIGITAL = 0x22, CMD_SET_ANALOG = 0x23, CMD_LAUNCH = 0x26, CMD_QUERY_INIT = 0x27,
            CMD_ENHANCE = 0x28, CMD_MIC = 0x2A, CMD_CALLER_INFO = 0x2B, CMD_SEND_SMS = 0x2C, CMD_FETCH_SMS = 0x2D, CMD_VOLUME = 0x2E, CMD_MONITOR = 0x2F,
            CMD_SQUELCH = 0x30, CMD_RSSI = 0x32, CMD_VERSION = 0x34, CMD_INTERRUPT = 0x35, CMD_STATUS = 0x36,
            CMD_TOT = 0x3B, CMD_SPK_EN = 0x3C, CMD_INIT = 0xAA;

    public interface Events {
        void log(String s);
        void status(int code, String name);             // 0x36 push: RECEIVE_START…
        void rssi(int raw, double dbm);
        void version(int version, String text);
        void callerInfo(int callType, int callerId, int target);
        void ack(int cmd, boolean ok);
        void booted(String banner);
        void sms(int type, int fromId, String text);          // 0x2D reply
    }

    private final DeviceProfile profile;
    private final Events ev;
    private final UartPort port;
    private final SysfsGpio power;
    private final StringBuilder banner = new StringBuilder();
    private volatile java.util.concurrent.CountDownLatch bootLatch = new java.util.concurrent.CountDownLatch(1);

    public RadioEngine(DeviceProfile p, Events ev) {
        this.profile = p; this.ev = ev;
        this.port = new UartPort(p.controlPort, this);
        this.power = p.power();
    }

    public DeviceProfile profile() { return profile; }
    public boolean isOpen() { return port.isOpen(); }

    public void open() throws IOException { port.open(profile.serialLib != null && com.pri.prizeinterphone.serial.port.SerialPort.isLoaded() ? profile.baud : 0); }
    public void close() { port.close(); }

    public String powerState() { return power.read(); }

    /** pwd 0→1; the module then prints its banner ("…BF AA <GBK text>\r\n") within ~1 s and accepts commands. */
    /** @return true if the module was off and has just been switched on (caller must {@link #waitBooted}). */
    public boolean powerOn() throws IOException {
        if (!power.isOn()) { bootLatch = new java.util.concurrent.CountDownLatch(1); power.set(true); ev.log("module power -> on (" + power.read() + ")"); return true; }
        ev.log("module already powered (" + power.read() + ")");
        return false;
    }

    public void powerOff() throws IOException { power.set(false); ev.log("module power -> off (" + power.read() + ")"); }

    public void powerCycle() throws IOException {
        power.set(false); try { Thread.sleep(500); } catch (InterruptedException ignored) { }
        bootLatch = new java.util.concurrent.CountDownLatch(1);
        power.set(true); ev.log("module power-cycled (" + power.read() + ")");
    }

    /** After pwd=1 the module needs a few seconds before it prints its banner and accepts commands. */
    public boolean waitBooted(long ms) {
        try { return bootLatch.await(ms, java.util.concurrent.TimeUnit.MILLISECONDS); } catch (InterruptedException e) { return false; }
    }

    // ---- commands ----------------------------------------------------------------------------------

    public void queryVersion() throws IOException { port.send(Frame.request(CMD_VERSION, (byte) 1)); }
    public void queryRssi() throws IOException { port.send(Frame.request(CMD_RSSI, (byte) 1)); }
    public void queryCallerInfo() throws IOException { port.send(Frame.request(CMD_CALLER_INFO, (byte) 1)); }
    public void setTot(int seconds) throws IOException { port.send(Frame.request(CMD_TOT, (byte) seconds)); }
    public void setVolume(int v) throws IOException { port.send(Frame.request(CMD_VOLUME, (byte) v)); }
    public void setMic(int gain) throws IOException { port.send(Frame.request(CMD_MIC, (byte) gain)); }
    /** Monitor: 1 = hear every decodable digital call, 2 = normal filtering (enum 1/2 like the rest). */
    public void setMonitor(boolean on) throws IOException { port.send(Frame.request(CMD_MONITOR, (byte) (on ? 1 : 2))); }
    public void setSpkEn(boolean on) throws IOException { port.send(Frame.request(CMD_SPK_EN, (byte) (on ? 1 : 0))); }

    public void setInterrupt(boolean on) throws IOException { port.send(Frame.request(CMD_INTERRUPT, (byte) (on ? 1 : 2))); }
    public void queryInit() throws IOException { port.send(Frame.request(CMD_QUERY_INIT, (byte) 1)); }

    /**
     * The OEM's cold-start handshake after the module boots (docs/deep-dive/03 §7a): version → channel →
     * interrupt (digital) / mic (analog) → TOT. Each step is acked; we just fire them in order with short gaps.
     */
    public void bootHandshake(Runnable setChannel, boolean digital) throws IOException {
        if (!waitBooted(10000)) ev.log("no boot banner within 10 s — sending the handshake anyway");
        pause(200);
        queryVersion(); pause(150);
        setChannel.run(); pause(250);
        if (digital) setInterrupt(false); else setMic(4); pause(150);
        setTot(0); pause(150);
        ev.log("boot handshake sent");
    }

    private static void pause(long ms) { try { Thread.sleep(ms); } catch (InterruptedException ignored) { } }

    /**
     * DMR text (0x2C): msgType 1 = single, 2 = all, 3 = group (then the group number follows), target id,
     * UTF-16LE text. Success/failure comes back as status 8/9.
     */
    public void sendSms(int msgType, int callNumber, int groupNumber, String text) throws IOException {
        byte[] t = text.getBytes(java.nio.charset.StandardCharsets.UTF_16LE);
        // Body: type, callNumber, [second id], UTF-16LE text. The stock app writes the second int only for
        // group texts, but the firmware reads a 9-byte header for private texts too: a private text sent with the
        // 5-byte header reached a BTECH 6X2 with its first two characters missing (2026-10-17). So the id is
        // written twice for private texts; the group id follows for group texts.
        boolean second = msgType == 3 || msgType == 1;
        ByteBuffer b = ByteBuffer.allocate(5 + (second ? 4 : 0) + t.length).order(ByteOrder.LITTLE_ENDIAN);
        b.put((byte) msgType).putInt(callNumber);
        if (msgType == 3) b.putInt(groupNumber); else if (msgType == 1) b.putInt(callNumber);
        b.put(t);
        port.send(Frame.request(CMD_SEND_SMS, b.array()));
    }

    public void fetchSms() throws IOException { port.send(Frame.request(CMD_FETCH_SMS, (byte) 1)); }

    /** PTT: launch=1 keys the transmitter, 2 releases (enum 1/2 again — 0 is NAKed and the TX keeps running; firmware caps a keyed TX at 30 s). */
    public void ptt(boolean down) throws IOException { port.send(Frame.request(CMD_LAUNCH, (byte) (down ? 1 : 2))); }

    /**
     * Analog channel, 19-byte body (little-endian ints): rxFreq, txFreq, band, power, sq, rxType, rxSubCode,
     * txType, txSubCode, pwrSave, volume, monitor, relay. band must be 1 on VHF (band=0 deafens the RX),
     * relay 2 = normal, sq 0 = squelch open (soft squelch is done in software).
     * Enum bytes are 1 = on / 2 = off — the MCU answers sr=1 (fail) to a 0 in pwrSave/monitor (measured 2026-10-17).
     */
    public void setAnalog(int rxHz, int txHz, int band, int power, int sq, int rxType, int rxSub, int txType, int txSub,
                          int volume, int monitor) throws IOException {
        ByteBuffer b = ByteBuffer.allocate(19).order(ByteOrder.LITTLE_ENDIAN);
        b.putInt(rxHz).putInt(txHz).put((byte) band).put((byte) power).put((byte) sq).put((byte) rxType).put((byte) rxSub)
                .put((byte) txType).put((byte) txSub).put((byte) 2 /* pwrSave: 1 on, 2 off (OEM default 2; 0 is NAKed) */)
                .put((byte) volume).put((byte) (monitor == 1 ? 1 : 2) /* monitor: 1 on, 2 off */).put((byte) 2 /* relay normal */);
        port.send(Frame.request(CMD_SET_ANALOG, b.array()));
    }

    /**
     * Digital channel, 163-byte body: rxFreq, txFreq, localId, groups[32], txContact, contactType, power, cc,
     * inboundSlot, outboundSlot, channelMode, encryptSw(2=off), encryptKey[8], pwrSave, volume, mic, relay.
     * The MCU passes a group call only if its TG is in groups[]; the call number is added automatically.
     */
    public void setDigital(int rxHz, int txHz, int localId, int[] groups, int txContact, int contactType, int power, int cc,
                           int inSlot, int outSlot, int volume, int mic) throws IOException {
        ByteBuffer b = ByteBuffer.allocate(163).order(ByteOrder.LITTLE_ENDIAN);
        b.putInt(rxHz).putInt(txHz).putInt(localId);
        int[] g = new int[32]; int n = 0;
        if (groups != null) for (int x : groups) if (n < 32 && x > 0) g[n++] = x;
        boolean has = false; for (int x : g) if (x == txContact) has = true;
        if (!has && contactType == 1 && n < 32) g[n++] = txContact;
        for (int x : g) b.putInt(x);
        b.putInt(txContact).put((byte) contactType).put((byte) power).put((byte) cc).put((byte) inSlot).put((byte) outSlot)
                .put((byte) 0 /* channelMode direct */).put((byte) 2 /* encrypt off */).put(new byte[8])
                .put((byte) 1).put((byte) volume).put((byte) mic).put((byte) 2);
        port.send(Frame.request(CMD_SET_DIGITAL, b.array()));
    }

    // ---- inbound ----------------------------------------------------------------------------------

    @Override public void onLog(String s) { ev.log(s); }

    @Override public void onRaw(byte[] b, int n) {
        // boot banner: 00 00 BF AA + GBK text + CR LF
        String txt;
        try { txt = new String(b, 0, n, Charset.forName("GBK")).replace("\u0000", "").trim(); } catch (Throwable t) { txt = Frame.hex(b, n); }
        boolean marker = false; for (int i = 0; i + 1 < n; i++) if ((b[i] & 0xFF) == 0xBF && (b[i + 1] & 0xFF) == 0xAA) marker = true;
        ev.log("RAW " + Frame.hex(b, n) + (txt.isEmpty() ? "" : "  \"" + txt + "\""));
        if (marker) { bootLatch.countDown(); ev.booted(txt); }
    }

    @Override public void onFrame(Frame f) {
        ev.log("RX " + f);
        byte[] b = f.body;
        switch (f.cmd) {
            case CMD_STATUS: {
                int code = b.length > 0 ? b[0] & 0xFF : -1;
                try { port.send(new Frame(CMD_STATUS, 1, 1, new byte[] { 1 })); } catch (IOException ignored) { }   // the OEM acks every push
                ev.status(code, statusName(code));
                break;
            }
            case CMD_RSSI:
                if (f.rw == 0 && b.length >= 1) { int raw = b[0] & 0xFF; ev.rssi(raw, raw > 0 ? -(120 - raw / 2.0) : -999); }
                break;
            case CMD_VERSION:
                if (b.length >= 4) ev.version(ByteBuffer.wrap(b).order(ByteOrder.LITTLE_ENDIAN).getInt(), new String(b).trim());
                break;
            case CMD_CALLER_INFO:
                if (b.length >= 9) {
                    ByteBuffer bb = ByteBuffer.wrap(b).order(ByteOrder.LITTLE_ENDIAN);
                    int type = bb.get() & 0xFF; int caller = bb.getInt() & 0xFFFFFF; int target = bb.getInt();
                    ev.callerInfo(type, caller, target);
                }
                break;
            case CMD_FETCH_SMS:
                if (b.length >= 5) {
                    ByteBuffer bb = ByteBuffer.wrap(b).order(ByteOrder.LITTLE_ENDIAN);
                    int type = bb.get() & 0xFF; int from = bb.getInt();
                    String text = new String(b, 5, b.length - 5, java.nio.charset.StandardCharsets.UTF_16LE).replace("\u0000", "").trim();
                    ev.sms(type, from, text);
                }
                break;
            case CMD_INIT:
                ev.log("module init frame (0xAA)");
                break;
            default:
                ev.ack(f.cmd, f.sr == 0);     // sr 0 = success, 1 = fail, 2 = checksum error
        }
    }

    public static String statusName(int s) {
        switch (s) {
            case 1: return "RECEIVE_START"; case 2: return "RECEIVE_STOP"; case 3: return "SEND_START"; case 4: return "SEND_STOP";
            case 5: return "SMS_RECEIVED"; case 6: return "RELAY_ACTIVITY_TIME_OUT"; case 7: return "CHANNEL_BUSY";
            case 8: return "SMS_SENT_SUCCESS"; case 9: return "SMS_SENT_FAIL";
            case 10: return "MIX_DIGITAL_RX_START"; case 11: return "MIX_DIGITAL_RX_STOP"; case 12: return "MIX_ANALOG_RX_START"; case 13: return "MIX_ANALOG_RX_STOP";
            default: return String.format(Locale.US, "STATUS_%d", s);
        }
    }
}
