Designing the Reward Function
==============================

The reward function is the learning signal that guides your policy toward desired behaviors. UrbanVerse's reward system is modular and composable, allowing you to balance multiple objectives: reaching goals efficiently, avoiding collisions, maintaining smooth trajectories, and following optimal paths.

Reward Function Philosophy
---------------------------

Effective navigation policies need to balance competing objectives. You want the robot to:
- **Reach its destination** (task completion)
- **Avoid obstacles and collisions** (safety)
- **Take efficient paths** (navigation quality)
- **Move smoothly** (motion efficiency)

UrbanVerse's reward function combines multiple weighted terms, each addressing one of these objectives. By adjusting weights, you can emphasize different aspects of navigation behavior.

Configuring Rewards
--------------------

Reward configuration lets you tune the relative importance of different behaviors:

.. code-block:: python

   from urbanverse.navigation.config import EnvCfg, RewardCfg
   import urbanverse as uv

   cfg = EnvCfg(
       robot_type="coco_wheeled",
       rewards=RewardCfg(
           arrived_reward=2000.0,          # Big reward for success
           collision_penalty=-200.0,       # Penalty for unsafe behavior
           tracking_fine_std=1.0,          # Precision near goal (meters)
           tracking_fine_weight=50.0,      # How much precision matters
           tracking_coarse_std=5.0,        # General progress tolerance
           tracking_coarse_weight=10.0,    # General progress reward
           velocity_weight=10.0,           # Smooth motion reward
       ),
       ...
   )

Understanding Reward Terms
---------------------------

The reward function consists of five key components:

**1. Arrival Reward** (``arrived_reward=2000.0``)  
A large positive reward granted when the robot successfully reaches its goal. This is the primary success signal, encouraging the policy to complete navigation tasks. The magnitude should be large enough to outweigh accumulated step penalties and guide learning toward task completion.

**2. Collision Penalty** (``collision_penalty=-200.0``)  
A negative reward triggered when the robot collides with obstacles, walls, or pedestrians. This safety signal discourages dangerous behaviors and encourages collision-free navigation. The penalty should be significant enough to make collisions clearly undesirable, but not so large that it prevents exploration.

**3. Coarse Waypoint Tracking** (``tracking_coarse_weight=10.0, std=5.0``)  
A smooth reward that encourages general progress toward the goal. Uses a tanh-based function that provides positive feedback when the robot is moving in the right direction, with a tolerance of 5 meters. This gives the policy guidance during long-range navigation, helping it stay on track even when far from the goal.

**4. Fine Waypoint Tracking** (``tracking_fine_weight=50.0, std=1.0``)  
A more precise reward that becomes important when the robot is close to its destination. With a 1-meter tolerance, this term encourages accurate final approach and precise goal reaching. The higher weight (50.0 vs 10.0) emphasizes precision in the final stages of navigation.

**5. Velocity Alignment** (``velocity_weight=10.0``)  
A dense reward that encourages the robot to match its commanded target velocity. This promotes smooth, efficient motion and helps the policy learn to maintain appropriate speeds for different navigation scenarios.

Reward Computation
-------------------

At each timestep, all active reward terms are evaluated and combined:

.. code-block:: python

   total_reward = (
       # Sparse rewards (only when conditions are met)
       (2000.0 if goal_reached else 0.0) +
       (-200.0 if collision_occurred else 0.0) +
       
       # Dense rewards (computed every step)
       10.0 * coarse_tracking_reward(distance_to_goal, std=5.0) +
       50.0 * fine_tracking_reward(distance_to_goal, std=1.0) +
       10.0 * velocity_alignment_reward(current_velocity, target_velocity)
   )

The combination of sparse rewards (for major events) and dense rewards (for continuous guidance) provides both clear success/failure signals and smooth learning gradients throughout the episode.

Tuning Reward Weights
----------------------

Reward tuning is an iterative process. Here are some strategies:

**Emphasize Safety**  
Increase the collision penalty if your policy is too aggressive:

.. code-block:: python

   RewardCfg(
       collision_penalty=-500.0,  # Stronger safety signal
       ...
   )

**Prioritize Precision**  
Increase fine tracking weight if the robot struggles with accurate goal reaching:

.. code-block:: python

   RewardCfg(
       tracking_fine_weight=100.0,  # Emphasize precision
       tracking_fine_std=0.5,       # Tighter tolerance
       ...
   )

**Encourage Exploration**  
Reduce penalties and increase progress rewards if the policy is too conservative:

.. code-block:: python

   RewardCfg(
       collision_penalty=-100.0,      # Less discouraging
       tracking_coarse_weight=20.0,   # More encouragement
       ...
   )

**Disable Specific Terms**  
Set weights to zero to ablate reward components and understand their impact:

.. code-block:: python

   RewardCfg(
       velocity_weight=0.0,  # Disable velocity reward
       ...
   )

Best Practices
--------------

- **Start with defaults**: The default reward configuration works well for most navigation tasks
- **Monitor training metrics**: Watch success rate, collision rate, and path efficiency to guide tuning
- **Make incremental changes**: Adjust one weight at a time to understand its effect
- **Balance sparse and dense rewards**: Ensure sparse rewards (arrival, collision) are large enough to matter, but dense rewards provide sufficient guidance
- **Consider task-specific needs**: Urban navigation might need different weights than open-field navigation

The reward function is one of the most impactful hyperparameters in RL training. A well-tuned reward function can dramatically improve learning speed and final policy performance.
