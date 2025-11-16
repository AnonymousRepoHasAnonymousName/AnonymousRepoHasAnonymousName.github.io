.. _urbanverse-robot-learning-robot-configuration:

Robot Configuration
====================

UrbanVerse provides a unified interface for working with multiple robot embodiments.  
Robots differ in mobility type (wheeled, holonomic, quadruped, humanoid), action interface,
and physical configuration. The robot is selected via:

.. code-block:: python

   cfg = EnvCfg(robot_type="coco_wheeled")

UrbanVerse automatically loads the correct configuration, action space, and environment
modifier based on the provided name.


Supported Robots
----------------

Wheeled Robots
~~~~~~~~~~~~~~

**COCO Wheeled Delivery Robot:**

- **Identifier**: ``coco_wheeled``
- **Config module**: ``urbanverse.robots.coco.COCOCfg``
- **Action space**: ``COCOVelocityActionCfg``  
  (continuous linear & angular velocities)
- **Environment modifier**: ``COCONavModifyEnv``
- **Default spawn height**: ``z ≈ 0.40``



**NVIDIA Carter (Holonomic Omnidirectional):**

- **Identifier**: ``nvidia_carter``
- **Config module**: ``urbanverse.robots.carter.CarterCfg``
- **Action space**: ``CarterVelocityActionCfg``  
  (vx, vy, yaw-rate)
- **Environment modifier**: ``CarterNavModifyEnv``
- **Default spawn height**: ``z ≈ 0.45``



**TurtleBot3:**

- **Identifier**: ``turtlebot3``
- **Config module**: ``urbanverse.robots.turtlebot3.TurtlebotCfg``
- **Action space**: ``TurtlebotActionCfg``
- **Environment modifier**: ``TurtlebotModifyEnv``
- **Default spawn height**: ``z ≈ 0.18``


Quadruped Robots
~~~~~~~~~~~~~~~~

**Unitree Go2:**

- **Identifier**: ``unitree_go2``
- **Config module**: ``urbanverse.robots.unitree_go2.Go2Cfg``
- **Action space**: ``Go2NavActionCfg``  
  (joint or velocity-based)
- **Environment modifier**: ``Go2NavModifyEnv``
- **Default spawn height**: ``z ≈ 0.30``



**ANYmal (C / D):**

- **Identifier**: ``anymal``
- **Config module**: ``urbanverse.robots.anymal.ANYmalCfg``
- **Action space**: ``ANYmalActionCfg``
- **Environment modifier**: ``ANYmalNavModifyEnv``
- **Default spawn height**: ``z ≈ 0.32``



Humanoid Robots
~~~~~~~~~~~~~~~~

**Booster Robotics T1 (Humanoid):** 

- **Identifier**: ``booster_t1``
- **Config module**: ``urbanverse.robots.booster_t1.T1Cfg``
- **Action space**: ``T1HumanoidActionCfg``  
  (joint-angle or torque-based, depending on mode)
- **Environment modifier**: ``T1NavModifyEnv``
- **Default spawn height**: ``z ≈ 1.0``


**Unitree G1 (Humanoid):**

- **Identifier**: ``unitree_g1``
- **Config module**: ``urbanverse.robots.unitree_g1.G1Cfg``
- **Action space**: ``G1NavActionCfg``
- **Environment modifier**: ``G1NavModifyEnv``
- **Default spawn height**: ``z ≈ 0.74``


Dynamic Robot Loading Logic
----------------------------

UrbanVerse loads robot components automatically:

.. code-block:: python

   robot_type = cfg.robot_type.lower()

   if robot_type == "coco_wheeled":
       from urbanverse.robots.coco import COCOCfg, COCOVelocityActionCfg, COCONavModifyEnv
       robot_cfg = COCOCfg
       action_cfg = COCOVelocityActionCfg
       modify_env_fn = COCONavModifyEnv

   elif robot_type == "nvidia_carter":
       from urbanverse.robots.carter import CarterCfg, CarterVelocityActionCfg, CarterNavModifyEnv
       robot_cfg = CarterCfg
       action_cfg = CarterVelocityActionCfg
       modify_env_fn = CarterNavModifyEnv

   elif robot_type == "turtlebot3":
       from urbanverse.robots.turtlebot3 import TurtlebotCfg, TurtlebotActionCfg, TurtlebotModifyEnv
       robot_cfg = TurtlebotCfg
       action_cfg = TurtlebotActionCfg
       modify_env_fn = TurtlebotModifyEnv

   elif robot_type == "unitree_go2":
       from urbanverse.robots.unitree_go2 import Go2Cfg, Go2NavActionCfg, Go2NavModifyEnv
       robot_cfg = Go2Cfg
       action_cfg = Go2NavActionCfg
       modify_env_fn = Go2NavModifyEnv

   elif robot_type == "anymal":
       from urbanverse.robots.anymal import ANYmalCfg, ANYmalActionCfg, ANYmalNavModifyEnv
       robot_cfg = ANYmalCfg
       action_cfg = ANYmalActionCfg
       modify_env_fn = ANYmalNavModifyEnv

   elif robot_type == "booster_t1":
       from urbanverse.robots.booster_t1 import T1Cfg, T1HumanoidActionCfg, T1NavModifyEnv
       robot_cfg = T1Cfg
       action_cfg = T1HumanoidActionCfg
       modify_env_fn = T1NavModifyEnv

   elif robot_type == "unitree_g1":
       from urbanverse.robots.unitree_g1 import G1Cfg, G1NavActionCfg, G1NavModifyEnv
       robot_cfg = G1Cfg
       action_cfg = G1NavActionCfg
       modify_env_fn = G1NavModifyEnv


Robot Spawn Initialization
---------------------------

UrbanVerse ensures each robot spawns safely on the navigable ground plane extracted from the scene.

.. code-block:: python

   xy, yaw = sample_valid_robot_pose(scene)
   robot_cfg.init_state.pos = [xy.x, xy.y, default_height]
   robot_cfg.init_state.yaw = yaw

Guarantees:

- safe sidewalk/road placement  
- no collision at spawn  
- consistent behavior across UrbanVerse-160 / CraftBench / user-generated scenes  


Summary
-------

- UrbanVerse now supports **wheeled**, **holonomic**, **quadruped**, **humanoid** robots.
- Robot selection uses a single field: ``robot_type="unitree_g1"``.
- System automatically loads config, action space, and env modifiers.
- Fully compatible with **UrbanVerse-160**, **CraftBench**, and **UrbanVerse-Gen** scenes.

