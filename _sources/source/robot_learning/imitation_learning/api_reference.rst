.. _urbanverse-robot-learning-il-guide-api-reference:

UrbanVerse IL APIs
===================

UrbanVerse provides a unified API for all imitation learning operations, from data collection to policy deployment. This section documents the complete API surface, with detailed parameter descriptions and usage examples.

Data Collection API
--------------------

Collect Demonstrations via Teleoperation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

Collect expert demonstrations by manually controlling the robot in UrbanVerse scenes.

**Parameters:**

- **scene_paths** (list[str]): List of USD scene file paths. Demonstrations will be collected across these scenes.
- **robot_type** (str): Robot embodiment identifier. Supported values:
  - ``"coco_wheeled"``: COCO wheeled delivery robot
  - ``"nvidia_carter"``: NVIDIA Carter holonomic robot
  - ``"turtlebot3"``: TurtleBot3 differential drive
  - ``"unitree_go2"``: Unitree Go2 quadruped
  - ``"anymal"``: ANYmal quadruped
  - ``"unitree_g1"``: Unitree G1 humanoid
  - ``"booster_t1"``: Booster T1 humanoid
- **output_dir** (str): Directory path where demonstration data will be saved. Will be created if it doesn't exist.
- **control_mode** (str, optional): Teleoperation interface. Default: ``"teleop_gamepad"``
  - ``"teleop_keyboard"``: Keyboard controls
  - ``"teleop_gamepad"``: Gamepad/controller (recommended)
  - ``"teleop_joystick"``: Joystick interface
  - ``"teleop_vr"``: VR headset and controllers
- **max_episodes** (int, optional): Maximum number of episodes to collect. Default: ``20``
- **episode_length** (int, optional): Maximum steps per episode. Default: ``300``
- **goal_sampling** (str, optional): Goal position sampling strategy. Default: ``"random"``
  - ``"random"``: Random goals from drivable regions
  - ``"curriculum"``: Gradually increasing goal distances
  - ``"fixed"``: Fixed goal positions

**Returns:**

- **str**: Path to the created demonstration dataset directory

**Example:**

.. code-block:: python

   import urbanverse as uv

   demo_dir = uv.navigation.il.collect_data(
       scene_paths=[
           "/path/to/UrbanVerse-160/CapeTown_0001/scene.usd",
           "/path/to/UrbanVerse-160/Tokyo_0002/scene.usd",
       ],
       robot_type="coco_wheeled",
       output_dir="demos/capetown_tokyo",
       control_mode="teleop_gamepad",
       max_episodes=30,
   )

Import External Demonstrations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uv.navigation.il.import_external(
       demo_source: str,
       output_dir: str,
       mapping_cfg: dict,
   ) -> str

Convert external demonstration data into UrbanVerse's standard BC dataset format.

**Parameters:**

- **demo_source** (str): Path to external demonstration data file or directory
- **output_dir** (str): Directory where converted demonstrations will be saved
- **mapping_cfg** (dict): Configuration dictionary specifying data format and field mappings. Required keys depend on format:
  
  For ROS bag format:
  - ``"format"``: ``"rosbag"``
  - ``"topic_obs"``: ROS topic name for observations (e.g., ``"/camera/rgb/image_raw"``)
  - ``"topic_act"``: ROS topic name for actions (e.g., ``"/cmd_vel"``)
  - ``"topic_goal"``: ROS topic name for goal positions (e.g., ``"/move_base_simple/goal"``)
  - ``"coordinate_transform"``: Coordinate transformation configuration
  - ``"temporal_sync"``: Temporal synchronization parameters

**Returns:**

- **str**: Path to the created demonstration dataset directory

**Example:**

.. code-block:: python

   import urbanverse as uv

   demo_dir = uv.navigation.il.import_external(
       demo_source="/path/to/real_world_demos.bag",
       output_dir="demos/imported_real_world",
       mapping_cfg={
           "format": "rosbag",
           "topic_obs": "/front_camera/image_raw",
           "topic_act": "/mobile_base/cmd_vel",
           "topic_goal": "/navigation/goal",
           "coordinate_transform": {
               "type": "ros_to_urbanverse",
               "frame_id": "map",
           },
       },
   )

Training API
------------

Train Behavior Cloning Policy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uv.navigation.il.train_bc(
       demo_dir: str,
       robot_type: str,
       output_dir: str,
       train_cfg: dict | None = None,
   ) -> str

Train a behavior cloning policy from demonstration data.

**Parameters:**

- **demo_dir** (str): Path to demonstration dataset directory (created by ``collect_data`` or ``import_external``)
- **robot_type** (str): Robot embodiment identifier (must match the robot type used for data collection)
- **output_dir** (str): Directory where training outputs will be saved (checkpoints, logs, etc.)
- **train_cfg** (dict, optional): Training configuration dictionary. If ``None``, uses default configuration. See :doc:`training_config` for available options.

**Returns:**

- **str**: Path to the best model checkpoint file (typically ``output_dir/checkpoints/best.pt``)

**Example:**

.. code-block:: python

   import urbanverse as uv

   checkpoint_path = uv.navigation.il.train_bc(
       demo_dir="demos/my_teleop_collection",
       robot_type="coco_wheeled",
       output_dir="outputs/bc_coco_policy",
       train_cfg={
           "learning_rate": 1e-4,
           "batch_size": 256,
           "train_epochs": 50,
       },
   )

   print(f"Trained policy saved to: {checkpoint_path}")

**Training Outputs:**

The training process creates the following files in ``output_dir``:

- ``checkpoints/best.pt``: Best model checkpoint (lowest validation loss)
- ``checkpoints/latest.pt``: Latest model checkpoint
- ``logs/training.log``: Training log file
- ``logs/tensorboard/``: TensorBoard event files for visualization
- ``config.yaml``: Saved training configuration

Inference API
-------------

Load BC Policy
~~~~~~~~~~~~~~~

.. code-block:: python

   uv.navigation.il.load_bc_policy(
       checkpoint_path: str,
       robot_type: str,
       device: str = "cuda",
   ) -> Callable

Load a trained BC policy for inference.

**Parameters:**

- **checkpoint_path** (str): Path to model checkpoint file (``.pt`` file)
- **robot_type** (str): Robot embodiment identifier (must match training robot type)
- **device** (str, optional): Device to run inference on. Default: ``"cuda"``. Options: ``"cuda"``, ``"cpu"``

**Returns:**

- **Callable**: Policy function that takes observations and returns actions

**Example:**

.. code-block:: python

   import urbanverse as uv
   import numpy as np

   # Load trained policy
   policy = uv.navigation.il.load_bc_policy(
       checkpoint_path="outputs/bc_coco_policy/checkpoints/best.pt",
       robot_type="coco_wheeled",
   )

   # Use policy for inference
   obs = env.get_observation()  # Get current observation
   action = policy(obs)          # Predict action
   env.step(action)              # Apply action

**Policy Function Signature:**

The loaded policy function has the following signature:

.. code-block:: python

   def policy(observation: dict | np.ndarray) -> np.ndarray:
       """
       Predict action from observation.
       
       Args:
           observation: Observation dict or array containing:
               - "rgb": RGB image array
               - "goal_vector": Goal vector array
               - Optional robot state
       
       Returns:
           action: Predicted action array
       """
       pass

Evaluation API
--------------

Evaluate BC Policy
~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uv.navigation.il.evaluate(
       policy: Callable,
       scene_paths: list[str],
       robot_type: str,
       num_episodes: int = 50,
       max_episode_steps: int = 300,
   ) -> dict

Evaluate a BC policy on UrbanVerse scenes and compute navigation metrics.

**Parameters:**

- **policy** (Callable): BC policy function (loaded via ``load_bc_policy``)
- **scene_paths** (list[str]): List of USD scene file paths to evaluate on
- **robot_type** (str): Robot embodiment identifier
- **num_episodes** (int, optional): Number of evaluation episodes. Default: ``50``
- **max_episode_steps** (int, optional): Maximum steps per episode. Default: ``300``

**Returns:**

- **dict**: Dictionary containing evaluation metrics:
  - ``"SR"`` (float): Success Rate (fraction of episodes reaching goal)
  - ``"RC"`` (float): Route Completion (average fraction of path completed)
  - ``"CT"`` (float): Collision Times (average number of collisions per episode)
  - ``"DTG"`` (float): Distance-to-Goal (average final distance to goal in meters)
  - ``"episode_lengths"`` (list): List of episode lengths
  - ``"outcomes"`` (list): List of episode outcomes (``"success"``, ``"collision"``, ``"timeout"``)

**Example:**

.. code-block:: python

   import urbanverse as uv

   # Load policy
   policy = uv.navigation.il.load_bc_policy(
       checkpoint_path="outputs/bc_coco_policy/checkpoints/best.pt",
       robot_type="coco_wheeled",
   )

   # Evaluate on test scenes
   results = uv.navigation.il.evaluate(
       policy=policy,
       scene_paths=[
           "/path/to/CraftBench/scene_001/scene.usd",
           "/path/to/CraftBench/scene_002/scene.usd",
       ],
       robot_type="coco_wheeled",
       num_episodes=100,
   )

   print(f"Success Rate: {results['SR']:.2%}")
   print(f"Route Completion: {results['RC']:.2%}")
   print(f"Average Collisions: {results['CT']:.2f}")
   print(f"Average Distance to Goal: {results['DTG']:.2f} m")

**Evaluation Metrics:**

- **Success Rate (SR)**: Fraction of episodes where the robot successfully reached the goal
- **Route Completion (RC)**: Average fraction of the planned route completed before termination
- **Collision Times (CT)**: Average number of collisions per episode (lower is better)
- **Distance-to-Goal (DTG)**: Average final distance to goal for unsuccessful episodes (in meters)

These metrics align with standard navigation evaluation protocols and are consistent with CraftBench evaluation metrics.

Complete API Summary
--------------------

.. list-table:: UrbanVerse IL API Summary
   :header-rows: 1
   :widths: 20 30 25 25

   * - API
     - Purpose
     - Input
     - Output
   * - ``collect_data``
     - Collect teleoperated demonstrations
     - Scene paths, robot type, control mode
     - Dataset directory path
   * - ``import_external``
     - Convert external demonstrations
     - External data source, mapping config
     - Dataset directory path
   * - ``train_bc``
     - Train BC policy
     - Dataset directory, robot type, config
     - Checkpoint path
   * - ``load_bc_policy``
     - Load trained policy
     - Checkpoint path, robot type
     - Policy function
   * - ``evaluate``
     - Evaluate policy performance
     - Policy, scene paths, robot type
     - Metrics dictionary

All APIs are designed to work seamlessly together, providing a complete workflow from data collection to policy deployment.

