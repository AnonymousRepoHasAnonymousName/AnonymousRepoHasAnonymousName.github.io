.. _urbanverse-robot-learning-configuration:

General Configurations
===========================

UrbanVerse uses a structured configuration system to define training environments for
goal-directed navigation.  
Similar to the configuration style used in robotics simulation frameworks, UrbanVerse
encapsulates all environment parameters—scenes, robot embodiment, observation and
action spaces, rewards, and termination logic—under a unified configuration object.

The central configuration entry point is ``EnvCfg``.  
This class specifies **how an UrbanVerse navigation environment should be built**, and is
consumed by the high-level training API:

``uv.navigation.rl.create_env(cfg)``

This page introduces the roles of each configuration component, their hierarchy, and how they
together define a full reinforcement learning environment.


EnvCfg: The Environment Schema
------------------------------

``EnvCfg`` is a lightweight configuration schema describing the full training environment:

.. code-block:: python

   from urbanverse.navigation.config import (
       EnvCfg, SceneCfg, ObservationCfg, ActionCfg,
       RewardCfg, TerminationCfg, CurriculumCfg
   )

   cfg = EnvCfg(
       scenes=SceneCfg(scene_paths=my_scene_list),
       robot_type="coco_wheeled",
       observations=ObservationCfg(),
       actions=ActionCfg(),
       rewards=RewardCfg(),
       terminations=TerminationCfg(),
       curriculum=CurriculumCfg(),
   )

Once initialized, an environment is created via:

.. code-block:: python

   env = uv.navigation.rl.create_env(cfg)

   uv.navigation.rl.train(
       env=env,
       training_cfg=training_cfg,
       output_dir="outputs/ppo_run",
   )

The remainder of this section explains each field in detail.


Scene Configuration
-------------------

UrbanVerse scenes are **real-to-sim USD environments** reconstructed by UrbanVerse-Gen or
provided as part of UrbanVerse-160 / CraftBench.  
Scene configuration specifies *which* scenes to load and *how* they should be distributed
across parallel simulation instances.

.. code-block:: python

   SceneCfg(
       scene_paths=[
           "/path/UrbanVerse-160/Asia_Japan_Tokyo_0001/scene_cousin_01/scene.usd",
           "/path/UrbanVerse-160/Africa_SouthAfrica_CapeTown_0002/scene_cousin_03/scene.usd",
           ...
       ],
       async_sim=True,
       env_spacing=3.0,
   )

Key Parameters
~~~~~~~~~~~~~~

- **scene_paths**  
  A list of USD scenes. Each path may represent a different **layout** (city) and/or
  different **digital cousin variants** of the same layout.

- **async_sim**  
  - ``True``: each environment loads a different scene in parallel (recommended)  
    – ideal for generalization  
  - ``False``: all environments use the same layout but different cousin variants  
    – ideal for debugging and controlled experiments

- **env_spacing**  
  The horizontal offset between parallel environments in the simulator.

UrbanVerse ensures that each training worker receives a valid scene and that scenes can be
shuffled or rotated between episodes through the RL API.


Observation Configuration
-------------------------

The UrbanVerse navigation task uses a compact sensor specification suitable for on-policy RL:

.. code-block:: python

   ObservationCfg(
       rgb_size=(135, 240),
       use_depth=False,
       include_goal_vector=True,
   )

Fields
~~~~~~

- **rgb_size** – resolution of the onboard camera  
- **use_depth** – whether a depth channel is included  
- **include_goal_vector** – the relative (dx, dy) distance to the goal is appended to the
  observation buffer

This aligns with the network architecture described in the UrbanVerse paper.


Action Configuration
---------------------

Actions define the control interface for the robot.  
UrbanVerse exposes a continuous velocity-command interface for ``coco_wheeled``:

.. code-block:: python

   ActionCfg(
       action_dim=2,         # linear_x, angular_z
       linear_limit=1.0,
       angular_limit=1.0,
   )

This configuration is passed into the environment and later used by the PPO actor network.


Reward Configuration
---------------------

Rewards in UrbanVerse reflect the design presented in the paper, balancing:

- arrival reward  
- collision penalty  
- coarse & fine waypoint tracking  
- velocity alignment  

These fields are bundled in ``RewardCfg``:

.. code-block:: python

   RewardCfg(
       arrived_reward=2000.0,
       collision_penalty=-200.0,
       tracking_fine_std=1.0,
       tracking_fine_weight=50.0,
       tracking_coarse_std=5.0,
       tracking_coarse_weight=10.0,
       velocity_weight=10.0,
   )

This schema allows reproducible experiments across UrbanVerse scenes.


Termination Configuration
--------------------------

UrbanVerse defines a minimal set of clear termination conditions:

- success (goal reached)
- collision
- timeout (episode length exceeded)
- out-of-bounds / leaving traversable regions

These are collected in:

.. code-block:: python

   TerminationCfg(
       max_episode_steps=300,
       enable_collision=True,
       enable_success=True,
       enable_timeout=True,
   )


Curriculum Configuration
------------------------

An optional curriculum can be enabled to gradually increase training difficulty by:

- expanding goal distance ranges  
- introducing lighting or cousin jitter  
- varying robot initialization poses  

.. code-block:: python

   CurriculumCfg(
       enable_goal_distance_curriculum=True,
       enable_cousin_jitter=True,
   )

Curriculum settings are optional but often accelerate early-stage learning.



Dynamic Initialization
----------------------

Robot spawn points are automatically sampled from **drivable road regions** of each scene:

.. code-block:: python

   robot_cfg.init_state.pos = sample_valid_spawn_point()
   robot_cfg.init_state.yaw = sample_valid_heading()

This ensures valid initialization across diverse city layouts.


Summary
--------

- ``EnvCfg`` defines the entire UrbanVerse training environment  
- It specifies scenes, robots, observations, actions, rewards, terminations, and optional curriculum  
- Configuration style mirrors established robotics-simulation documentation practices  
- The API remains simple:

  ``env = uv.navigation.rl.create_env(cfg)``  
  ``uv.navigation.rl.train(env, ...)``

This structuring ensures clarity, reproducibility, and extensibility for robot learning research in UrbanVerse.
