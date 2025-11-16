Environment Events and Initialization
======================================

Events are mechanisms for modifying the simulation state during training, enabling domain randomization, state initialization, and dynamic environment changes. The most important event in UrbanVerse is automatic robot spawn initialization, which ensures your robot starts each episode in a valid, safe position within the urban scene.

Automatic Robot Spawn Initialization
-------------------------------------

UrbanVerse automatically handles robot initialization at the start of each episode, eliminating the need to manually configure spawn points. The system intelligently samples valid starting positions from the scene's navigable regions.

How It Works
------------

When an episode begins, UrbanVerse:

1. **Analyzes the scene** to identify drivable regions (roads, sidewalks, and other traversable surfaces)

2. **Samples a valid spawn point** from these regions, ensuring:
   - The position is on a navigable surface (not inside buildings or obstacles)
   - There are no collisions at the spawn location
   - The position is reachable and suitable for navigation

3. **Sets robot position and orientation**:
   - Places the robot at the sampled spawn point
   - Orients the robot's heading (yaw) to align with valid navigation directions
   - Sets the robot's height appropriately for the surface type

4. **Initializes robot state**:
   - Zeroes linear and angular velocities (robot starts at rest)
   - Resets joint positions to default configurations
   - Prepares sensors and actuators for the new episode

This automatic initialization works seamlessly across:
- **UrbanVerse-160 scenes**: Diverse city layouts from around the world
- **CraftBench scenes**: Artist-designed test environments
- **Custom scenes**: User-generated environments from UrbanVerse-Gen

Benefits of Automatic Initialization
-------------------------------------

**Consistency**: Every episode starts from a valid position, eliminating initialization-related failures

**Diversity**: Spawn points are sampled randomly, providing varied starting conditions that improve policy robustness

**Safety**: No risk of spawning inside obstacles, buildings, or invalid regions

**Simplicity**: No manual configuration required—UrbanVerse handles everything automatically

**Scene Adaptation**: The system adapts to each scene's unique layout, road network, and navigable regions

Example: Episode Reset Flow
----------------------------

Here's what happens automatically when you call ``env.reset()``:

.. code-block:: python

   import urbanverse as uv
   from urbanverse.navigation.config import EnvCfg, SceneCfg

   cfg = EnvCfg(
       scenes=SceneCfg(scene_paths=my_scenes, async_sim=True),
       robot_type="coco_wheeled",
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

   # Reset automatically:
   # 1. Samples valid spawn points for all environments
   # 2. Places robots on drivable surfaces
   # 3. Samples goal positions
   # 4. Initializes robot states
   # 5. Returns initial observations
   obs = env.reset()

   # Your policy receives observations from valid starting positions
   # No manual spawn configuration needed!

Advanced: Custom Events
-----------------------

While automatic spawn initialization covers most use cases, UrbanVerse supports custom events for advanced scenarios:

**Event Types**

- **Reset events**: Applied at the start of each episode (e.g., custom state randomization)
- **Step events**: Applied during environment stepping (e.g., dynamic agent spawning, environmental changes)
- **Manual events**: Triggered programmatically (e.g., scripted scenario changes)

**Use Cases for Custom Events**

- **Enhanced domain randomization**: Randomize robot mass, friction, or sensor parameters
- **Dynamic scenarios**: Spawn or modify pedestrians, vehicles, or obstacles during episodes
- **Environmental variations**: Change lighting, weather, or scene properties over time
- **Specialized training**: Create custom initialization patterns for specific learning objectives

**Implementing Custom Events**

Custom events require subclassing the event configuration and implementing event functions. This is typically only needed for advanced research scenarios or specialized domain adaptation tasks.

For most users, the default automatic initialization provides everything needed for effective training. The system is designed to "just work" out of the box, handling all the complexity of valid spawn point selection and robot state initialization automatically.

Design Philosophy
------------------

UrbanVerse's event system is built on the principle of **sensible defaults with full customization**. The automatic spawn initialization ensures that training starts smoothly without configuration overhead, while the event framework provides the flexibility to implement sophisticated training strategies when needed.

This approach lets you focus on policy design and training hyperparameters rather than low-level simulation setup details.
