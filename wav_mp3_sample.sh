#!/bin/sh
# viewer script. rename .wav to .mp3 and play
file=$1
filemp3=$(echo "$file" | sed -e s/\.wav/.mp3/)
mv "$file" "$filemp3"
afplay "$filemp3"
