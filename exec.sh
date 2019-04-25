#apt-get update
#apt-get install -y net-tools
#ifconfig
#gst-launch-1.0 v4l2src device=/dev/video3 ! 'video/x-raw, width=640, height=480, framerate=30/1' ! videoconvert ! x264enc pass=qual quantizer=20 tune=zerolatency ! rtph264pay ! udpsink host=127.0.0.1 port=5000 &
python3 my-object-detection.py -n 20 -d 1 -s 1 -w 2 -q-size 5 -osh $JANUS_HOST -osp $JANUS_PORT
# python3 videostream_example.py
