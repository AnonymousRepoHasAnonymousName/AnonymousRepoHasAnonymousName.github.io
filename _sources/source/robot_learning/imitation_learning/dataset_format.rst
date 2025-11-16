.. _urbanverse-il-dataset-format:

Demonstration Dataset Format
=============================

UrbanVerse uses a standardized, simple dataset format for behavior cloning that ensures consistency across different data collection methods and makes it easy to work with demonstration data. Understanding this format is essential for creating custom data collection tools, debugging training issues, and analyzing demonstration quality.

Dataset Directory Structure
----------------------------

All demonstration datasets follow a consistent directory layout:

.. code-block:: text

   demos/
   ├── episode_000/
   │   ├── obs.npy          # Observation array (N, ...)
   │   ├── act.npy          # Action array (N, action_dim)
   │   └── meta.json        # Episode metadata
   ├── episode_001/
   │   ├── obs.npy
   │   ├── act.npy
   │   └── meta.json
   ├── episode_002/
   │   └── ...
   └── dataset_index.json   # Dataset-level metadata and statistics

Each episode directory contains one complete navigation trajectory from start to goal (or termination).

Observation Format
-------------------

Observations are stored as NumPy arrays in ``obs.npy`` files. Each observation is a structured array containing:

**For COCO Wheeled Robot (example):**

.. code-block:: python

   obs = {
       "rgb": np.array([135, 240, 3], dtype=np.uint8),      # RGB camera image
       "goal_vector": np.array([2], dtype=np.float32),      # (dx, dy) relative to goal
       "robot_state": np.array([...], dtype=np.float32),    # Velocity, pose, etc.
   }

**Observation Components:**

1. **RGB Image** (``rgb``)
   - Shape: ``(height, width, 3)``
   - Type: ``uint8`` (values 0-255)
   - Default resolution: 135×240 pixels (configurable)
   - Format: Standard RGB color image from onboard camera

2. **Goal Vector** (``goal_vector``)
   - Shape: ``(2,)``
   - Type: ``float32``
   - Content: ``[dx, dy]`` - relative position from robot to goal in meters
   - Normalized: Typically normalized to unit length or clipped to reasonable ranges

3. **Robot State** (``robot_state``, optional)
   - Shape: Variable depending on robot type
   - Type: ``float32``
   - Content: Proprioceptive information (linear velocity, angular velocity, joint positions, etc.)

**Observation Array Structure:**

The ``obs.npy`` file contains a sequence of observations:

.. code-block:: python

   import numpy as np

   obs_data = np.load("episode_000/obs.npy")
   # Shape: (episode_length, obs_dim)
   # For COCO: (N, 135*240*3 + 2 + state_dim)

   # Access first observation
   first_obs = obs_data[0]

Action Format
-------------

Actions are stored as NumPy arrays in ``act.npy`` files. The action format depends on the robot type:

**COCO Wheeled Robot:**
- Shape: ``(episode_length, 2)``
- Content: ``[linear_velocity, angular_velocity]``
- Type: ``float32``
- Range: Typically normalized to ``[-1, 1]`` before scaling

**Unitree Go2 (Quadruped):**
- Shape: ``(episode_length, 12)``
- Content: Joint velocity commands for 12 joints
- Type: ``float32``

**Unitree G1 (Humanoid):**
- Shape: ``(episode_length, action_dim)``
- Content: Joint-angle or torque-based controls
- Type: ``float32``

**Action Array Example:**

.. code-block:: python

   import numpy as np

   act_data = np.load("episode_000/act.npy")
   # Shape: (episode_length, action_dim)
   # For COCO: (N, 2)

   # Access first action
   first_action = act_data[0]  # [v_linear, v_angular]

Episode Metadata
----------------

Each episode directory contains a ``meta.json`` file with episode-level information:

.. code-block:: json

   {
       "episode_id": "episode_000",
       "scene_path": "/path/to/UrbanVerse-160/CapeTown_0001/scene.usd",
       "robot_type": "coco_wheeled",
       "episode_length": 287,
       "start_time": 0.0,
       "end_time": 28.7,
       "goal_position": [15.3, 8.7, 0.0],
       "start_position": [2.1, 1.5, 0.0],
       "outcome": "success",
       "termination_reason": "goal_reached",
       "collection_timestamp": "2024-01-15T10:30:00Z",
       "control_mode": "teleop_gamepad"
   }

**Metadata Fields:**

- **episode_id**: Unique identifier for this episode
- **scene_path**: USD scene file used for this demonstration
- **robot_type**: Robot embodiment identifier
- **episode_length**: Number of timesteps in this episode
- **start_time / end_time**: Timestamps (in seconds) for episode start and end
- **goal_position**: 3D goal position ``[x, y, z]`` in scene coordinates
- **start_position**: 3D starting position ``[x, y, z]``
- **outcome**: Episode result (``"success"``, ``"collision"``, ``"timeout"``)
- **termination_reason**: Why the episode ended
- **collection_timestamp**: When the demonstration was collected
- **control_mode**: Teleoperation method used

Dataset Index
-------------

The root dataset directory contains ``dataset_index.json`` with dataset-level information:

.. code-block:: json

   {
       "dataset_version": "1.0",
       "robot_type": "coco_wheeled",
       "num_episodes": 20,
       "total_timesteps": 5423,
       "episode_ids": ["episode_000", "episode_001", ...],
       "scene_paths": [
           "/path/to/UrbanVerse-160/CapeTown_0001/scene.usd",
           "/path/to/UrbanVerse-160/Tokyo_0002/scene.usd"
       ],
       "collection_date": "2024-01-15",
       "statistics": {
           "avg_episode_length": 271.15,
           "success_rate": 0.85,
           "avg_goal_distance": 12.3
       }
   }

This index file provides a quick overview of the dataset and is used by training and evaluation tools to understand the dataset structure.

Temporal Alignment
-------------------

Observations and actions are temporally aligned:

- **Synchronous sampling**: Each observation corresponds to the state at timestep ``t``
- **Action application**: Each action is applied at timestep ``t`` and affects the state at ``t+1``
- **Frame skipping**: Optional frame skipping can be configured (e.g., use every 4th frame) to reduce dataset size

**Standard alignment:**
- Observation at timestep ``t`` → Action at timestep ``t`` → Next observation at timestep ``t+1``

This ensures that the policy learns to predict actions based on current observations, matching the inference-time behavior.

Working with Demonstration Data
--------------------------------

You can easily load and inspect demonstration data:

.. code-block:: python

   import numpy as np
   import json

   # Load an episode
   episode_dir = "demos/episode_000"
   
   obs = np.load(f"{episode_dir}/obs.npy")
   act = np.load(f"{episode_dir}/act.npy")
   meta = json.load(open(f"{episode_dir}/meta.json"))

   print(f"Episode length: {len(obs)}")
   print(f"Observation shape: {obs[0].shape}")
   print(f"Action shape: {act[0].shape}")
   print(f"Outcome: {meta['outcome']}")

   # Visualize trajectory
   import matplotlib.pyplot as plt
   
   goal_vecs = obs[:, -2:]  # Extract goal vectors
   plt.plot(goal_vecs[:, 0], goal_vecs[:, 1])
   plt.xlabel("dx (meters)")
   plt.ylabel("dy (meters)")
   plt.title("Goal Vector Trajectory")

This standardized format ensures that all UrbanVerse IL tools (training, evaluation, analysis) work seamlessly with demonstration data, regardless of how it was collected.

