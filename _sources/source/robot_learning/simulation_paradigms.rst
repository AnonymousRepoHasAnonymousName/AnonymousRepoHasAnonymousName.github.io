.. _urbanverse-robot-learning-simulation-paradigms:

Simulation Paradigms
=======================

UrbanVerse supports both **synchronous** and **asynchronous** (recommended) multi-environment
simulation. These two modes determine how **scene layouts** and **digital cousin variants** are
assigned across parallel environments during robot training.

.. note::

   **What are layouts and cousins in UrbanVerse?**

   - A **scene layout** corresponds to the *real-world 3D urban structure* reconstructed from a
     city-tour video: road and sidewalk geometry, building layout, and object placements.

     Examples: ``Tokyo_0001``, ``Beijing_0001``, ..., and ``Los_Angeles_0001``

   - A **digital cousin** is a *variant* of the same layout created by UrbanVerse-Gen.  
     All cousins share the **same placement of objects**, but differ in:
     
       • Retrived 3D assets for each instance in the scene (different cars, buildings, furniture)  
       • Object appearances (different colors, textures, materials)  
       • Textures & PBR materials (road/sidewalk variants)  
       • HDRI sky (lighting, illumination)  

     Example cousins of the same layout: ``Tokyo_0001/scene.usd``, ``Tokyo_0002/scene.usd``, and ``Tokyo_0032/scene.usd``


   Synchronous simulation varies cousins but keeps layout fixed;  
   asynchronous simulation varies both layouts *and* cousins.

UrbanVerse exposes a unified navigation API:

.. code-block:: python

   import urbanverse as uv


🎭 Synchronous Simulation
-------------------------

In **synchronous simulation**, all parallel environments share **one single layout**, but each
environment loads a **different cousin** of that layout.

This means:

- same topological geometry  
- same drivable paths  
- same sidewalk elevations  
- different assets, textures, HDRIs  

Useful for:

- controlled debugging  
- aligned episodes  
- appearance diversity tests with fixed geometry  

**Example: Using 32 cousins of one layout**

Assume:

.. code-block:: text

   $URBANVERSE_SCENE_ROOT/
    ├── Tokyo_0001/scene.usd
    ├── Tokyo_0002/scene.usd
    ...
    └── Tokyo_0032/scene.usd

Synchronous training setup:

.. code-block:: python

   import os
   import urbanverse as uv

   root = os.environ["URBANVERSE_SCENE_ROOT"]

   scene_paths = [
       f"{root}/Tokyo_{i:03d}/scene.usd"
       for i in range(1, 33)
   ]

   env = uv.navigation.rl.create_env_from_scenes(
       scene_paths=scene_paths,     # same layout, 32 cousins
       robot_type="coco_wheeled",
       async_sim=False,             # synchronous mode
       num_envs=32,
   )

   uv.navigation.rl.train(
       env=env,
       training_cfg=training_cfg,
       output_dir="outputs/ppo_tokyo_sync",
   )

Result:

- **Layout fixed**  
- **Cousins vary across envs**  
- **Perfect for controlled experimental diagnostics**  


👬👬 Asynchronous Simulation
--------------------------

In **asynchronous simulation**, each parallel environment loads a **different layout–cousin pair**.
This is the *recommended* mode for policy generalization and large-scale PPO training.

Commonly used during training in UrbanVerse:

- multiple layouts extracted from different city-tour videos  
- multiple cousins per layout  

**Example: 4 layouts × 5 cousins each (20 scenes total)**

.. code-block:: python

   import os
   import urbanverse as uv

   root = os.environ["URBANVERSE_SCENE_ROOT"]

   base_layouts = [
       "Tokyo",
       "Beijing",
       "CapeTown",
       "LosAngeles",
   ]

   scene_pool = []
   for layout in base_layouts:
       for i in range(1, 6):
           scene_pool.append(f"{root}/{layout}_{i:04d}/scene.usd")

   env = uv.navigation.rl.create_env_from_scenes(
       scene_paths=scene_pool,       # different layouts + cousins
       robot_type="coco_wheeled",
       async_sim=True,               # asynchronous mode
       num_envs=32,
   )

   uv.navigation.rl.train(
       env=env,
       training_cfg=training_cfg,
       output_dir="outputs/ppo_multicity_async",
   )

Characteristics of asynchronous mode:

- different **layouts** per environment  
- different **cousins** per layout  
- environments run **independently**  
- maximally diverse visual + geometric distribution  
- better robustness and transfer  


🔄 Comparison: Synchronous vs Asynchronous
-------------------------------------------

+----------------------+----------------------------+--------------------------------+
|                      | **Synchronous**            | **Asynchronous**               |
+======================+============================+================================+
| Layout               | Same across all envs       | Different across envs          |
+----------------------+----------------------------+--------------------------------+
| Cousin Variant       | Different                  | Different                      |
+----------------------+----------------------------+--------------------------------+
| Episode Counters     | Aligned                    | Independent                    |
+----------------------+----------------------------+--------------------------------+
| Best For             | Debugging, controlled eval | Large-scale policy trainin     |
+----------------------+----------------------------+--------------------------------+

