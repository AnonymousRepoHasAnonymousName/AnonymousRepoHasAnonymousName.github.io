.. _urbanverse-robot-learning-rl-guide-root:

Reinforcement Learning Guide
=====================================

UrbanVerse offers a comprehensive reinforcement learning framework designed specifically for training navigation policies in photorealistic urban environments. Built on Isaac Lab's robust simulation infrastructure, UrbanVerse enables efficient parallel training across diverse real-to-sim city scenes, supporting everything from simple point navigation to complex multi-agent interactions.

This section walks through the essential building blocks for configuring and training RL agents in UrbanVerse's rich urban simulation environments.

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

The RL Environment Architecture
--------------------------------

Training a navigation policy in UrbanVerse involves configuring seven key components that work together to define the learning task:

**🌍 Scene Configuration**  
Choose from UrbanVerse-160's diverse city layouts, CraftBench's artist-crafted test scenes, or your own custom environments generated with UrbanVerse-Gen. Configure how scenes are distributed across parallel training environments.  
→ :doc:`scene`

**🎮 Action Space**  
Define how your robot moves. UrbanVerse automatically adapts the action interface based on your robot type—from simple velocity commands for wheeled robots to complex joint controls for humanoids.  
→ :doc:`action`

**👁️ Observations**  
Specify what your policy sees. Combine visual inputs from onboard cameras with goal-relative position vectors and proprioceptive state information.  
→ :doc:`observation`

**🎯 Rewards**  
Design the learning signal. Balance task completion rewards, safety penalties, and navigation quality metrics to guide your policy toward desired behaviors.  
→ :doc:`reward`

**🏁 Episode Termination**  
Control when episodes end. Define success conditions, failure modes, and time limits that shape the learning dynamics.  
→ :doc:`reset`

**📈 Curriculum Learning**  
Gradually increase task difficulty. Start with nearby goals and simple scenes, then progressively expand to long-range navigation across diverse urban layouts.  
→ :doc:`curriculum`

**⚡ Events**  
Inject variability and randomization. Customize robot initialization, dynamic agent spawning, and environmental variations to improve policy robustness.  
→ :doc:`event`

Getting Started: Your First RL Environment
-------------------------------------------

Here's a minimal example that creates a complete RL environment for training a COCO wheeled robot:

.. code-block:: python

   from urbanverse.navigation.config import (
       EnvCfg, SceneCfg, ObservationCfg, ActionCfg,
       RewardCfg, TerminationCfg, CurriculumCfg
   )
   import urbanverse as uv

   # Define your training configuration
   cfg = EnvCfg(
       scenes=SceneCfg(
           scene_paths=["/path/to/UrbanVerse-160/Tokyo_0001/scene.usd", ...],
           async_sim=True,
       ),
       robot_type="coco_wheeled",
       observations=ObservationCfg(rgb_size=(135, 240), include_goal_vector=True),
       actions=ActionCfg(),
       rewards=RewardCfg(),
       terminations=TerminationCfg(max_episode_steps=300),
       curriculum=CurriculumCfg(enable_goal_distance_curriculum=True),
   )

   # Create and train
   env = uv.navigation.rl.create_env(cfg)
   uv.navigation.rl.train(
       env=env,
       training_cfg=training_cfg,
       output_dir="outputs/my_navigation_policy"
   )

Each component can be customized independently, allowing you to experiment with different configurations, robot types, and training strategies. The following pages dive deep into each component, providing detailed explanations, examples, and best practices for training effective navigation policies in UrbanVerse.
