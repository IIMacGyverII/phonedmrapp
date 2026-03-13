#include <jni.h>
#include <string>
#include <vector>
#include <android/log.h>

#define LOG_TAG "DireWolf-JNI"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

// Dire Wolf headers
extern "C" {
    #include "demod_afsk.h"
    #include "hdlc_rec.h"
    #include "ax25_pad.h"
    #include "audio.h"
    #include "multi_modem.h"
}

// Storage for decoded packets
static std::vector<std::string> decoded_packets;

// Callback from Dire Wolf when a packet is decoded
extern "C" void app_process_rec_packet(int chan, unsigned char *fbuf, int flen, int level, char *spectrum, int is_fx25) {
    // Extract packet as hex string for now (we'll parse it in Java)
    std::string packet;
    for (int i = 0; i < flen; i++) {
        char hex[3];
        snprintf(hex, sizeof(hex), "%02X", fbuf[i]);
        packet += hex;
    }
    
    decoded_packets.push_back(packet);
    LOGI("Decoded packet: %d bytes, level=%d", flen, level);
}

extern "C" JNIEXPORT jobjectArray JNICALL
Java_com_dmrmod_hooks_DireWolfDecoder_nativeDecodeAudio(
        JNIEnv* env,
        jobject /* this */,
        jshortArray audioSamples,
        jint sampleRate) {
    
    LOGI("nativeDecodeAudio called with sample rate %d", sampleRate);
    
    // Clear previous results
    decoded_packets.clear();
    
    // Get audio samples
    jsize len = env->GetArrayLength(audioSamples);
    jshort* samples = env->GetShortArrayElements(audioSamples, NULL);
    
    // TODO: Initialize Dire Wolf demodulator
    // struct audio_s audio_config;
    // struct demodulator_state_s demod_state;
    // demod_afsk_init(sampleRate, 1200, 1200, 2200, 'A', &demod_state);
    
    // TODO: Process each sample
    // for (jsize i = 0; i < len; i++) {
    //     demod_afsk_process_sample(0, 0, samples[i], &demod_state);
    // }
    
    env->ReleaseShortArrayElements(audioSamples, samples, JNI_ABORT);
    
    // Convert decoded packets to Java String array
    jobjectArray result = env->NewObjectArray(decoded_packets.size(),
                                             env->FindClass("java/lang/String"),
                                             env->NewStringUTF(""));
    
    for (size_t i = 0; i < decoded_packets.size(); i++) {
        env->SetObjectArrayElement(result, i, env->NewStringUTF(decoded_packets[i].c_str()));
    }
    
    LOGI("Returning %zu decoded packets", decoded_packets.size());
    return result;
}
