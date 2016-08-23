#!/bin/bash

TIME=$1
DIR=$2
NAME=$3

pids=""

ffmpeg -nostats -re -f lavfi -i testsrc -t $TIME -pix_fmt yuv420p -s 4096x2160 $DIR/$NAME-4k.mp4 &
pids+=" $!"

ffmpeg -nostats -re -f lavfi -i testsrc -t $TIME -pix_fmt yuv420p -s 1280x720 $DIR/$NAME-720.mp4 &
pids+=" $!"

ffmpeg -f lavfi -i "sine=frequency=440:duration=$TIME" $DIR/$NAME-audio.mp3 &
pids+=" $!"

#   Wait for recordings to finish (running as background processes), then finish
for p in $pids; do
  if wait $p; then
    echo "$p successful"
  else
    exit $?
  fi
done
