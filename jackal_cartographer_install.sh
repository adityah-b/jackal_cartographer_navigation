# Install wstool and rosdep.
sudo apt-get update
sudo apt-get install -y python-wstool python-rosdep ninja-build

# Create a new workspace in 'jackal_cartographer_ws'.
mkdir jackal_cartographer_ws
cd jackal_cartographer_ws
wstool init src
cp -r ../jackal_cartographer_navigation ./src
git -C ./src clone https://github.com/jackal/jackal_desktop
git -C ./src clone https://github.com/jackal/jackal_simulator
git -C ./src clone https://github.com/jackal/jackal
cp src/jackal_cartographer_navigation/cartographer.rviz src/jackal_desktop/jackal_viz/rviz/

# Merge the cartographer_ros.rosinstall file and fetch code for dependencies.
wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_ros/master/cartographer_ros.rosinstall
wstool update -t src
cd src/cartographer
git checkout c09b643d8d5f7eeaecbdfbe3152f8e337d3e2f0b
cd ../cartographer_ros
git checkout b274743eb794788d552745d26f30e90a2ca0b24c
cd ../..

# Build and install in 'jackal_cartographer_ws/protobuf/install' proto3.
set -o verbose
VERSION="v3.4.1"
git clone https://github.com/google/protobuf.git
cd protobuf
git checkout tags/${VERSION}
mkdir build
cd build
cmake -G Ninja \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -Dprotobuf_BUILD_TESTS=OFF \
  -DCMAKE_INSTALL_PREFIX=../install \
  ../cmake
ninja
ninja install
cd ../../

# Install deb dependencies.
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

# Build and install.
catkin_make_isolated --install --use-ninja \
  -DCMAKE_PREFIX_PATH="${PWD}/install_isolated;${PWD}/protobuf/install;${CMAKE_PREFIX_PATH}"
source install_isolated/setup.bash
