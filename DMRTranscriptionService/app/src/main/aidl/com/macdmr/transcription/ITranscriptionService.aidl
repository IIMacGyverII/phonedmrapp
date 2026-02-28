package com.macdmr.transcription;

interface ITranscriptionService {
    /**
     * Transcribe PCM audio to text
     * @param pcmBytes 16-bit little-endian PCM audio data
     * @param sampleRate Audio sample rate (16000 for DMR)
     * @return Transcribed text string
     */
    String transcribe(in byte[] pcmBytes, int sampleRate);
    
    /**
     * Check if service is ready (model loaded)
     * @return true if ready to transcribe
     */
    boolean isReady();
}
