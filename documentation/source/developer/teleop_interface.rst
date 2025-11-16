.. _urbanverse-developer-teleop-interface:

Teleoperation Interfaces
=====================================

UrbanVerse supports multiple teleoperation interfaces for manual robot control, including keyboard, joystick, and VR interfaces. This guide explains how to configure and use these interfaces in UrbanVerse scenes, following Isaac Sim's input handling patterns.

.. figure:: ../../assets/vr_output.gif
   :width: 100%
   :alt: VR Teleoperation in UrbanVerse

   Demo: A human teleoperating a COCO wheeled robot in UrbanVerse scenes for imitation learning data collection using the Joystick + VR interface with Meta Oculus Quest 3.

Overview
---------

Teleoperation interfaces enable manual control of robots in UrbanVerse scenes for:
- **Data Collection**: Collecting expert demonstrations for imitation learning
- **Testing**: Manually testing robot behaviors and scene interactions
- **Debugging**: Interactive debugging of robot configurations and environments

UrbanVerse provides built-in support for multiple input devices, following Isaac Sim's input system architecture.

Supported Interfaces
--------------------

UrbanVerse supports the following teleoperation interfaces:

- **Keyboard**: Basic keyboard controls for robot movement
- **Joystick**: Joystick input for precise control
- **VR Interface**: Meta Oculus Quest 3 headset and controllers for immersive teleoperation

Basic Usage
-----------

Configure teleoperation for data collection:

.. code-block:: python

   import urbanverse as uv

   # Configure teleoperation interface
   teleop_config = uv.teleop.configure(
       interface="keyboard",  # or "joystick", "vr"
       robot_type="coco_wheeled",
       scene_path="/path/to/scene.usd",
   )

   # Start teleoperation session
   uv.teleop.start(
       config=teleop_config,
       output_dir="demos/teleop_session",
   )

Keyboard Interface
------------------

Keyboard controls provide basic robot movement:

**Configuration:**

.. code-block:: python

   import urbanverse as uv

   teleop_config = uv.teleop.configure(
       interface="keyboard",
       robot_type="coco_wheeled",
       scene_path="/path/to/scene.usd",
       keybindings={
           "forward": "w",
           "backward": "s",
           "left": "a",
           "right": "d",
           "stop": "space",
           "reset": "r",
       },
   )

**Default Keybindings:**

- **W / Up Arrow**: Move forward
- **S / Down Arrow**: Move backward
- **A / Left Arrow**: Rotate left
- **D / Right Arrow**: Rotate right
- **Space**: Emergency stop
- **R**: Reset robot position
- **Enter**: End episode / Start next episode

**Usage:**

.. code-block:: python

   # Start keyboard teleoperation
   uv.teleop.start(
       config=teleop_config,
       output_dir="demos/keyboard_teleop",
       record_demonstrations=True,  # Record for BC training
   )

Joystick Interface
------------------

Joystick interfaces provide precise analog control:

**Configuration:**

.. code-block:: python

   import urbanverse as uv

   teleop_config = uv.teleop.configure(
       interface="joystick",
       robot_type="coco_wheeled",
       scene_path="/path/to/scene.usd",
       joystick_id=0,  # Joystick device ID
       axis_mapping={
           "axis_0": "linear_velocity",
           "axis_1": "angular_velocity",
       },
       deadzone=0.1,  # Deadzone threshold
   )

**Usage:**

.. code-block:: python

   uv.teleop.start(
       config=teleop_config,
       output_dir="demos/joystick_teleop",
   )

VR Interface (Meta Oculus Quest 3)
-----------------------------------

UrbanVerse supports immersive teleoperation using Meta Oculus Quest 3 via Omniverse-supported APIs. This setup requires Isaac Sim deployed on Brev and uses OpenXR as the output plugin for Quest 3 connectivity.

**Prerequisites:**

- Meta Oculus Quest 3 headset and controllers
- Isaac Sim deployed on Brev
- OpenXR runtime installed and configured
- Quest 3 connected to the same network as the Brev deployment

**Configuration:**

The VR interface uses Omniverse's native VR support with OpenXR for Quest 3 connectivity:

.. code-block:: python

   import urbanverse as uv
   from omni.isaac.core.utils.extensions import enable_extension

   # Enable OpenXR extension for Quest 3
   enable_extension("omni.kit.openxr")

   # Configure VR teleoperation for Quest 3
   teleop_config = uv.teleop.configure(
       interface="vr",
       robot_type="coco_wheeled",
       scene_path="/path/to/scene.usd",
       vr_settings={
           "headset_type": "oculus_quest_3",
           "openxr_runtime": "oculus",  # Use Oculus OpenXR runtime
           "controller_mapping": {
               "left_joystick_y": "linear_velocity",  # Forward/backward movement
               "right_joystick_x": "angular_velocity",  # Rotation
               "left_trigger": "emergency_stop",
               "right_trigger": "end_episode",
               "left_grip": "reset_robot",
           },
           "rendering": {
               "output_plugin": "openxr",  # Use OpenXR for Quest 3 output
               "resolution": [1920, 1832],  # Quest 3 per-eye resolution
               "refresh_rate": 90,  # Quest 3 refresh rate
           },
       },
   )

**OpenXR Setup:**

1. **Install OpenXR Runtime**: Ensure the Oculus OpenXR runtime is installed on your system
2. **Configure OpenXR**: Set Oculus as the active OpenXR runtime
3. **Network Connection**: Connect Quest 3 to the same network as your Brev deployment
4. **Enable OpenXR in Isaac Sim**: The configuration above automatically enables the OpenXR extension

**Usage:**

.. code-block:: python

   # Start VR teleoperation with Quest 3
   uv.teleop.start(
       config=teleop_config,
       output_dir="demos/vr_quest3_teleop",
       enable_vr_rendering=True,
       vr_streaming=True,  # Stream to Quest 3 via network
   )

**Quest 3 Controller Mapping:**

- **Left Joystick (Y-axis)**: Linear velocity (forward/backward)
- **Right Joystick (X-axis)**: Angular velocity (rotation)
- **Left Trigger**: Emergency stop
- **Right Trigger**: End episode / Start next episode
- **Left Grip**: Reset robot position
- **Right Grip**: Toggle recording

**Network Streaming:**

When using Isaac Sim on Brev, the VR rendering is streamed to Quest 3 over the network. Ensure:
- Low-latency network connection (< 50ms recommended)
- Sufficient bandwidth for VR streaming (50+ Mbps recommended)
- Quest 3 and Brev deployment on the same network or VPN

Custom Keybindings
-------------------

Customize keybindings for your workflow:

.. code-block:: python

   teleop_config = uv.teleop.configure(
       interface="keyboard",
       robot_type="coco_wheeled",
       scene_path="/path/to/scene.usd",
       keybindings={
           "forward": "w",
           "backward": "s",
           "left": "a",
           "right": "d",
           "stop": "space",
           "reset": "r",
           "record": "t",  # Custom: Toggle recording
           "slow_mode": "shift",  # Custom: Slow movement mode
       },
   )

Velocity Scaling
----------------

Adjust velocity scaling for different control sensitivities:

.. code-block:: python

   teleop_config = uv.teleop.configure(
       interface="keyboard",
       robot_type="coco_wheeled",
       scene_path="/path/to/scene.usd",
       velocity_scaling={
           "linear_max": 1.5,  # Maximum linear velocity (m/s)
           "angular_max": 1.0,  # Maximum angular velocity (rad/s)
           "acceleration": 0.5,  # Acceleration rate
       },
   )

Recording Demonstrations
-------------------------

Teleoperation can automatically record demonstrations for imitation learning:

.. code-block:: python

   uv.teleop.start(
       config=teleop_config,
       output_dir="demos/my_demonstrations",
       record_demonstrations=True,
       record_format="urbanverse_bc",  # Format for BC training
       max_episodes=20,
       episode_length=300,
   )

The recorded demonstrations are saved in UrbanVerse's standard BC dataset format (see :doc:`../robot_learning/imitation_learning/dataset_format`).

API Reference
-------------

Configure Teleoperation
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uv.teleop.configure(
       interface: str,
       robot_type: str,
       scene_path: str,
       keybindings: dict | None = None,
       gamepad_mapping: dict | None = None,
       velocity_scaling: dict | None = None,
   ) -> TeleopConfig

**Parameters:**

- **interface** (str): Teleoperation interface type (``"keyboard"``, ``"joystick"``, ``"vr"``)
- **robot_type** (str): Robot embodiment identifier
- **scene_path** (str): Path to USD scene file
- **keybindings** (dict, optional): Custom keyboard keybindings
- **velocity_scaling** (dict, optional): Velocity scaling parameters
- **vr_settings** (dict, optional): VR-specific settings (for Quest 3, includes OpenXR configuration)

**Returns:**

- **TeleopConfig**: Configuration object for teleoperation session

Start Teleoperation
~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uv.teleop.start(
       config: TeleopConfig,
       output_dir: str,
       record_demonstrations: bool = False,
       max_episodes: int = 1,
       episode_length: int = 300,
   ) -> str

**Parameters:**

- **config** (TeleopConfig): Teleoperation configuration
- **output_dir** (str): Directory to save recordings (if enabled)
- **record_demonstrations** (bool, optional): Whether to record demonstrations. Default: ``False``
- **max_episodes** (int, optional): Maximum number of episodes. Default: ``1``
- **episode_length** (int, optional): Maximum steps per episode. Default: ``300``

**Returns:**

- **str**: Path to output directory (if recording enabled)
