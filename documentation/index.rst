Welcome to UrbanVerse!
=====================

.. figure:: assets/teaser_v7.png
   :width: 100%
   :alt: UrbanVerse Overview

UrbanVerse
==========

**UrbanVerse** is a unified real-to-sim system built on the Urban-Sim platform with Nvidia IsaacLab as the simulation engine for robot learning in urban environments.  
It converts casually captured, uncalibrated city-tour videos into fully interactive simulation scenes, enabling users to build realistic, layout-accurate environments and train their own robots at scale.

Core Components
---------------

UrbanVerse is powered by two main modules:

1. **UrbanVerse-100K** — a large-scale dataset of (a) Object Collection: 102,530 urban 3D assets across 667 categories, each annotated with 33 semantic, physical, and affordance attributes in true metric scale; (b) Ground Texture Collection: 288 4K photorealistic PBR materials (98 road, 190 sidewalk) for ground plane texturing; (c) Sky Collection: 306 4K HDRI sky maps for realistic global illumination and immersive 360° backgrounds.

2. **UrbanVerse-Gen** — an automatic pipeline that extracts scene layouts from video and instantiates metric-scale simulations using retrieved assets.

Built-in Urban Simulation Environments
--------------------------------------

We provide ready-to-use (pre-built) urban simulation environments for training and evaluation, each packaged as a standalone `.usd` file that can be directly loaded into the IsaacLab platform:

1. **UrbanVerse-160** — a collection of 160 pre-built environments reconstructed from city-tour videos across 7 continents, 24 countries, and 27 cities, available for training and validation.

2. **CraftBench** — a suite of 10 high-fidelity urban scenes created by professional 3D artists, reserved exclusively for test-time evaluation.


Open-Source Release
-------------------

We fully open-source the following resources of UrbanVerse to the community:

1. All assets in UrbanVerse-100K.
2. The complete UrbanVerse-Gen pipeline for layout extraction, asset retrieval, and scene instantiation.
3. Code for urban-navigation tasks (point navigation, obstacle avoidance, pedestrian interaction, etc.) for both training and evaluation.
4. Tools for automatically annotating new 3D objects with semantic, physical, and affordance attributes using GPT-4.1.
5. Multiple robot embodiments, including COCO wheeled delivery robots and robots natively supported by Urban-Sim (e.g., Unitree Go2 quadrupeds, Unitree G1 humanoids).


Simulation Platform
-------------------

Built on top of *NVIDIA Isaac Sim* and *NVIDIA Isaac Lab*, UrbanVerse provides high-fidelity photorealistic rendering and efficient, asynchronous simulation in large-scale, dynamic environments.  
It supports a wide range of learning paradigms, including reinforcement learning and imitation learning, and offers diverse environments, robots, and scenario-generation pipelines.

Extensibility
-------------
UrbanVerse is fully extensible. With UrbanVerse-Gen, you can build custom environments directly from casually captured videos. Using our automatic annotation tools, you can also annotate and integrate new assets, and add your own robots with ease.


.. figure:: assets/teaser.gif
   :width: 100%
   :alt: Example robots


License
=======
This work, UrbanVerse, is released under the Creative Commons Attribution 4.0 International (CC BY 4.0) License, which permits sharing and adaptation with appropriate credit.


Table of Contents
=================

.. toctree::
   :maxdepth: 2
   :caption: Installation

   source/installation/index

.. toctree::
   :maxdepth: 2
   :caption: Quickstart Guide

   source/quickstart/intro_quickstart
   source/quickstart/urbanverse_100k
   source/quickstart/urbanverse_gen
   source/quickstart/urbanverse_scenes
   source/quickstart/craftbench
   source/quickstart/train_your_own_robots
   source/quickstart/test_your_robots

.. toctree::
   :maxdepth: 3
   :caption: Robot Learning with UrbanVerse
   :titlesonly:
   
   source/robot_learning/simulation
   source/robot_learning/environments
   source/robot_learning/configuration
   source/robot_learning/reinforcement_learning/index
   source/robot_learning/imitation_learning/index

.. toctree::
   :maxdepth: 3
   :caption: Developer

   source/developer/code-structure/index
   source/developer/collecting_data
   source/developer/realworld_deployment
   source/developer/adding_new_robots
   source/developer/adding_new_assets
   source/developer/vr_interface

.. toctree::
   :maxdepth: 3
   :caption: UrbanVerse Community

   source/community/contributing
   source/community/communication
   source/community/coding_standards

.. toctree::
   :maxdepth: 1
   :caption: References

   source/refs/assets
   source/refs/issues
   source/refs/license
   source/refs/3license

