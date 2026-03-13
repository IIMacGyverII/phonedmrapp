#!/usr/bin/env python3
"""
Record APRS Audio from Real Radio
----------------------------------
Records audio from microphone/line-in, saves to WAV file,
then decodes it with our parser AND tests with Dire Wolf.

This lets us:
1. Verify our decoder works on real APRS
2. Compare real radio audio vs our generated audio
3. Validate that Dire Wolf decodes real packets
"""

import wave
import struct
import sys
import subprocess
import os

try:
    import pyaudio
except ImportError:
    print("ERROR: pyaudio not installed")
    print("Install with: pip install pyaudio")
    print("\nAlternatively, use Windows Sound Recorder to record audio,")
    print("then run: python parse_full_packet.py your_recording.wav")
    sys.exit(1)

# Recording parameters
SAMPLE_RATE = 44100
CHANNELS = 1
CHUNK = 1024
RECORD_SECONDS = 10  # Adjust as needed

def list_audio_devices():
    """List all available audio input devices"""
    p = pyaudio.PyAudio()
    print("\nAvailable Audio Input Devices:")
    print("-" * 60)
    for i in range(p.get_device_count()):
        info = p.get_device_info_by_index(i)
        if info['maxInputChannels'] > 0:
            print(f"[{i}] {info['name']}")
            print(f"    Max Input Channels: {info['maxInputChannels']}")
            print(f"    Default Sample Rate: {info['defaultSampleRate']}")
    p.terminate()
    print("-" * 60)

def record_audio(device_index=None, duration=10, filename="real_aprs_recording.wav"):
    """Record audio from microphone/line-in"""
    p = pyaudio.PyAudio()
    
    print(f"\nRecording {duration} seconds of audio...")
    print("Press Ctrl+C to stop early\n")
    
    stream = p.open(
        format=pyaudio.paInt16,
        channels=CHANNELS,
        rate=SAMPLE_RATE,
        input=True,
        input_device_index=device_index,
        frames_per_buffer=CHUNK
    )
    
    frames = []
    
    try:
        for i in range(0, int(SAMPLE_RATE / CHUNK * duration)):
            data = stream.read(CHUNK, exception_on_overflow=False)
            frames.append(data)
            
            # Progress indicator
            elapsed = (i * CHUNK) / SAMPLE_RATE
            print(f"\rRecording: {elapsed:.1f}s / {duration}s", end='', flush=True)
    
    except KeyboardInterrupt:
        print("\n\nRecording stopped by user")
    
    print("\n\nRecording complete!")
    
    stream.stop_stream()
    stream.close()
    p.terminate()
    
    # Save to WAV file
    wf = wave.open(filename, 'wb')
    wf.setnchannels(CHANNELS)
    wf.setsampwidth(p.get_sample_size(pyaudio.paInt16))
    wf.setframerate(SAMPLE_RATE)
    wf.writeframes(b''.join(frames))
    wf.close()
    
    print(f"Saved to: {filename}")
    return filename

def test_with_direwolf(wav_file):
    """Test WAV file with Dire Wolf"""
    direwolf_path = r"C:\Users\Joshua\Downloads\direwolf-1.8.1-a231971_x86_64\direwolf-1.8.1-a231971_x86_64"
    atest_exe = os.path.join(direwolf_path, 'atest.exe')
    
    if not os.path.exists(atest_exe):
        print(f"\nDire Wolf not found at: {atest_exe}")
        return
    
    print(f"\nTesting with Dire Wolf...")
    print("-" * 60)
    
    try:
        result = subprocess.run(
            [atest_exe, '-B', '1200', wav_file],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        # Print output
        output = result.stdout + result.stderr
        for line in output.split('\n'):
            if 'DECODED' in line or 'from' in line or 'decoded' in line:
                print(line)
        
        # Count packets
        decoded_lines = [l for l in output.split('\n') if 'DECODED[' in l]
        print(f"\n{'✓' if decoded_lines else '✗'} Dire Wolf decoded {len(decoded_lines)} packet(s)")
        
    except Exception as e:
        print(f"Error testing with Dire Wolf: {e}")

def test_with_our_parser(wav_file):
    """Test WAV file with our custom parser"""
    print(f"\nTesting with our custom parser...")
    print("-" * 60)
    
    parser_script = "parse_full_packet.py"
    if not os.path.exists(parser_script):
        print(f"Parser script not found: {parser_script}")
        return
    
    try:
        result = subprocess.run(
            ['python', parser_script, wav_file],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        print(result.stdout)
        if result.stderr:
            print("Errors:", result.stderr)
            
    except Exception as e:
        print(f"Error running parser: {e}")

def main():
    print("=" * 60)
    print("    APRS Real Radio Audio Recorder & Tester")
    print("=" * 60)
    
    # List available devices
    list_audio_devices()
    
    # Ask user for device
    print("\nSelect audio input device:")
    print("  [Enter] = Use default device")
    print("  [number] = Specific device")
    print("  [q] = Quit")
    
    choice = input("\nDevice: ").strip()
    
    if choice.lower() == 'q':
        return
    
    device_index = None
    if choice.isdigit():
        device_index = int(choice)
    
    # Ask for duration
    print("\nRecording duration (seconds):")
    duration_str = input("[default: 10]: ").strip()
    duration = int(duration_str) if duration_str.isdigit() else 10
    
    # Record
    wav_file = record_audio(device_index=device_index, duration=duration)
    
    # Test with both decoders
    test_with_direwolf(wav_file)
    test_with_our_parser(wav_file)
    
    print("\n" + "=" * 60)
    print("Recording and testing complete!")
    print(f"WAV file saved as: {wav_file}")
    print("\nYou can now:")
    print("  1. Compare waveforms with our generated audio")
    print("  2. Analyze with: python improved_tone_detect.py real_aprs_recording.wav")
    print("  3. Check structure: python parse_full_packet.py real_aprs_recording.wav")
    print("=" * 60)

if __name__ == "__main__":
    main()
