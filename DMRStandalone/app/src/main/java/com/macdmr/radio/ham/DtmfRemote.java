package com.macdmr.radio.ham;

/**
 * DTMF remote control: another radio keys in the PIN and a command digit (for example 1234 then 2, sent as one
 * sequence "12342", an optional * before and # after), and the phone answers on the channel. Three wrong PINs within
 * ten minutes lock the remote for ten minutes. Commands:
 * <pre>
 * 1  position by voice      2  status by voice (battery, channel, signal)
 * 3  APRS position beacon   4  parrot on      5  parrot off      6  Morse ID
 * </pre>
 */
public final class DtmfRemote {
    public interface Actions {
        void speakPosition(); void speakStatus(); void beacon(); void parrot(boolean on); void morseId();
        void event(String line);
    }

    public static final String[] COMMANDS = { "", "Position by voice", "Status by voice", "APRS position beacon", "Parrot on", "Parrot off", "Morse ID" };
    private static final long WINDOW_MS = 10 * 60_000L;

    private final Actions actions;
    private int failures; private long firstFailureMs, lockedUntil;

    public DtmfRemote(Actions a) { actions = a; }

    /** A decoded DTMF sequence; returns the command run (1 to 6) or 0. */
    public synchronized int handle(String seq, String pin, boolean enabled, long now) {
        if (!enabled || pin == null || pin.length() < 4 || seq == null) return 0;
        String s = seq.trim();
        while (s.startsWith("*")) s = s.substring(1);
        while (s.endsWith("#")) s = s.substring(0, s.length() - 1);
        if (s.length() != pin.length() + 1) return 0;                    // not shaped like PIN + command: someone else's code
        if (now < lockedUntil) return 0;
        if (!s.startsWith(pin)) {
            if (failures == 0 || now - firstFailureMs > WINDOW_MS) { failures = 0; firstFailureMs = now; }
            if (++failures >= 3) { lockedUntil = now + WINDOW_MS; failures = 0; actions.event("🔒 DTMF remote locked for 10 minutes after 3 wrong PINs"); }
            else actions.event("🔒 DTMF remote: wrong PIN");
            return 0;
        }
        failures = 0;
        char c = s.charAt(pin.length());
        int cmd = c >= '1' && c <= '6' ? c - '0' : 0;
        if (cmd == 0) { actions.event("📟 DTMF remote: unknown command " + c); return 0; }
        actions.event("📟 DTMF remote: " + COMMANDS[cmd]);
        switch (cmd) {
            case 1: actions.speakPosition(); break;
            case 2: actions.speakStatus(); break;
            case 3: actions.beacon(); break;
            case 4: actions.parrot(true); break;
            case 5: actions.parrot(false); break;
            case 6: actions.morseId(); break;
        }
        return cmd;
    }

    public synchronized boolean locked(long now) { return now < lockedUntil; }
}
