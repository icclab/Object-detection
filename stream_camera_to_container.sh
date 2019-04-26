#!/bin/sh
gst-launch-1.0 v4l2src device=/dev/video0 ! 'video/x-raw, width=640, height=480, framerate=30/1' ! videoconvert ! x264enc pass=qual quantizer=20 tune=zerolatency ! rtph264pay ! udpsink host=172.17.0.2 port=5000

