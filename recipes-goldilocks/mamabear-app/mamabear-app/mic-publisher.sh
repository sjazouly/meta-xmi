#!/bin/bash


# Set the duration of each recording in seconds
duration=2

while true; do
    output_file="recorded_audio.wav"
    trimmed_output_file="trimmed_audio.wav"

    arecord -d "$duration" -f S32_LE -t wav -r 44100 -D hw:2,0 "$output_file"
    arecord -d "$duration" -f S32_LE -t wav -r 44100 -D hw:3,0 "$output_file"
    #trim the beginning of the audio file off to eliminate pops and crackles
    sox "$output_file" "$trimmed_output_file" trim 0.8
    rms_amplitude=$(sox "$trimmed_output_file" -n stat 2>&1 | awk '/RMS     amplitude:/ {print $3}')
    db_level=$(printf "%.2f" $(echo "20 * l($rms_amplitude*3500)/l(10)" | bc -l))
    mosquitto_pub -t sensors/microphone -m $db_level

    # Clean up: remove the recorded audio file
    rm "$output_file"
done
