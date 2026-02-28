# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in ${sdk.dir}/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.

# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep interface org.tensorflow.lite.** { *; }

# Keep AIDL interfaces
-keep class com.macdmr.transcription.ITranscriptionService { *; }
-keep class com.macdmr.transcription.ITranscriptionService$* { *; }
