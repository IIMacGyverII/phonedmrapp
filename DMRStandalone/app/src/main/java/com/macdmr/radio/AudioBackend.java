package com.macdmr.radio;

/**
 * Voice audio to and from the radio module, one implementation per phone family:
 * {@link TinyServiceAudio} (Ulefone: vendor binder service, 8 kHz stereo L==R frames) and
 * {@link UartPcmAudio} (Blackview-style: raw 8 kHz mono PCM on a second UART).
 * The service always sees RX as 8 kHz stereo-duplicated 16-bit frames and hands TX as 8 kHz mono shorts.
 */
public interface AudioBackend {
    interface Sink { void onPcm(byte[] stereo8k, int len); }
    interface Gate { boolean open(); }

    void setSink(Sink s);
    void setGate(Gate g);
    /** Open the RX stream and play it (through the gate). */
    String startRx(boolean speaker);
    String stopRx();
    /** The stock app may take the audio service over while this app does not own the radio (Hand back): the next
     *  {@link #startRx} must attach to it again instead of trusting its old registration. */
    default void releaseForStockApp() { }
    /** Phone microphone to the radio while keyed. */
    String startTx();
    /** Microphone for the next {@link #startTx}: MediaRecorder.AudioSource.MIC (phone) or VOICE_COMMUNICATION (a Bluetooth hands-free mic, e.g. the car's). */
    default void setTxSource(int source) { }
    /** The microphone's peak level (0..32767) of each block while keyed, or null for none. */
    interface Level { void peak(int peak); }
    default void setTxLevel(Level l) { }
    /** Transmit audio from somewhere other than a microphone (SignalDeck Web: the browser's microphone): a blocking,
     *  real-time paced source of 8 kHz mono 16-bit little-endian bytes, read like {@code AudioRecord.read}. */
    interface TxFeed { int read(byte[] buf, int off, int len); }
    /** The feed for the next {@link #startTx} instead of the microphone, or null for the microphone. */
    default void setTxFeed(TxFeed f) { }
    String stopTx();
    /** Play 8 kHz mono PCM into the TX path, paced to real time; blocks until done. */
    String playPcm(short[] mono);
}
