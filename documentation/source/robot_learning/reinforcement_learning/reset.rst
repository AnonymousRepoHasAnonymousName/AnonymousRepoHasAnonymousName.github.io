When Episodes End: Termination Conditions
==========================================

Episode termination defines when a navigation attempt concludes. UrbanVerse provides clear, configurable termination conditions that determine whether an episode ends in success, failure, or timeout, shaping both the learning dynamics and the behaviors your policy will learn.

Termination Strategy
--------------------

Well-designed termination conditions are crucial for effective learning. They need to:
- **Clearly distinguish success from failure** so the policy receives unambiguous feedback
- **Prevent episodes from running indefinitely** to maintain training efficiency
- **Encourage desired behaviors** by ending episodes at appropriate moments
- **Provide diverse learning experiences** through varied episode lengths and outcomes

Configuring Terminations
-------------------------

Termination configuration is straightforward and intuitive:

.. code-block:: python

   from urbanverse.navigation.config import EnvCfg, TerminationCfg
   import urbanverse as uv

   cfg = EnvCfg(
       robot_type="coco_wheeled",
       terminations=TerminationCfg(
           max_episode_steps=300,      # Maximum steps before timeout
           enable_collision=True,      # End on collision
           enable_success=True,        # End on goal reached
           enable_timeout=True,        # End on step limit
       ),
       ...
   )

The Four Termination Modes
---------------------------

UrbanVerse supports four distinct termination conditions, each serving a specific purpose:

**1. Success: Goal Reached** (``enable_success=True``)  
The episode ends successfully when the robot reaches its destination within a configurable distance threshold (typically ~1 meter). This is the desired outcome—the policy receives the arrival reward, and the episode is marked as successful in training logs.

**2. Failure: Collision** (``enable_collision=True``)  
The episode ends immediately if the robot collides with obstacles, walls, pedestrians, or other scene elements. This safety termination triggers the collision penalty and marks the episode as failed, providing clear negative feedback for unsafe behaviors.

**3. Timeout: Step Limit** (``enable_timeout=True``)  
The episode ends after a maximum number of steps (``max_episode_steps``) if neither success nor failure has occurred. This prevents episodes from running indefinitely and ensures training progresses efficiently. Timeout episodes are typically marked as incomplete rather than failed.

**4. Failure: Out-of-Bounds** (optional)  
Can be enabled to terminate when the robot leaves designated traversable regions (e.g., goes off-road, leaves the sidewalk, or enters restricted areas). This enforces navigation constraints and encourages the policy to stay within valid navigation zones.

Termination Behavior
---------------------

When any termination condition is met, the episode immediately ends:

- **Success termination** → Triggers arrival reward → Episode marked successful → Environment resets
- **Collision termination** → Triggers collision penalty → Episode marked failed → Environment resets  
- **Timeout termination** → No special reward → Episode marked incomplete → Environment resets
- **Out-of-bounds termination** → Typically triggers penalty → Episode marked failed → Environment resets

The environment automatically resets after termination, sampling a new goal position, resetting the robot state, and preparing for the next episode.

Tuning Termination Parameters
------------------------------

**Episode Length**  
Adjust ``max_episode_steps`` based on your navigation task:

.. code-block:: python

   TerminationCfg(
       max_episode_steps=500,  # Longer episodes for distant goals
       ...
   )

Shorter episodes (200-300 steps) work well for nearby navigation tasks and faster training. Longer episodes (500+ steps) are needed for long-range navigation across large urban scenes.

**Goal Distance Threshold**  
The success threshold determines how close the robot must get to the goal. A tighter threshold (e.g., 0.5 meters) requires more precise navigation, while a looser threshold (e.g., 2.0 meters) is more forgiving. This is typically configured in the goal sampling or arrival detection logic.

**Selective Termination**  
You can disable specific termination modes for specialized training scenarios:

.. code-block:: python

   TerminationCfg(
       enable_collision=False,  # Don't end on collision (for collision recovery training)
       enable_timeout=False,    # Allow unlimited episode length (for specific experiments)
       ...
   )

Impact on Learning
-------------------

Termination conditions significantly influence what your policy learns:

- **Strict collision termination** encourages careful, collision-averse navigation
- **Generous success thresholds** make the task easier to learn initially
- **Appropriate episode lengths** ensure the policy sees both short and long navigation scenarios
- **Clear success/failure distinction** provides unambiguous learning signals

The default configuration (success, collision, and timeout enabled with 300-step limit) works well for most navigation tasks. Adjust based on your specific requirements, scene complexity, and desired policy behaviors.
