.. _urbanverse-developer-adding-robots:

Adding New Robots to UrbanVerse
================================

UrbanVerse supports adding custom robot embodiments to the simulation environment. This guide explains how to integrate new robots into UrbanVerse using URDF or USD robot model files, following Isaac Sim and Isaac Lab's robot integration patterns.

Overview
---------

Adding a new robot to UrbanVerse involves:

1. **Robot Model Preparation**: Ensure your robot model (URDF or USD) is properly formatted
2. **Robot Configuration**: Create a robot configuration class that defines the robot's properties
3. **Action Interface**: Define the action space and control interface
4. **Observation Setup**: Configure sensors and observation terms
5. **Integration**: Register the robot with UrbanVerse's robot registry

This process follows Isaac Lab's robot integration architecture, ensuring compatibility with UrbanVerse's navigation and learning frameworks.

Prerequisites
-------------

Before adding a new robot, ensure you have:

- Robot model file (URDF or USD format)
- Robot specifications (joint names, link hierarchy, sensor locations)
- Understanding of the robot's control interface (joint-based, velocity-based, etc.)
- Access to UrbanVerse source code for robot registration

Robot Model Requirements
-------------------------

**URDF Format:**
- Valid URDF file with complete robot description
- Proper joint definitions (revolute, prismatic, fixed, etc.)
- Link hierarchy and collision geometries
- Inertial properties for physics simulation

**USD Format:**
- USD file compatible with Isaac Sim
- Properly defined primitives and transforms
- Physics properties (mass, inertia, collision meshes)
- Joint definitions if using articulated robots

Basic Usage
-----------

The following example demonstrates how to add a new wheeled robot:

.. code-block:: python

   import urbanverse as uv
   from urbanverse.robots.base import RobotCfg, VelocityActionCfg
   from urbanverse.navigation.config import EnvCfg

   # Define robot configuration
   class CustomRobotCfg(RobotCfg):
       """Configuration for custom wheeled robot."""
       
       # Robot model path
       usd_path = "/path/to/your/robot.usd"
       
       # Robot properties
       spawn = {
           "pos": (0.0, 0.0, 0.1),
           "rot": (1.0, 0.0, 0.0, 0.0),
       }
       
       # Action configuration
       actions = VelocityActionCfg(
           action_dim=2,  # [linear_velocity, angular_velocity]
           linear_limit=1.5,
           angular_limit=1.0,
       )
       
       # Observation configuration
       observations = {
           "rgb": {"enabled": True, "resolution": (135, 240)},
           "goal_vector": {"enabled": True},
       }

   # Register robot
   uv.robots.register_robot(
       robot_type="custom_robot",
       robot_cfg=CustomRobotCfg,
   )

   # Use in environment
   cfg = EnvCfg(
       robot_type="custom_robot",
       scenes=SceneCfg(scene_paths=my_scenes),
       ...
   )

Robot Configuration Class
--------------------------

Create a robot configuration class that inherits from ``RobotCfg``:

.. code-block:: python

   from urbanverse.robots.base import RobotCfg
   from urbanverse.navigation.config import ActionCfg, ObservationCfg

   @configclass
   class MyRobotCfg(RobotCfg):
       """Configuration for custom robot."""
       
       # Required: Robot model path
       usd_path: str = "/path/to/robot.usd"
       
       # Optional: URDF path (if using URDF instead of USD)
       urdf_path: str | None = None
       
       # Robot spawn configuration
       spawn: dict = {
           "pos": (0.0, 0.0, 0.1),  # Initial position (x, y, z)
           "rot": (1.0, 0.0, 0.0, 0.0),  # Initial rotation (quaternion)
       }
       
       # Action space configuration
       actions: ActionCfg = VelocityActionCfg(
           action_dim=2,
           linear_limit=1.0,
           angular_limit=1.0,
       )
       
       # Observation configuration
       observations: ObservationCfg = ObservationCfg(
           rgb_size=(135, 240),
           include_goal_vector=True,
       )
       
       # Sensor configuration
       sensors: dict = {
           "camera": {
               "enabled": True,
               "position": (0.0, 0.0, 0.2),
               "orientation": (0.0, 0.0, 0.0),
           }
       }

Action Interface Configuration
-------------------------------

Define the robot's action space based on its control interface:

**Velocity-Based Control (Wheeled Robots):**

.. code-block:: python

   from urbanverse.robots.base import VelocityActionCfg

   actions = VelocityActionCfg(
       action_dim=2,  # [linear_velocity, angular_velocity]
       linear_limit=1.5,  # Maximum linear velocity (m/s)
       angular_limit=1.0,  # Maximum angular velocity (rad/s)
   )

**Joint-Based Control (Articulated Robots):**

.. code-block:: python

   from urbanverse.robots.base import JointActionCfg

   actions = JointActionCfg(
       action_dim=12,  # Number of controllable joints
       joint_names=[
           "front_left_hip",
           "front_left_thigh",
           "front_left_calf",
           # ... more joints
       ],
       joint_limits={
           "position": (-3.14, 3.14),  # Joint position limits
           "velocity": (-10.0, 10.0),  # Joint velocity limits
       },
   )

**Torque-Based Control (Advanced):**

.. code-block:: python

   from urbanverse.robots.base import TorqueActionCfg

   actions = TorqueActionCfg(
       action_dim=12,
       torque_limits=(-50.0, 50.0),  # Torque limits (Nm)
   )

Sensor Configuration
---------------------

Configure sensors for observations:

.. code-block:: python

   sensors = {
       "camera": {
           "enabled": True,
           "position": (0.0, 0.0, 0.2),  # Camera position relative to robot base
           "orientation": (0.0, 0.0, 0.0),  # Camera orientation (roll, pitch, yaw)
           "resolution": (135, 240),
           "fov": 60.0,
       },
       "lidar": {
           "enabled": False,  # Optional: Enable LiDAR
           "position": (0.0, 0.0, 0.3),
           "num_points": 1080,
           "range": 20.0,
       },
   }

Robot Registration
-------------------

Register your robot with UrbanVerse:

.. code-block:: python

   import urbanverse as uv

   # Register robot type
   uv.robots.register_robot(
       robot_type="my_custom_robot",
       robot_cfg=MyRobotCfg,
       modify_env_fn=my_modify_env_function,  # Optional: Custom environment modification
   )

The ``modify_env_fn`` allows you to customize how the robot is added to the environment (e.g., adding custom sensors, setting up physics properties).

Environment Modification Function
-----------------------------------

Optionally, provide a custom function to modify the environment when the robot is added:

.. code-block:: python

   def my_modify_env_function(env, robot_prim_path: str):
       """Custom environment modification for robot."""
       
       # Access robot prim
       robot_prim = env.scene[robot_prim_path]
       
       # Add custom sensors
       # Configure physics properties
       # Set up additional components
       
       pass

   uv.robots.register_robot(
       robot_type="my_custom_robot",
       robot_cfg=MyRobotCfg,
       modify_env_fn=my_modify_env_function,
   )

Complete Example: Adding a Custom Wheeled Robot
------------------------------------------------

.. code-block:: python

   import urbanverse as uv
   from urbanverse.robots.base import RobotCfg, VelocityActionCfg
   from urbanverse.navigation.config import EnvCfg, SceneCfg, ObservationCfg

   # Define robot configuration
   @configclass
   class CustomWheeledRobotCfg(RobotCfg):
       usd_path = "/path/to/custom_robot.usd"
       
       spawn = {
           "pos": (0.0, 0.0, 0.1),
           "rot": (1.0, 0.0, 0.0, 0.0),
       }
       
       actions = VelocityActionCfg(
           action_dim=2,
           linear_limit=2.0,
           angular_limit=1.5,
       )
       
       observations = ObservationCfg(
           rgb_size=(135, 240),
           include_goal_vector=True,
       )

   # Register robot
   uv.robots.register_robot(
       robot_type="custom_wheeled",
       robot_cfg=CustomWheeledRobotCfg,
   )

   # Use in environment
   cfg = EnvCfg(
       robot_type="custom_wheeled",
       scenes=SceneCfg(
           scene_paths=["/path/to/scene.usd"],
           async_sim=True,
       ),
       observations=ObservationCfg(rgb_size=(135, 240), include_goal_vector=True),
       actions=VelocityActionCfg(),
   )

   env = uv.navigation.rl.create_env(cfg)

Testing Your Robot
-------------------

After adding your robot, test it in a simple environment:

.. code-block:: python

   import urbanverse as uv
   from urbanverse.navigation.config import EnvCfg, SceneCfg

   # Create test environment
   cfg = EnvCfg(
       robot_type="my_custom_robot",
       scenes=SceneCfg(
           scene_paths=["/path/to/test_scene.usd"],
           async_sim=False,
       ),
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

   # Test basic functionality
   obs = env.reset()
   print(f"Observation shape: {obs.shape}")
   
   # Test action application
   actions = env.action_space.sample()
   obs, reward, done, info = env.step(actions)
   print(f"Action applied successfully: {not done}")

Best Practices
--------------

- **Model Validation**: Verify your robot model loads correctly in Isaac Sim before integration
- **Physics Properties**: Ensure inertial properties are correctly defined for stable simulation
- **Action Limits**: Set realistic action limits based on your robot's physical capabilities
- **Sensor Placement**: Position sensors appropriately for your robot's geometry
- **Testing**: Thoroughly test the robot in various UrbanVerse scenes before production use

Following Isaac Lab's robot integration patterns ensures your custom robot works seamlessly with UrbanVerse's navigation and learning frameworks.
