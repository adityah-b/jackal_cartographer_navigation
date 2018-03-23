# Jackal Cartographer Demo

This tutorial shows you how to use [move_base](http://wiki.ros.org/move_base) with [Google Cartographer](https://github.com/googlecartographer) to perform autonomous planning and movement with simultaneous localization and mapping (SLAM), on a simulated Jackal, or a factory-standard Jackal with a laser scanner publishing on the */front/scan* topic.

Developed by Google, Cartographer is an open-source library used for real-time simultaneous localization and mapping (SLAM). Using LIDAR data, it generates submaps which are later optimized and scan-matched to provide real-time loop closure. As a result, Cartographer is able to successfully close loops and generate a consistent map each time whereas Gmapping can occasionally fail to do so, resulting in unique maps generated after every iteration [[1](https://lup.lub.lu.se/student-papers/search/publication/8915402)]. A variety of sensor configurations are supported allowing Cartographer to be used for a broad range of applications. In this demo, Cartographer uses odometry and LIDAR data from the Jackal to perform real-time SLAM.

To adapt this demo to your own Jackal, you may need to clone the [jackal_cartographer_navigation](http://github.com/jackal/jackal_cartographer_navigation.git) repository, and modify the relevant parameters. To learn about move_base and the navigation stack, see the [Navigation Tutorials](http://wiki.ros.org/navigation/Tutorials). To learn more about Google Cartographer for ROS, see the [Cartographer ROS](https://google-cartographer-ros.readthedocs.io/en/latest/) documentation.

## Instructions

  1. To get started with 2-D SLAM using Google Cartographer, clone this repository into your working directory:

     `git clone http://github.com/jackal/jackal_cartographer_navigation.git`

  2. Run the following script to create a workspace and install proto3. This script will also install the packages required to use Cartographer as well as the [jackal_desktop](https://github.com/jackal/jackal_desktop), [jackal](https://github.com/jackal/jackal), and [jackal_simulator](https://github.com/jackal/jackal_simulator) packages:

     `source $(pwd)/jackal_cartographer_navigation/jackal_cartographer_install.sh`

  3. Open three new terminal/tabs, source the workspace for each terminal/tab:

     `source install_isolated/setup.bash`

      1. Launch the Gazebo simulation with the *front_laser* config:

         `roslaunch jackal_gazebo jackal_world.launch config:=front_laser`

      2. Launch RViz to visualize the robot:

         `roslaunch jackal_viz view_robot.launch config:=cartographer`

      3. Launch the Cartographer node to begin SLAM:

         `roslaunch jackal_cartographer_navigation cartographer_demo.launch`

  4. In the Rviz visualizer, make sure the visualizers in the Navigation group are enabled.

  5. Use the 2D Nav Goal tool in the top toolbar to select a movement goal in the visualizer. Make sure to select an unoccupied (dark grey) or unexplored (light grey) location.

  6. As the robot moves, you should see the grey static map (map topic) grow. There might be discrete jumps in the map as the Cartographer algorithm attempts to localize the robot.

  ![Jackal World Map](jackal_cartographer.png)

  7. To save the generated map, you can run the map_saver utility:

     `rosrun map_server map_saver -f <filename>`

#### Tuning Cartographer

To tune Cartographer for low latency SLAM, edit the *jackal.lua* configuration file found in the *jackal_cartographer_navigation/config* directory.

For more information on tuning, click [here](http://google-cartographer-ros.readthedocs.io/en/latest/tuning.html)

[1] T. Coroiu and O. Hinton, "A Platform for Indoor Localisation,
Mapping, and Data Collection using an
Autonomous Vehicle," M.S. thesis, Lund Univ., Lund, Sweden, 2017.
