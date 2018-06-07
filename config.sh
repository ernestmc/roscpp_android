system=$(uname -s | tr 'DL' 'dl')-$(uname -m)
# Define the number of simultaneous jobs to trigger for the different
# tasks that allow it. Use the number of available processors in the
# system.
PARALLEL_JOBS=2
gcc_version=4.9
ANDROID_ARCH=x86

# Android ABI one of: armeabi, armeabi-v7a, arm64-v8a, x86, x86_64
export ANDROID_ABI=x86

export ANDROID_PLATFORM=android-14

#toolchain=arm-linux-androideabi-$gcc_version
toolchain=x86-$gcc_version

PYTHONPATH=/opt/ros/indigo/lib/python2.7/dist-packages:$PYTHONPATH
# Enable this value for debug build
CMAKE_BUILD_TYPE=Debug
# Enable this if you need to use pluginlib in Android.
# The plugins will be statically linked
use_pluginlib=1

