.. _urbanverse-quickstart-train:


Train Your Robots in UrbanVerse
===============================

UrbanVerse provides a complete pipeline for training **goal-point navigation policies**
in large-scale, physically grounded urban simulation scenes.

This page shows how to:

- load UrbanVerse scenes (built-in or custom),
- configure a robot (using ``coco_wheeled`` as example),
- set PPO and reward configurations,
- and launch training via a Python module entrypoint and the
  ``uv.navigation.rl`` API.

All APIs follow the pattern:

.. code:: python

   import urbanverse as uv



Prerequisites
-------------

Before training, make sure your scene roots are configured
(see the Scene Caching section):

.. code:: bash

   export URBANVERSE_SCENE_ROOT="/path/to/UrbanVerse-160"            # Reconstructed + user-generated scenes
   export URBANVERSE_CRAFTBENCH_ROOT="/path/to/UrbanVerse-CraftBench"  # Artist-designed CraftBench test scenes



Launch Training from CLI
------------------------

UrbanVerse exposes a navigation training entrypoint as a Python module:

.. code:: bash

   python -m uv.navigation.rl.train \
       --robot coco_wheeled \
       --scene_mode urbanverse160 \
       --num_scenes 32 \
       --num_envs 32 \
       --output_dir outputs/coco_nav

This will:

- use the **COCO wheeled** robot,
- load **32 scenes** from ``$URBANVERSE_SCENE_ROOT`` (UrbanVerse-160),
- run **32 parallel environments**,
- and train a PPO-based navigation policy, saving logs and checkpoints
  under ``outputs/coco_nav``.

Suggested CLI arguments
~~~~~~~~~~~~~~~~~~~~~~~

- ``--robot``: robot type (e.g., ``coco_wheeled``).
- ``--scene_mode``:
  
  - ``urbanverse160`` → load scenes from ``$URBANVERSE_SCENE_ROOT``,
  - ``custom`` → use a user-provided list of USD paths.

- ``--scene_paths_file`` (for ``scene_mode=custom``):  
  Path to a text/JSON file with a list of USD scene paths.
- ``--num_scenes``: number of scenes to sample (e.g., 32).
- ``--num_envs``: number of parallel environments.
- ``--output_dir``: output directory for checkpoints and logs.

Internally, this module calls the high-level API
:func:`uv.navigation.rl.train_navigation_policy` described below.



Selecting Scenes for Training
-----------------------------

UrbanVerse supports **two scene selection modes**.


Option A — Custom list of USD scene paths
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use this if you want to train on a curated subset of UrbanVerse-160 or
your own generated scenes stored under ``$URBANVERSE_SCENE_ROOT``.

API
^^^

.. code:: python

   uv.navigation.rl.build_scene_list(
       scene_paths: list[str],
   ) -> list[str]

Example
^^^^^^^

.. code:: python

   import os
   import urbanverse as uv

   scene_paths = uv.navigation.rl.build_scene_list([
       f"{os.environ['URBANVERSE_SCENE_ROOT']}/CapeTown_0001/scene.usd",
       f"{os.environ['URBANVERSE_SCENE_ROOT']}/Tokyo_0005/scene.usd",
       f"{os.environ['URBANVERSE_SCENE_ROOT']}/London_0007/scene.usd",
   ])

   print("Loaded scenes:", len(scene_paths))


Option B — Use UrbanVerse-160 scenes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you prefer to directly use the built-in UrbanVerse-160 library,
UrbanVerse will load scenes from ``$URBANVERSE_SCENE_ROOT``.

API
^^^

.. code:: python

   uv.navigation.rl.load_urbanverse160_scenes(
       num_scenes: int = 32,
       split: str = "train",
       scene_root: str | None = None,
   ) -> list[str]

- If ``scene_root`` is ``None``, it defaults to ``$URBANVERSE_SCENE_ROOT``.
- ``split`` can be used to implement your own train/val/test partitions.

Example
^^^^^^^

.. code:: python

   import urbanverse as uv

   scene_paths = uv.navigation.rl.load_urbanverse160_scenes(
       num_scenes=32,
       split="train",
   )

   print("Example scenes:", scene_paths[:3])



Navigation Task Configuration
-----------------------------

The navigation task configuration controls:

- **robot type** (e.g., ``"coco_wheeled"``),
- **horizon length** (timesteps per rollout),
- **number of parallel environments**,
- **goal tolerance**, **episode length**, etc.

API
~~~

.. code:: python

   uv.navigation.rl.NavTaskConfig(
       robot_type: str = "coco_wheeled",
       horizon_length: int = 32,
       num_envs: int = 32,
       goal_tolerance: float = 0.5,
       max_episode_seconds: float = 30.0,
   )

Example
~~~~~~~

.. code:: python

   import urbanverse as uv

   task_cfg = uv.navigation.rl.NavTaskConfig(
       robot_type="coco_wheeled",
       horizon_length=32,
       num_envs=32,
       goal_tolerance=0.5,
   )



PPO Training Configuration
--------------------------

UrbanVerse uses PPO with the hyperparameters from the UrbanVerse paper:

- learning rate: 1e-4  
- discount factor: 0.99  
- GAE: λ = 0.95  
- PPO clip: 0.2  
- horizon length: 32  
- minibatch size: 512  
- number of mini-epochs: 5  
- KL threshold: 0.01  
- entropy coefficient: 0.002  
- gradient norm clipping: 1.0  
- 1500 training epochs

API
~~~

.. code:: python

   uv.navigation.rl.NavTrainConfig(
       learning_rate: float = 1e-4,
       gamma: float = 0.99,
       gae_lambda: float = 0.95,
       ppo_clip: float = 0.2,
       kl_threshold: float = 0.01,
       entropy_coef: float = 0.002,
       critic_coef: float = 1.0,
       max_grad_norm: float = 1.0,
       horizon_length: int = 32,
       minibatch_size: int = 512,
       mini_epochs: int = 5,
       bounds_loss_coef: float = 0.01,
       training_epochs: int = 1500,
       scenes_per_batch: int = 16,
       scene_repeat_min: int = 4,
       scene_repeat_max: int = 6,
       scene_resample_interval_episodes: int = 100,
       device: str = "cuda",
       mixed_precision: bool = True,
   )

Example
~~~~~~~

.. code:: python

   import urbanverse as uv

   train_cfg = uv.navigation.rl.NavTrainConfig(
       learning_rate=1e-4,
       minibatch_size=512,
       training_epochs=1500,
   )



Reward Configuration
--------------------

The reward follows the definition in the UrbanVerse paper:

.. math::

   R = R_A + R_C + R_P + R_V

- **Arrival reward** :math:`R_A`  
  +2000 when the agent reaches the goal.

- **Collision penalty** :math:`R_C`  
  −200 on collision with obstacles.

- **Position tracking** :math:`R_P`  
  Gaussian shaping based on position error:
  
  - coarse: std = 5.0, weight = 10,
  - fine: std = 1.0, weight = 50.

- **Velocity reward** :math:`R_V`  
  weight = 10, based on cosine similarity between current and target
  velocity (from robot to goal).


API
~~~

.. code:: python

   uv.navigation.rl.NavRewardConfig(
       arrived_reward: float = 2000.0,
       collision_penalty: float = -200.0,
       pos_std_coarse: float = 5.0,
       pos_weight_coarse: float = 10.0,
       pos_std_fine: float = 1.0,
       pos_weight_fine: float = 50.0,
       vel_weight: float = 10.0,
   )

Example
~~~~~~~

.. code:: python

   import urbanverse as uv

   reward_cfg = uv.navigation.rl.NavRewardConfig(
       arrived_reward=2000,
       collision_penalty=-200,
   )



High-Level Training API
-----------------------

The main programmatic entrypoint for training is:

API
~~~

.. code:: python

   uv.navigation.rl.train_navigation_policy(
       robot_type: str,
       scene_paths: list[str] | None = None,
       use_urbanverse160: bool = False,
       num_scenes: int = 32,
       task_cfg: "NavTaskConfig" | None = None,
       train_cfg: "NavTrainConfig" | None = None,
       reward_cfg: "NavRewardConfig" | None = None,
       output_dir: str = "outputs/navigation",
   ) -> str

Behavior:

- If ``scene_paths`` is provided → use exactly these scenes (Option A).
- If ``scene_paths`` is ``None`` and ``use_urbanverse160=True`` →  
  load scenes from ``$URBANVERSE_SCENE_ROOT`` using ``num_scenes`` (Option B).



End-to-End Example (Python)
---------------------------

The example below uses 32 scenes from UrbanVerse-160 and trains a
COCO wheeled robot navigation policy:

.. code:: python

   import urbanverse as uv

   # 1. Load 32 scenes from URBANVERSE_SCENE_ROOT (Option B)
   scene_paths = uv.navigation.rl.load_urbanverse160_scenes(
       num_scenes=32,
       split="train",
   )

   # 2. Configure the navigation task
   task_cfg = uv.navigation.rl.NavTaskConfig(
       robot_type="coco_wheeled",
       horizon_length=32,
       num_envs=32,
       goal_tolerance=0.5,
   )

   # 3. PPO config
   train_cfg = uv.navigation.rl.NavTrainConfig(
       training_epochs=1500,
       minibatch_size=512,
   )

   # 4. Reward config
   reward_cfg = uv.navigation.rl.NavRewardConfig()

   # 5. Launch training
   ckpt_dir = uv.navigation.rl.train_navigation_policy(
       robot_type="coco_wheeled",
       scene_paths=scene_paths,      # explicit list (Option A-style)
       use_urbanverse160=False,      # scenes already passed explicitly
       num_scenes=32,
       task_cfg=task_cfg,
       train_cfg=train_cfg,
       reward_cfg=reward_cfg,
       output_dir="outputs/coco_nav",
   )

   print("Checkpoints and logs saved to:", ckpt_dir)



Gymnasium Environment Registration (Advanced)
---------------------------------------------

Internally, UrbanVerse registers a Gymnasium environment for navigation:

.. code:: python

   import gymnasium as gym

   env_id = f"URBANVERSE-navigation-{task_cfg.robot_type}"

   gym.register(
       id=env_id,
       entry_point="urbanverse.navigation.rl:UrbanVerseNavEnv",
       disable_env_checker=True,
       kwargs={
           "scene_paths": scene_paths,
           "task_cfg": task_cfg,
           "train_cfg": train_cfg,
           "reward_cfg": reward_cfg,
       },
   )

   env = gym.make(env_id)

Advanced users can replace the ``entry_point`` with their own environment
class, as long as it follows the same interface.


Configuration Classes (Conceptual Notes)
----------------------------------------

The configuration objects:

- :class:`uv.navigation.rl.NavTaskConfig`
- :class:`uv.navigation.rl.NavTrainConfig`
- :class:`uv.navigation.rl.NavRewardConfig`

provide structured, declarative access to all relevant parameters: scenes,
robot type, horizon length, PPO hyperparameters, and reward shaping.

They are intended to be lightweight config containers (e.g., implemented
as dataclasses or ``@configclass`` objects), making it straightforward to
modify and extend UrbanVerse’s navigation training pipeline.
