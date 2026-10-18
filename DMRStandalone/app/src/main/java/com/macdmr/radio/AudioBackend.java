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
    /** Phone microphone to the radio while keyed. */
    String startTx();
    String stopTx();
    /** Play 8 kHz mono PCM into the TX path, paced to real time; blocks until done. */
    String playPcm(short[] mono);
}
