.. _urbanverse-robot-learning-rl-guide-action:

Defining Robot Actions
=======================

The action space defines how your RL policy controls the robot. UrbanVerse automatically adapts the action interface based on your chosen robot embodiment, from simple velocity commands for wheeled delivery robots to sophisticated joint-level controls for humanoid platforms.

How Actions Work
-----------------

At each simulation step, your policy outputs a vector of action values. UrbanVerse processes these values, applies appropriate scaling and limits, and converts them into physical robot commands. The exact mapping depends on your robot type, but the interface remains consistent: your policy outputs actions, and UrbanVerse handles the rest.

For wheeled robots like COCO, actions are straightforward velocity commands:

.. code-block:: python

   from urbanverse.navigation.config import EnvCfg, ActionCfg
   import urbanverse as uv

   cfg = EnvCfg(
       robot_type="coco_wheeled",
       actions=ActionCfg(
           action_dim=2,          # [linear_velocity, angular_velocity]
           linear_limit=1.0,      # Max forward speed: 1.0 m/s
           angular_limit=1.0,     # Max rotation rate: 1.0 rad/s
       ),
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

   # During training, your policy outputs actions like:
   actions = policy(observations)  # Shape: [num_envs, 2]
   # actions[:, 0] = linear velocity commands
   # actions[:, 1] = angular velocity commands

Robot-Specific Action Spaces
-----------------------------

UrbanVerse supports a wide variety of robot embodiments, each with its own natural action space. The action configuration is automatically selected based on your ``robot_type``, so you typically don't need to specify it manually.

**Wheeled Robots**  
Simple and intuitive: control forward speed and turning rate.

- **COCO Wheeled** (``coco_wheeled``): 2D velocity commands ``[v_forward, ω_yaw]``
- **NVIDIA Carter** (``nvidia_carter``): 3D velocity commands ``[vx, vy, ω_yaw]`` for omnidirectional movement
- **TurtleBot3** (``turtlebot3``): Differential drive velocity commands

**Legged Robots**  
More complex control requiring joint-level or high-level locomotion commands.

- **Unitree Go2** (``unitree_go2``): Joint velocity commands or high-level velocity for quadruped locomotion
- **ANYmal** (``anymal``): Joint-based controls for robust quadruped navigation

**Humanoid Robots**  
Sophisticated bipedal locomotion with full-body control.

- **Unitree G1** (``unitree_g1``): Joint-angle or torque-based controls for humanoid walking
- **Booster T1** (``booster_t1``): Advanced joint-level controls for humanoid navigation

For detailed specifications of each robot's action space, see :doc:`../robot_configuration`.

Action Processing Pipeline
---------------------------

UrbanVerse handles action processing automatically:

1. **Policy Output**: Your neural network outputs raw action values (typically in ``[-1, 1]`` range)

2. **Scaling**: Actions are scaled by the configured limits (e.g., ``linear_limit``, ``angular_limit``)

3. **Application**: Scaled actions are converted to robot-specific commands and applied to the simulation

4. **Execution**: The physics engine executes the commands, updating robot state

This pipeline ensures that actions are properly bounded, scaled, and applied regardless of your robot type.

Example: Training with COCO Actions
------------------------------------

Here's a complete example showing how actions flow through the system:

.. code-block:: python

   import urbanverse as uv
   from urbanverse.navigation.config import EnvCfg, SceneCfg, ActionCfg

   cfg = EnvCfg(
       scenes=SceneCfg(scene_paths=my_scenes, async_sim=True),
       robot_type="coco_wheeled",
       actions=ActionCfg(
           action_dim=2,
           linear_limit=1.5,   # Allow faster forward movement
           angular_limit=0.8,  # Slightly slower rotation
       ),
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

   # Training loop (simplified)
   obs = env.reset()
   for step in range(num_steps):
       # Policy outputs actions in [-1, 1] range
       actions = policy(obs)  # Shape: [num_envs, 2]
       
       # UrbanVerse automatically:
       # 1. Scales actions by limits: [linear_limit, angular_limit]
       # 2. Converts to robot commands
       # 3. Applies to simulation
       obs, rewards, dones, info = env.step(actions)

Customizing Action Spaces
--------------------------

While UrbanVerse provides sensible defaults for each robot type, you can customize the action space:

**Adjust Action Limits**  
Modify the maximum velocities or joint ranges:

.. code-block:: python

   ActionCfg(
       linear_limit=2.0,   # Faster maximum speed
       angular_limit=1.5,  # More aggressive turning
   )

**Change Action Dimensions**  
For advanced use cases, you can extend the action space to include additional control dimensions (e.g., gripper commands, head movement).

**Custom Action Processing**  
Subclass the action configuration class to implement custom action transformations, constraints, or safety limits.

The action space is one of the most fundamental aspects of your RL setup—it defines what your policy can do. Choose appropriate limits that match your robot's physical capabilities and your navigation task requirements.
