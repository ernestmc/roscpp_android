FROM ubuntu:14.04
MAINTAINER Gary Servin <gary@ekumenlabs.com>
MAINTAINER Ernesto Corbellini <ecorbellini@ekumenlabs.com>

# Install ROS Indigo
RUN apt-get update && apt-get install -y wget git unzip
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y ros-indigo-ros-base python-wstool

# Install Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r17b-linux-x86_64.zip && \
  unzip android-ndk-r17b-linux-x86_64.zip -d /opt && \
  rm android-ndk-r17b-linux-x86_64.zip

# Set-up environment
ENV ANDROID_NDK /opt/android-ndk-r17b

# Install g++ to avoid "CMAKE_CXX_COMPILER-NOTFOUND was not found." error
RUN apt-get install -y g++ make python-lxml

# Install cmake version 3.11.3 required by android ndk and boost
RUN wget https://cmake.org/files/v3.11/cmake-3.11.3-Linux-x86_64.sh && \
  mkdir /opt/cmake && \
  bash cmake-3.11.3-Linux-x86_64.sh --prefix=/opt/cmake --exclude-subdir --skip-license && \
  rm cmake-3.11.3-Linux-x86_64.sh && \
  ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

# Install Android SDK
RUN apt-get update && \
    apt-get install -y openjdk-6-jdk \
                       lib32z1 \
                       lib32ncurses5 \
                       lib32bz2-1.0 \
                       lib32stdc++6 \
                       ant \
                       libc6-dev-i386 \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz && tar -xvf android-sdk_r23.0.2-linux.tgz -C /opt && rm android-sdk_r23.0.2-linux.tgz

# Set-up environment
ENV PATH /opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools:$PATH
ENV ANDROID_HOME /opt/android-sdk-linux
RUN (while true; do echo 'y'; sleep 2; done) | android update sdk -u -t 2,3,7,8,9,11,13,16,56,57

ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64/

# Use ccache
RUN apt-get update && \
    apt-get install -y ccache \
    && rm -rf /var/lib/apt/lists/*
ENV USE_CCACHE 1
ENV NDK_CCACHE /usr/bin/ccache
ENV CCACHE_DIR /opt/roscpp_output/ccache
ENV PATH /usr/lib/ccache:$PATH

# Update ros dependencies
RUN rosdep init && rosdep update
