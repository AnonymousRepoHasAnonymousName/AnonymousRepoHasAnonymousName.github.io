.. _urbanverse-api-configuration:

Configuration API
=================

The Configuration API provides classes for defining RL environment configurations in UrbanVerse.

Import
------

.. code-block:: python

   from urbanverse.navigation.config import (
       EnvCfg, SceneCfg, ObservationCfg, ActionCfg,
       RewardCfg, TerminationCfg, CurriculumCfg, EventCfg
   )

EnvCfg
------

.. code-block:: python

   EnvCfg(
       scenes: SceneCfg,
       robot_type: str,
       observations: ObservationCfg,
       actions: ActionCfg,
       rewards: RewardCfg,
       terminations: TerminationCfg,
       curriculum: CurriculumCfg | None = None,
       events: EventCfg | None = None,
   )

Central configuration class that defines the complete RL environment.

**Parameters:**

- **scenes** (SceneCfg): Scene configuration (see below)
- **robot_type** (str): Robot embodiment identifier
- **observations** (ObservationCfg): Observation space configuration (see below)
- **actions** (ActionCfg): Action space configuration (see below)
- **rewards** (RewardCfg): Reward function configuration (see below)
- **terminations** (TerminationCfg): Termination conditions configuration (see below)
- **curriculum** (CurriculumCfg, optional): Curriculum learning configuration (see below)
- **events** (EventCfg, optional): Event configuration (see below)

**Example:**

.. code-block:: python

   cfg = EnvCfg(
       scenes=SceneCfg(scene_paths=["/path/to/scene.usd"], async_sim=True),
       robot_type="coco_wheeled",
       observations=ObservationCfg(rgb_size=(135, 240)),
       actions=ActionCfg(),
       rewards=RewardCfg(),
       terminations=TerminationCfg(max_episode_steps=300),
       curriculum=CurriculumCfg(enable_goal_distance_curriculum=True),
   )

SceneCfg
--------

.. code-block:: python

   SceneCfg(
       scene_paths: list[str],
       async_sim: bool = True,
       env_spacing: float = 3.0,
   )

Configuration for scene loading and distribution.

**Parameters:**

- **scene_paths** (list[str]): List of USD scene file paths
- **async_sim** (bool, optional): Scene distribution mode. Default: ``True``
  - ``True``: Each environment loads a different scene (recommended for generalization)
  - ``False``: All environments use the same layout but different cousin variants
- **env_spacing** (float, optional): Horizontal spacing between parallel environments (meters). Default: ``3.0``

ObservationCfg
--------------

.. code-block:: python

   ObservationCfg(
       rgb_size: tuple[int, int] = (135, 240),
       use_depth: bool = False,
       include_goal_vector: bool = True,
   )

Configuration for observation space.

**Parameters:**

- **rgb_size** (tuple[int, int], optional): RGB camera image resolution (height, width). Default: ``(135, 240)``
- **use_depth** (bool, optional): Whether to include depth channel. Default: ``False``
- **include_goal_vector** (bool, optional): Whether to include goal-relative position vector (dx, dy). Default: ``True``

ActionCfg
---------

.. code-block:: python

   ActionCfg(
       action_dim: int = 2,
       linear_limit: float = 1.0,
       angular_limit: float = 1.0,
   )

Configuration for action space.

**Parameters:**

- **action_dim** (int, optional): Action dimension. Default: ``2`` (linear, angular for wheeled robots)
- **linear_limit** (float, optional): Maximum linear velocity (m/s). Default: ``1.0``
- **angular_limit** (float, optional): Maximum angular velocity (rad/s). Default: ``1.0``

**Note:** Action space is automatically adapted based on robot type. For legged/humanoid robots, joint-level controls are used.

RewardCfg
---------

.. code-block:: python

   RewardCfg(
       arrived_reward: float = 2000.0,
       collision_penalty: float = -200.0,
       tracking_fine_std: float = 1.0,
       tracking_fine_weight: float = 50.0,
       tracking_coarse_std: float = 5.0,
       tracking_coarse_weight: float = 10.0,
       velocity_weight: float = 10.0,
   )

Configuration for reward function.

**Parameters:**

- **arrived_reward** (float, optional): Reward for reaching goal. Default: ``2000.0``
- **collision_penalty** (float, optional): Penalty for collisions. Default: ``-200.0``
- **tracking_fine_std** (float, optional): Standard deviation for fine waypoint tracking (meters). Default: ``1.0``
- **tracking_fine_weight** (float, optional): Weight for fine tracking reward. Default: ``50.0``
- **tracking_coarse_std** (float, optional): Standard deviation for coarse waypoint tracking (meters). Default: ``5.0``
- **tracking_coarse_weight** (float, optional): Weight for coarse tracking reward. Default: ``10.0``
- **velocity_weight** (float, optional): Weight for velocity alignment reward. Default: ``10.0``

TerminationCfg
--------------

.. code-block:: python

   TerminationCfg(
       max_episode_steps: int = 300,
       enable_collision: bool = True,
       enable_success: bool = True,
       enable_timeout: bool = True,
       enable_out_of_bounds: bool = False,
   )

Configuration for episode termination conditions.

**Parameters:**

- **max_episode_steps** (int, optional): Maximum steps before timeout. Default: ``300``
- **enable_collision** (bool, optional): Terminate on collision. Default: ``True``
- **enable_success** (bool, optional): Terminate on goal reached. Default: ``True``
- **enable_timeout** (bool, optional): Terminate on step limit. Default: ``True``
- **enable_out_of_bounds** (bool, optional): Terminate when leaving traversable regions. Default: ``False``

CurriculumCfg
-------------

.. code-block:: python

   CurriculumCfg(
       enable_goal_distance_curriculum: bool = False,
       enable_cousin_jitter: bool = False,
   )

Configuration for curriculum learning.

**Parameters:**

- **enable_goal_distance_curriculum** (bool, optional): Gradually increase goal distances. Default: ``False``
- **enable_cousin_jitter** (bool, optional): Gradually increase scene diversity. Default: ``False``

EventCfg
--------

.. code-block:: python

   EventCfg(
       enable_robot_state_randomization: bool = False,
       enable_dynamic_agent_spawning: bool = False,
   )

Configuration for environment events and randomization.

**Parameters:**

- **enable_robot_state_randomization** (bool, optional): Randomize robot initial state. Default: ``False``
- **enable_dynamic_agent_spawning** (bool, optional): Spawn dynamic agents during episodes. Default: ``False``

**Note:** Robot spawn points are automatically sampled from drivable regions. This configuration is for additional randomization.

