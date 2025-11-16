.. _urbanverse-api-navigation-rl:

Navigation Reinforcement Learning API
======================================

The Reinforcement Learning API provides functions for creating RL environments and training navigation policies in UrbanVerse.

Import
------

.. code-block:: python

   import urbanverse as uv
   from urbanverse.navigation.config import (
       EnvCfg, SceneCfg, ObservationCfg, ActionCfg,
       RewardCfg, TerminationCfg, CurriculumCfg, EventCfg
   )

Create Environment
------------------

.. code-block:: python

   uv.navigation.rl.create_env(
       cfg: EnvCfg,
   ) -> ManagerBasedRLEnv

Create a reinforcement learning environment from an ``EnvCfg`` configuration.

**Parameters:**

- **cfg** (EnvCfg): Environment configuration object (see :doc:`configuration` for details)

**Returns:**

- **ManagerBasedRLEnv**: Isaac Lab RL environment instance

**Example:**

.. code-block:: python

   from urbanverse.navigation.config import EnvCfg, SceneCfg, ObservationCfg, ActionCfg

   cfg = EnvCfg(
       scenes=SceneCfg(
           scene_paths=["/path/to/scene.usd"],
           async_sim=True,
       ),
       robot_type="coco_wheeled",
       observations=ObservationCfg(rgb_size=(135, 240)),
       actions=ActionCfg(),
   )

   env = uv.navigation.rl.create_env(cfg)

Train Policy
------------

.. code-block:: python

   uv.navigation.rl.train(
       env: ManagerBasedRLEnv,
       training_cfg: dict,
       output_dir: str,
   ) -> str

Train a reinforcement learning policy using the provided environment.

**Parameters:**

- **env** (ManagerBasedRLEnv): RL environment instance (from ``create_env``)
- **training_cfg** (dict): Training configuration dictionary. Common keys include:
  - ``algorithm``: RL algorithm (e.g., ``"PPO"``, ``"SAC"``)
  - ``num_envs``: Number of parallel environments
  - ``max_iterations``: Maximum training iterations
  - ``checkpoint_interval``: Iterations between checkpoints
  - ``log_interval``: Iterations between logging
  - Algorithm-specific hyperparameters (learning rate, batch size, etc.)
- **output_dir** (str): Directory where training outputs will be saved

**Returns:**

- **str**: Path to the best model checkpoint

**Example:**

.. code-block:: python

   training_cfg = {
       "algorithm": "PPO",
       "num_envs": 32,
       "max_iterations": 100000,
       "learning_rate": 3e-4,
       "batch_size": 4096,
       "checkpoint_interval": 5000,
   }

   checkpoint_path = uv.navigation.rl.train(
       env=env,
       training_cfg=training_cfg,
       output_dir="outputs/ppo_training",
   )

Load Policy
-----------

.. code-block:: python

   uv.navigation.rl.load_policy(
       checkpoint_path: str,
       robot_type: str,
       device: str = "cuda",
   ) -> Callable

Load a trained RL policy from a checkpoint file.

**Parameters:**

- **checkpoint_path** (str): Path to model checkpoint file
- **robot_type** (str): Robot embodiment identifier (must match training robot type)
- **device** (str, optional): Device to run inference on. Default: ``"cuda"``. Options: ``"cuda"``, ``"cpu"``

**Returns:**

- **Callable**: Policy function that takes observations and returns actions

**Example:**

.. code-block:: python

   policy = uv.navigation.rl.load_policy(
       checkpoint_path="outputs/ppo_training/checkpoints/best.pt",
       robot_type="coco_wheeled",
   )

   # Use policy for inference
   obs = env.reset()
   action = policy(obs)
   obs, reward, done, info = env.step(action)

Evaluate Policy
---------------

.. code-block:: python

   uv.navigation.rl.evaluate(
       policy: Callable,
       scene_paths: list[str],
       robot_type: str,
       num_episodes: int = 50,
       max_episode_steps: int = 300,
   ) -> dict

Evaluate a trained RL policy on UrbanVerse scenes.

**Parameters:**

- **policy** (Callable): RL policy function (from ``load_policy``)
- **scene_paths** (list[str]): List of USD scene file paths for evaluation
- **robot_type** (str): Robot embodiment identifier
- **num_episodes** (int, optional): Number of evaluation episodes. Default: ``50``
- **max_episode_steps** (int, optional): Maximum steps per episode. Default: ``300``

**Returns:**

- **dict**: Dictionary containing evaluation metrics:
  - ``"SR"`` (float): Success Rate
  - ``"RC"`` (float): Route Completion
  - ``"CT"`` (float): Collision Times
  - ``"DTG"`` (float): Distance-to-Goal
  - ``"episode_lengths"`` (list): Episode lengths
  - ``"outcomes"`` (list): Episode outcomes

**Example:**

.. code-block:: python

   results = uv.navigation.rl.evaluate(
       policy=policy,
       scene_paths=["/path/to/scene_001.usd", "/path/to/scene_002.usd"],
       robot_type="coco_wheeled",
       num_episodes=100,
   )

   print(f"Success Rate: {results['SR']:.2%}")
   print(f"Route Completion: {results['RC']:.2%}")

