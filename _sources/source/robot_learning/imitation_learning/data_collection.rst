.. _urbanverse-il-data-collection:

Collecting Expert Demonstrations
==================================

Expert demonstrations are the foundation of behavior cloning. UrbanVerse provides flexible tools for collecting demonstrations either directly within the simulation environment or by importing external demonstration data from real-world deployments.

Two Data Collection Pathways
-----------------------------

UrbanVerse supports two primary methods for obtaining expert demonstrations:

**A. Teleoperation Inside UrbanVerse**  
Manually control the robot using keyboard, joystick, gamepad, or VR interfaces while navigating to goals in UrbanVerse scenes. This method provides direct control over demonstration quality and scene diversity.

**B. Importing External Demonstrations**  
Convert demonstration logs from external sources (e.g., ROS bags, real-world robot teleoperation) into UrbanVerse's standardized format. This enables incorporating real-world navigation data into your training pipeline.

Method A: Teleoperation Collection
-----------------------------------

UrbanVerse's teleoperation interface allows you to manually control robots while the system automatically records observations, actions, and metadata. This is the most straightforward way to collect demonstrations.

Collecting Demonstrations via Teleoperation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the ``collect_data`` API to start a teleoperation session:

.. code-block:: python

   import urbanverse as uv

   demo_dir = uv.navigation.il.collect_data(
       scene_paths=[
           "/path/to/UrbanVerse-160/CapeTown_0001/scene.usd",
           "/path/to/UrbanVerse-160/Tokyo_0002/scene.usd",
       ],
       robot_type="coco_wheeled",
       output_dir="demos/my_teleop_collection",
       control_mode="teleop_gamepad",  # or "teleop_keyboard", "teleop_joystick", "teleop_vr"
       max_episodes=20,
   )

   print(f"Demonstrations saved to: {demo_dir}")

API Reference: ``uv.navigation.il.collect_data``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uv.navigation.il.collect_data(
       scene_paths: list[str],
       robot_type: str,
       output_dir: str,
       control_mode: str = "teleop_gamepad",
       max_episodes: int = 20,
       episode_length: int = 300,
       goal_sampling: str = "random",
   ) -> str

**Parameters:**

- **scene_paths** (list[str]): List of USD scene file paths to collect demonstrations in
- **robot_type** (str): Robot embodiment identifier (e.g., ``"coco_wheeled"``, ``"unitree_go2"``)
- **output_dir** (str): Directory where demonstration data will be saved
- **control_mode** (str): Teleoperation interface to use:
  - ``"teleop_keyboard"``: Keyboard controls (arrow keys for movement)
  - ``"teleop_gamepad"``: Gamepad/controller (recommended for smooth control)
  - ``"teleop_joystick"``: Joystick interface
  - ``"teleop_vr"``: VR headset and controllers (if VR support is enabled)
- **max_episodes** (int): Maximum number of demonstration episodes to collect
- **episode_length** (int): Maximum steps per episode (episode ends on goal reached, collision, or timeout)
- **goal_sampling** (str): How to sample goal positions:
  - ``"random"``: Random goals from drivable regions
  - ``"curriculum"``: Gradually increasing goal distances
  - ``"fixed"``: Fixed goal positions for consistency

**Returns:**

- **str**: Path to the created demonstration dataset directory

**Output Structure:**

The function creates a dataset directory with the following structure:

.. code-block:: text

   output_dir/
   ├── episode_000/
   │   ├── obs.npy          # Observations array
   │   ├── act.npy          # Expert actions array
   │   └── meta.json        # Episode metadata
   ├── episode_001/
   ├── episode_002/
   └── dataset_index.json   # Dataset summary and statistics

Teleoperation Controls
~~~~~~~~~~~~~~~~~~~~~~~

**Keyboard Controls** (``teleop_keyboard``):
- Arrow keys: Forward/backward, left/right rotation
- Space: Emergency stop
- Enter: End current episode and start next

**Gamepad Controls** (``teleop_gamepad``):
- Left stick: Forward/backward movement
- Right stick: Rotation
- A button: End episode
- B button: Emergency stop

**Joystick Controls** (``teleop_joystick``):
- Joystick axes: Velocity commands
- Buttons: Episode control

**VR Controls** (``teleop_vr``):
- VR controllers: Natural hand-based control
- Grip buttons: Episode control

Best Practices for Teleoperation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Collect diverse scenarios**: Navigate to goals at various distances and in different scene regions
- **Include recovery behaviors**: Demonstrate how to recover from near-collisions or difficult situations
- **Maintain consistent quality**: Try to demonstrate smooth, efficient navigation paths
- **Vary scene conditions**: Collect demonstrations across different UrbanVerse scenes to improve generalization
- **Record sufficient data**: Aim for 20-50 episodes per scene for robust learning

Method B: Importing External Demonstrations
--------------------------------------------

If you have demonstration data from external sources (real-world robot deployments, other simulators, or different data formats), UrbanVerse provides tools to convert them into the standard BC dataset format.

Importing External Data
~~~~~~~~~~~~~~~~~~~~~~~~

Use the ``import_external`` API to convert external demonstration logs:

.. code-block:: python

   import urbanverse as uv

   demo_dir = uv.navigation.il.import_external(
       demo_source="/path/to/ros_bag/demo.bag",
       output_dir="demos/imported_ros_data",
       mapping_cfg={
           "format": "rosbag",
           "topic_obs": "/camera/rgb/image_raw",
           "topic_act": "/cmd_vel",
           "topic_goal": "/navigation/goal",
           "coordinate_transform": "ros_to_urbanverse",
       },
   )

API Reference: ``uv.navigation.il.import_external``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uv.navigation.il.import_external(
       demo_source: str,
       output_dir: str,
       mapping_cfg: dict,
   ) -> str

**Parameters:**

- **demo_source** (str): Path to external demonstration data (ROS bag, CSV, HDF5, etc.)
- **output_dir** (str): Directory where converted demonstrations will be saved
- **mapping_cfg** (dict): Configuration dictionary specifying:
  - ``format``: Source data format (``"rosbag"``, ``"csv"``, ``"hdf5"``, etc.)
  - Topic/field mappings for observations, actions, and goals
  - Coordinate transformations (if needed)
  - Temporal alignment parameters

**Returns:**

- **str**: Path to the created demonstration dataset directory

Supported Import Formats
~~~~~~~~~~~~~~~~~~~~~~~~~

**ROS Bag Files:**
- Extract image topics, command velocity topics, and goal position topics
- Handle timestamp synchronization and coordinate frame transformations
- Convert ROS coordinate conventions to UrbanVerse conventions

**CSV/HDF5 Files:**
- Flexible field mapping for custom data formats
- Support for various observation and action representations

**Custom Formats:**
- Extensible interface for adding support for additional data formats

Example: Converting ROS Bag to UrbanVerse Format
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   import urbanverse as uv

   # Convert ROS bag with navigation demonstrations
   demo_dir = uv.navigation.il.import_external(
       demo_source="real_world_demos/robot_nav_2024.bag",
       output_dir="demos/real_world_imported",
       mapping_cfg={
           "format": "rosbag",
           "topic_obs": "/front_camera/image_raw",
           "topic_act": "/mobile_base/cmd_vel",
           "topic_goal": "/move_base_simple/goal",
           "topic_pose": "/odom",
           "coordinate_transform": {
               "type": "ros_to_urbanverse",
               "frame_id": "map",
           },
           "temporal_sync": {
               "method": "nearest_neighbor",
               "tolerance": 0.1,  # seconds
           },
       },
   )

The import process automatically:
- Extracts relevant topics/fields from the source data
- Synchronizes timestamps across different data streams
- Transforms coordinates to UrbanVerse's coordinate system
- Validates data consistency and completeness
- Saves everything in UrbanVerse's standard BC dataset format

Data Quality Considerations
----------------------------

Regardless of collection method, ensure your demonstrations:

- **Cover diverse scenarios**: Include various goal distances, scene regions, and navigation challenges
- **Maintain temporal consistency**: Observations and actions should be properly synchronized
- **Include sufficient diversity**: Avoid overfitting to specific navigation patterns
- **Record metadata**: Goal positions, episode outcomes, and scene information help with analysis

The next section details the exact format of UrbanVerse's demonstration datasets, enabling you to understand the data structure and potentially create custom data collection tools.

