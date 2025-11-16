.. _urbanverse-robot-learning-rl-guide-observation:

What Your Policy Sees: Observations
====================================

The observation space defines the sensory information available to your navigation policy. UrbanVerse provides a flexible observation system that combines visual inputs from onboard cameras with spatial awareness through goal-relative position vectors, creating a rich representation of the robot's state and environment.

Observation Components
----------------------

For goal-directed navigation in urban environments, your policy typically needs two types of information:

**Visual Perception**  
Onboard cameras capture the robot's view of the world, providing information about obstacles, road structure, pedestrians, and other scene elements. This visual input is essential for understanding the immediate surroundings and making navigation decisions.

**Spatial Awareness**  
A goal vector encodes the relative position from the robot to its target destination. This compact representation (just two numbers: ``dx, dy``) tells the policy where the goal is relative to the robot's current position, enabling efficient path planning.

Configuring Observations
-------------------------

Observation configuration is simple and intuitive:

.. code-block:: python

   import urbanverse as uv
   from urbanverse.navigation.config import EnvCfg, ObservationCfg

   cfg = EnvCfg(
       robot_type="coco_wheeled",
       observations=ObservationCfg(
           rgb_size=(135, 240),        # Camera image resolution
           use_depth=False,             # RGB only (no depth channel)
           include_goal_vector=True,    # Add (dx, dy) goal position
       ),
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

Standard Observation Setup
---------------------------

The default observation configuration for navigation tasks includes:

**RGB Camera Image**  
A color image from the robot's forward-facing camera, resized to the specified resolution. This provides visual information about the scene ahead, including obstacles, road markings, buildings, and dynamic agents.

**Goal Vector**  
A 2D vector ``(dx, dy)`` representing the relative position from the robot to the goal, normalized and appended to the observation tensor. This gives the policy direct spatial information about where it needs to go.

Together, these components provide a compact yet informative representation: the camera image handles visual scene understanding, while the goal vector provides precise spatial guidance.

Example Observation Structure
------------------------------

When you query the environment, observations are returned as a dictionary:

.. code-block:: python

   obs = env.reset()
   
   # obs contains:
   # - "rgb": tensor of shape [num_envs, 135, 240, 3] - camera images
   # - "goal_vector": tensor of shape [num_envs, 2] - (dx, dy) to goal
   # - Additional robot state information (pose, velocity, etc.)

   # Your policy processes these observations:
   actions = policy(obs)

The observation processing pipeline automatically:
- Captures camera images from the simulation
- Computes goal-relative positions
- Normalizes and preprocesses the data
- Concatenates everything into a format your policy can consume

Customizing the Observation Space
-----------------------------------

You can tailor the observation space to your specific needs:

**Higher Resolution Images**  
Increase camera resolution for more detailed visual information (at the cost of larger input tensors):

.. code-block:: python

   ObservationCfg(
       rgb_size=(180, 320),  # Higher resolution
       ...
   )

**Enable Depth Information**  
Add a depth channel to provide 3D spatial awareness:

.. code-block:: python

   ObservationCfg(
       use_depth=True,  # Include depth channel
       ...
   )

**Additional Sensors**  
For advanced applications, you can extend observations to include:
- LiDAR point clouds for precise distance measurements
- Contact sensors for collision detection
- Height scanners for terrain awareness
- Multiple camera views for panoramic perception

**Custom Observation Processing**  
Subclass ``ObservationCfg`` to implement custom preprocessing, feature extraction, or sensor fusion logic.

Design Considerations
----------------------

The observation space is a critical design choice that affects both learning efficiency and policy performance:

- **Compact representations** (like the default RGB + goal vector) train faster and require less memory
- **Rich observations** (multiple sensors, high resolution) provide more information but increase computational cost
- **Task-specific sensors** can significantly improve performance for specialized navigation scenarios

The default configuration (RGB camera + goal vector) strikes an excellent balance for most navigation tasks, providing sufficient information for effective learning while remaining computationally efficient. Start with the defaults, then experiment with extensions based on your specific requirements.
