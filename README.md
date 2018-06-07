# roscpp_android

roscpp_android is an environment that enables cross-compiling the ROS system for an Android platform.

## Use

```
git clone https://github.com/ekumenlabs/roscpp_android.git
cd roscpp_android
./do_docker.sh
```

## Configuration

To configure the build edit the `config.sh` file. You can set the target architecture, android abi and android platform.

## What release of ROS does it build?

Currently it is building ROS Indigo and some packages may not even be the latest for that release.

## Why so old? Can we have the latest version of ROS?

Sadly the answer is no. The process of building the ROS packages and dependency libraries for the Android platform requires a lot of work patching and configuring so it can correctly compile using the android toolchain and runtime libraries. On top of that the build must be a completely static link because the android system does not allow your native code to dynamically load libraries (unless possibly if you have super user permission). This is clearly not the standard ROS way and we need to account for that.

## How can I see which version of each package is it using?

For the ROS packages you can check the `ndk.rosinstall` file.

For the libraries you need to check the `get_library.sh` script.

## How it works

### Toolchain
The environment uses the [Android NDK](https://developer.android.com/ndk/) to compile the code targetting the native platform.

### Docker
The build happens inside a docker container which is based on an Ubuntu image and has all the required dependencies pre-installed. The container will be spawned mounting the working directory so it can read the resources and output the results.

### Libraries
The first time you run the tool it will download all the library dependencies sources and install them inside the `output/libs` folder.

### ROS packages
Then it will download all the ros packages sources and install them inside the `output/catkin_ws` folder.

### Patching
Applies patches as needed to the correponding sources. The patches that are applied can be found inside the `patches` folder.

### Output
Finally it will compile every package and its dependencies and the resulting static objects are placed inside the `output/target/lib` folder.

## Testing

There is a set of sample apps that you can install and run on android that will test if the build worked properly.

## Can I build my own ROS packages?

Yes you can! _[Pending instructions on how to do it]_

## What are the limitations?

This is a static build which means that your code cannot load dynamic libraries at runtime due to an Android security policy. So all your dependecies need to be installed from sources and be accessible at compile time. Basically all objects are linked together to from a big shared object that will be loaded by the android system.

For the same reason you are very limited in the external file access. There is no ROS workspace environment at runtime so you cannot search for packages or run catkin. Any package that relies on external files existing on a specific folder structure need to be adapted.

## Can I use pluginlib?

Yes! Although [pluginlib](http://wiki.ros.org/pluginlib) relies on dynamic loading of library modules there is a hack in place that allows you to use it. The trick consists in including in the build all plugins that might be required at runtime. No other special care is needed and the process will be transparent to the user.

At build time a parser makes a list of all available plugins and compiles them as part of the static build. When the plugin is loaded at runtime, pluginlib will be fooled to think the plugin has been located and loaded but it actually is already in memory and ready for the code to use it.
