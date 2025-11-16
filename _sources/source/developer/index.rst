.. _urbanverse-developer-root:

Developer Guide
===============

This section provides advanced documentation for extending and customizing UrbanVerse. Whether you want to add new robots, integrate custom assets, collect specialized data, configure teleoperation interfaces, or deploy policies to real-world hardware, these guides will help you extend UrbanVerse's capabilities.

The developer documentation covers:

- **Collecting Data**: Collecting multi-modal sensor data (RGB, depth, point clouds, semantic segmentation, bounding boxes) from UrbanVerse scenes for training perception models and generating synthetic datasets
- **Teleoperation Interfaces**: Configuring and using keyboard, joystick, and VR interfaces for manual robot control and expert demonstration collection
- **Real-world Deployment**: Deploying trained UrbanVerse navigation policies to real robots, including network communication, sensor integration, and low-level control (Unitree Go2 example)
- **Adding New Assets**: Extending UrbanVerse-100K with custom 3D assets using automatic annotation tools powered by GPT-4.1 and Blender
- **Adding New Robots**: Integrating custom robot embodiments into UrbanVerse using URDF or USD models, following Isaac Sim and Isaac Lab's robot integration patterns

.. note::

    These guides assume familiarity with UrbanVerse's core concepts, Isaac Sim/Isaac Lab architecture, and Python programming. 
    Before extending UrbanVerse, ensure you have completed the :doc:`../installation/index` process and are comfortable with :doc:`../quickstart/index` workflows.

.. toctree::
   :maxdepth: 2
   :caption: Developer Guide

   collecting_data
   teleop_interface
   realworld_deployment
   adding_new_assets
   adding_new_robots

