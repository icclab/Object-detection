FROM ubuntu:16.04

# Install system packages
RUN apt-get -qq update && apt-get -qq install --no-install-recommends -y python3 \ 
 python3-dev \
 python-pil \
 python-lxml \
 python-tk \
 build-essential \
 cmake \ 
 git \ 
 libgtk2.0-dev \ 
 pkg-config \ 
 libavcodec-dev \ 
 libavformat-dev \ 
 libswscale-dev \ 
 libtbb2 \
 libtbb-dev \ 
 libjpeg-dev \
 libpng-dev \
 libtiff-dev \
 libjasper-dev \
 libdc1394-22-dev \
 x11-apps \
 wget \
 vim \
 ffmpeg \
 unzip \
 libgstreamer1.0-dev \
 libgstreamer-plugins-base1.0-dev \
 && rm -rf /var/lib/apt/lists/* 

# Install core packages 
RUN wget -q -O /tmp/get-pip.py --no-check-certificate https://bootstrap.pypa.io/get-pip.py && python3 /tmp/get-pip.py
RUN  pip install -U pip \
 numpy \
 matplotlib \
 notebook \
 jupyter \
 pandas \
 moviepy \
 tensorflow \
 keras \
 autovizwidget

# Install tensorflow models object detection
RUN GIT_SSL_NO_VERIFY=true git clone -q https://github.com/tensorflow/models /usr/local/lib/python3.5/dist-packages/tensorflow/models
RUN wget -q -P /usr/local/src/ --no-check-certificate https://github.com/google/protobuf/releases/download/v3.5.1/protobuf-python-3.5.1.tar.gz

# Download & build protobuf-python
RUN cd /usr/local/src/ \
 && tar xf protobuf-python-3.5.1.tar.gz \
 && rm protobuf-python-3.5.1.tar.gz \
 && cd /usr/local/src/protobuf-3.5.1/ \
 && ./configure \
 && make \
 && make install \
 && ldconfig \
 && rm -rf /usr/local/src/protobuf-3.5.1/

# Add dataframe display widget
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# Download & build OpenCV
RUN wget -q -P /usr/local/src/ --no-check-certificate https://github.com/opencv/opencv/archive/4.1.0.zip
RUN cd /usr/local/src/ \
 && unzip 4.1.0.zip \
 && rm 4.1.0.zip \
 && cd /usr/local/src/opencv-4.1.0/ \
 && mkdir build \
 && cd /usr/local/src/opencv-4.1.0/build \ 
 && cmake -D CMAKE_INSTALL_TYPE=Release -D WITH_GSTREAMER=ON -D CMAKE_INSTALL_PREFIX=/usr/local/ .. \
 && make -j4 \
 && make install \
 && rm -rf /usr/local/src/opencv-4.1.0

# add gstreamer
RUN apt-get -qq update && apt-get -qq install gstreamer-tools libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa  gstreamer1.0-pulseaudio

# Setting up working directory 
RUN mkdir /lab
WORKDIR /lab
#ADD . /lab/

# Minimize image size 
RUN (apt-get autoremove -y; \
     apt-get autoclean -y)

# Set TF object detection available
ENV PYTHONPATH "$PYTHONPATH:/usr/local/lib/python3.5/dist-packages/tensorflow/models/research:/usr/local/lib/python3.5/dist-packages/tensorflow/models/research/slim"
RUN cd /usr/local/lib/python3.5/dist-packages/tensorflow/models/research && protoc object_detection/protos/*.proto --python_out=.

CMD bash exec.sh
