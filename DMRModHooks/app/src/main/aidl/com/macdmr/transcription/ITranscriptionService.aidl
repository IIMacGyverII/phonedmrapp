// ITranscriptionService.aidl
package com.macdmr.transcription;

/**
 * AIDL interface for IPC communication with DMRTranscriptionService
 * Allows DMRModHooks (LSPosed module) to send audio to a separate app for processing
 */
interface ITranscriptionService {
    /**
     * Transcribe audio data
     * @param pcmBytes Raw 16-bit PCM audio data (little endian)
     * @param sampleRate Sample rate in Hz (typically 16000)
     * @return Transcribed text or error message
     */
    String transcribe(in byte[] pcmBytes, int sampleRate);
    
    /**
     * Check if the transcription model is loaded and ready
     * @return true if ready, false if still loading
     */
    boolean isReady();
}
