.. _urbanverse-robot-learning-rl-guide-scene:

Working with Urban Scenes
==========================

UrbanVerse transforms real-world city environments into interactive simulation scenes. Whether you're using pre-built UrbanVerse-160 environments, CraftBench's evaluation scenes, or custom scenes generated from your own videos, scene configuration determines which environments your robot will train in and how they're organized across parallel simulation instances.

Understanding Scene Sources
----------------------------

UrbanVerse provides three primary sources of urban simulation scenes, each suited for different stages of the training pipeline:

**UrbanVerse-160: Real-to-Sim Training Scenes**  
A curated collection of 160 metric-scale urban environments reconstructed from city-tour videos spanning 7 continents, 24 countries, and 27 cities. Each scene includes multiple digital cousin variants—different asset instantiations of the same underlying city layout—providing rich visual diversity while maintaining consistent geometric structure.  
Perfect for: Large-scale training, validation, and generalization experiments.  
→ Learn more: :doc:`../../quickstart/urbanverse_scenes`

**CraftBench: Artist-Crafted Test Scenes**  
Ten high-fidelity urban environments meticulously designed by professional 3D artists. These scenes feature carefully crafted layouts, realistic asset placement, and challenging navigation scenarios.  
Perfect for: Final policy evaluation, benchmarking, and test-time assessment.  
→ Learn more: :doc:`../../quickstart/craftbench`

**Custom Scenes via UrbanVerse-Gen**  
Generate your own simulation environments directly from casually captured city-tour videos. The UrbanVerse-Gen pipeline extracts scene layouts, retrieves appropriate 3D assets, and instantiates fully interactive USD scenes.  
Perfect for: Domain-specific training, custom city environments, and research applications.  
→ Learn more: :doc:`../../quickstart/urbanverse_gen`

Configuring Scene Loading
--------------------------

Scene configuration is straightforward: provide a list of USD scene file paths and specify how they should be distributed across your parallel training environments.

.. code-block:: python

   import os
   import urbanverse as uv
   from urbanverse.navigation.config import EnvCfg, SceneCfg

   # Collect scenes from UrbanVerse-160
   scene_root = os.environ.get("URBANVERSE_SCENE_ROOT", "/path/to/UrbanVerse-160")
   
   scene_paths = [
       f"{scene_root}/Tokyo_{i:04d}/scene.usd" for i in range(1, 6)
   ] + [
       f"{scene_root}/Beijing_{i:04d}/scene.usd" for i in range(1, 6)
   ]

   cfg = EnvCfg(
       scenes=SceneCfg(
           scene_paths=scene_paths,
           async_sim=True,      # Each env gets a different scene
           env_spacing=3.0,     # 3 meters between parallel environments
       ),
       robot_type="coco_wheeled",
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

Key Configuration Parameters
-----------------------------

**scene_paths** (list of strings)  
A list of absolute paths to USD scene files. Each path points to a complete simulation environment that can be loaded independently. You can mix scenes from different sources—UrbanVerse-160, CraftBench, and custom scenes—in the same training run.

**async_sim** (bool)  
Controls how scenes are assigned across parallel environments:

- ``True`` (recommended): Each environment loads a different scene from your pool. This maximizes diversity and is ideal for training robust, generalizable policies. Different environments will see different city layouts, building arrangements, and obstacle configurations.

- ``False``: All environments share the same underlying city layout, but each loads a different digital cousin variant. This keeps the geometric structure consistent while varying visual appearance (assets, textures, lighting). Useful for debugging and controlled experiments where you want to isolate the effects of visual diversity.

**env_spacing** (float)  
The horizontal separation (in meters) between parallel environments in the simulator. Each environment is placed on a grid, and this parameter controls the spacing. Larger values provide more isolation but require more simulation space.

Scene Distribution Strategies
------------------------------

The choice between synchronous and asynchronous simulation (see :doc:`../simulation_paradigms` for a detailed comparison) significantly impacts training dynamics:

**Asynchronous Mode** (``async_sim=True``)  
Each of your 32 parallel environments might load: Tokyo_0001, Beijing_0003, CapeTown_0002, LosAngeles_0005, etc. This creates maximum diversity—your policy experiences different road networks, building layouts, and spatial structures simultaneously.  
→ Best for: Training generalizable policies that work across diverse urban environments.

**Synchronous Mode** (``async_sim=False``)  
All 32 environments load different cousins of the same layout (e.g., Tokyo_0001, Tokyo_0002, ..., Tokyo_0032). The road geometry, building positions, and drivable paths are identical, but asset appearances, textures, and lighting vary.  
→ Best for: Debugging, controlled experiments, and understanding the impact of visual diversity.

Practical Example: Multi-City Training Setup
---------------------------------------------

Here's a complete example that sets up training across multiple cities with proper scene organization:

.. code-block:: python

   import os
   import urbanverse as uv
   from urbanverse.navigation.config import EnvCfg, SceneCfg

   scene_root = os.environ.get("URBANVERSE_SCENE_ROOT")

   # Define your city layouts
   cities = {
       "Tokyo": range(1, 6),      # 5 cousins
       "Beijing": range(1, 6),    # 5 cousins
       "CapeTown": range(1, 4),   # 3 cousins
       "LosAngeles": range(1, 4), # 3 cousins
   }

   # Build scene path list
   scene_paths = []
   for city, cousin_range in cities.items():
       for cousin_id in cousin_range:
           scene_paths.append(
               f"{scene_root}/{city}_{cousin_id:04d}/scene.usd"
           )

   print(f"Total scenes: {len(scene_paths)}")  # 16 scenes

   # Configure environment
   cfg = EnvCfg(
       scenes=SceneCfg(
           scene_paths=scene_paths,
           async_sim=True,        # Mix different cities across environments
           env_spacing=3.0,
       ),
       robot_type="coco_wheeled",
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

During training, UrbanVerse automatically manages scene assignment, ensuring each environment receives a valid scene and that scenes are properly shuffled between episodes. The RL API handles all the complexity of scene loading, distribution, and rotation, letting you focus on policy design and training.
