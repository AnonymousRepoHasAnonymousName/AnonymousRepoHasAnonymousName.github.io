.. _urbanverse-api-teleoperation:

Teleoperation API
=================

The Teleoperation API provides functions for configuring and starting manual robot control sessions.

Import
------

.. code-block:: python

   import urbanverse as uv

Configure Teleoperation
-----------------------

.. code-block:: python

   uv.teleop.configure(
       interface: str,
       robot_type: str,
       scene_path: str,
       keybindings: dict | None = None,
       velocity_scaling: dict | None = None,
       vr_settings: dict | None = None,
   ) -> TeleopConfig

Configure a teleoperation session for manual robot control.

**Parameters:**

- **interface** (str): Teleoperation interface type. Options:
  - ``"keyboard"``: Keyboard controls
  - ``"joystick"``: Joystick interface
  - ``"vr"``: VR headset and controllers (Meta Oculus Quest 3)
- **robot_type** (str): Robot embodiment identifier (e.g., ``"coco_wheeled"``, ``"unitree_go2"``)
- **scene_path** (str): Path to USD scene file
- **keybindings** (dict, optional): Custom keyboard keybindings. Default keybindings:
  - ``"forward"``: ``"w"`` or ``"up"``
  - ``"backward"``: ``"s"`` or ``"down"``
  - ``"left"``: ``"a"`` or ``"left"``
  - ``"right"``: ``"d"`` or ``"right"``
  - ``"stop"``: ``"space"``
  - ``"reset"``: ``"r"``
- **velocity_scaling** (dict, optional): Velocity scaling parameters:
  - ``"linear_max"``: Maximum linear velocity (m/s)
  - ``"angular_max"``: Maximum angular velocity (rad/s)
  - ``"acceleration"``: Acceleration rate
- **vr_settings** (dict, optional): VR-specific settings (for Quest 3). Required keys:
  - ``"headset_type"``: ``"oculus_quest_3"``
  - ``"openxr_runtime"``: ``"oculus"``
  - ``"controller_mapping"``: Dictionary mapping controller inputs to actions
  - ``"rendering"``: Dictionary with:
    - ``"output_plugin"``: ``"openxr"``
    - ``"resolution"``: ``[1920, 1832]`` (per-eye)
    - ``"refresh_rate"``: ``90``

**Returns:**

- **TeleopConfig**: Configuration object for teleoperation session

**Example:**

.. code-block:: python

   # Keyboard configuration
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
       velocity_scaling={
           "linear_max": 1.5,
           "angular_max": 1.0,
           "acceleration": 0.5,
       },
   )

   # VR configuration (Quest 3)
   from omni.isaac.core.utils.extensions import enable_extension
   enable_extension("omni.kit.openxr")

   vr_config = uv.teleop.configure(
       interface="vr",
       robot_type="coco_wheeled",
       scene_path="/path/to/scene.usd",
       vr_settings={
           "headset_type": "oculus_quest_3",
           "openxr_runtime": "oculus",
           "controller_mapping": {
               "left_joystick_y": "linear_velocity",
               "right_joystick_x": "angular_velocity",
               "left_trigger": "emergency_stop",
               "right_trigger": "end_episode",
               "left_grip": "reset_robot",
           },
           "rendering": {
               "output_plugin": "openxr",
               "resolution": [1920, 1832],
               "refresh_rate": 90,
           },
       },
   )

Start Teleoperation
-------------------

.. code-block:: python

   uv.teleop.start(
       config: TeleopConfig,
       output_dir: str,
       record_demonstrations: bool = False,
       max_episodes: int = 1,
       episode_length: int = 300,
       enable_vr_rendering: bool = False,
       vr_streaming: bool = False,
   ) -> str

Start a teleoperation session with the configured interface.

**Parameters:**

- **config** (TeleopConfig): Teleoperation configuration (from ``configure``)
- **output_dir** (str): Directory to save recordings (if enabled)
- **record_demonstrations** (bool, optional): Whether to record demonstrations for imitation learning. Default: ``False``
- **max_episodes** (int, optional): Maximum number of episodes. Default: ``1``
- **episode_length** (int, optional): Maximum steps per episode. Default: ``300``
- **enable_vr_rendering** (bool, optional): Enable VR rendering (for VR interface). Default: ``False``
- **vr_streaming** (bool, optional): Stream VR rendering to headset over network (for Brev deployment). Default: ``False``

**Returns:**

- **str**: Path to output directory (if recording enabled)

**Example:**

.. code-block:: python

   # Start keyboard teleoperation with recording
   output_dir = uv.teleop.start(
       config=teleop_config,
       output_dir="demos/keyboard_teleop",
       record_demonstrations=True,
       max_episodes=20,
   )

   # Start VR teleoperation (Quest 3)
   output_dir = uv.teleop.start(
       config=vr_config,
       output_dir="demos/vr_quest3_teleop",
       record_demonstrations=True,
       enable_vr_rendering=True,
       vr_streaming=True,  # For Brev deployment
   )

**Default Controls:**

**Keyboard:**
- **W / Up Arrow**: Move forward
- **S / Down Arrow**: Move backward
- **A / Left Arrow**: Rotate left
- **D / Right Arrow**: Rotate right
- **Space**: Emergency stop
- **R**: Reset robot position
- **Enter**: End episode / Start next episode

**VR (Quest 3):**
- **Left Joystick (Y-axis)**: Linear velocity (forward/backward)
- **Right Joystick (X-axis)**: Angular velocity (rotation)
- **Left Trigger**: Emergency stop
- **Right Trigger**: End episode / Start next episode
- **Left Grip**: Reset robot position
- **Right Grip**: Toggle recording

**Recording Format:**

When ``record_demonstrations=True``, demonstrations are saved in UrbanVerse's standard BC dataset format (see :doc:`../robot_learning/imitation_learning/dataset_format`).

