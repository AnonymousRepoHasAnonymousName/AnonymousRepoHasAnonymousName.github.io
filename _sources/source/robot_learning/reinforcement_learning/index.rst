Reinforcement Learning
===================================

UrbanVerse provides a modular and extensible framework for reinforcement learning (RL) in complex urban environments.  
It is built on top of Isaac Lab's `ManagerBasedRLEnv` architecture and supports multi-environment parallel simulation, curriculum learning, and rich observations/actions.

This section introduces the major configurable components of the RL environment pipeline.

.. toctree::
   :maxdepth: 1
   :caption: RL Environment Components
   
   scene
   action
   observation
   reward
   reset
   curriculum
   event

Component Overview
-------------------

- **Scene Binding**  
  RL environments are bound to a ``SceneCfg`` that defines the world layout, agent configuration, and asset loading.  
  See: :doc:`scene`

- **Actions**  
  UrbanVerse supports multiple action interfaces, including velocity commands for wheeled and legged robots.  
  See: :doc:`action`

- **Observations**  
  Rich multimodal observations are available (e.g., RGB, depth, lidar, robot state).  
  See: :doc:`observation`

- **Rewards**  
  Task-specific rewards are defined via modular reward terms for navigation, collision avoidance, etc.  
  See: :doc:`reward`

- **Reset Conditions**  
  Environments reset based on terminal conditions like collisions, goal reached, or episode timeout.  
  See: :doc:`reset`

- **Curriculum**  
  Training difficulty can be gradually increased using a curriculum manager.  
  See: :doc:`curriculum`

- **Events**  
  Optional simulation events (e.g., trigger zone entered, pedestrian spawn) that can influence rewards or resets.  
  See: :doc:`event`

Usage Tip
----------

Each component can be configured independently via the central ``EnvCfg`` class.  
You can also subclass individual configs to customize robot interfaces, rewards, observations, or scene logic.
