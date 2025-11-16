.. _urbanverse-quickstart-scenes:


Use Built-in UrbanVerse Scenes
==============================

UrbanVerse comes with a curated set of **160 fully assembled, metric-scale 3D scenes**
extracted from city-tour videos and generated using UrbanVerse-Gen.  
These scenes are ready to be **loaded, visualized, edited, or used for training** in Isaac Sim.

This quickstart page shows how to:

- load the built-in UrbanVerse-160 scenes,
- inspect scene metadata,
- and open them directly in Isaac Sim UI for visual debugging.

All APIs follow the standard UrbanVerse convention:

.. code:: python

   import urbanverse as uv



Prerequisite
------------

Before using UrbanVerse-160, ensure you have set:

.. code:: bash

   export URBANVERSE_SCENE_ROOT="/path/to/UrbanVerse-160"

Inside this folder, each scene is organized as:

.. code:: text

   UrbanVerse-160/
   ├── CapeTown_0001/
   │    └── scene.usd
   ├── Tokyo_0003/
   │    └── scene.usd
   ├── Seoul_0007/
   │    └── scene.usd
   └── ...

Each folder contains a standalone simulation environment compatible with Isaac Sim.



Loading UrbanVerse-160 Scenes
------------------------------

UrbanVerse provides a simple loader for discovering all available scenes.

API
~~~

.. code:: python

   uv.scenes.load_urbanverse_scenes(
       scene_root: str | None = None,
   ) -> list[str]

If ``scene_root`` is not provided, the environment variable  
``$URBANVERSE_SCENE_ROOT`` is used automatically.

Example
~~~~~~~

.. code:: python

   import urbanverse as uv

   scene_paths = uv.scenes.load_urbanverse_scenes()
   print("Total UrbanVerse scenes:", len(scene_paths))
   print("Example:", scene_paths[0])

Typical output:

.. code:: text

   Total UrbanVerse scenes: 160
   Example: /data/UrbanVerse-160/CapeTown_0001/scene.usd



Inspecting Scene Metadata (Optional)
-------------------------------------

Each scene folder includes ``metadata.json`` containing information such as:

- city / country
- approximate route length
- number of object instances
- number of unique object categories
- ground area (road / sidewalk)
- sky HDRI name

API
~~~

.. code:: python

   uv.scenes.load_metadata(scene_path: str) -> dict

Example
~~~~~~~

.. code:: python

   meta = uv.scenes.load_metadata(scene_paths[0])
   print(meta)



Spawning UrbanVerse-160 Scenes in Isaac Sim UI
----------------------------------------------

UrbanVerse provides a helper utility to launch Isaac Sim in UI mode and load a specific scene.

This is useful for:

- checking 3D reconstruction accuracy,
- verifying object placement & physics,
- debugging robot interaction,
- visualizing ground materials & HDRI lighting.

API
~~~

.. code:: python

   uv.scenes.launch_in_isaacsim(
       scene_usd_path: str,
       headless: bool = False,
   )

Example
~~~~~~~

The snippet below loads **CapeTown_0001** directly in Isaac Sim UI:

.. code:: python

   import urbanverse as uv

   scene_paths = uv.scenes.load_urbanverse_scenes()

   uv.scenes.launch_in_isaacsim(
       scene_usd_path=scene_paths[0],   # CapeTown_0001
       headless=False                    # open full UI
   )

Running this opens Isaac Sim, showing the entire UrbanVerse scene with:

- textured road & sidewalk,
- photorealistic HDRI dome lighting,
- fully placed objects (cars, pedestrians, street furniture, etc.),
- real-world metric scale and geometry.

You can freely move the camera, inspect assets, toggle physics, and debug your robot setup.



Filtering Scenes by Statistics (Optional)
-----------------------------------------

Many users want to choose scenes by characteristics — e.g., scenes with:

- long route trajectories,
- high object density.

UrbanVerse provides a metadata-based filter:

API
~~~

.. code:: python

   uv.scenes.filter_scenes(
       scenes: list[str],
       min_objects: int | None = None,
       max_objects: int | None = None,
       min_route_length: float | None = None,
       city: str | None = None,
   ) -> list[str]

Example
~~~~~~~

Select scenes containing at least 200 objects and with a route length over 250 m:

.. code:: python

   import urbanverse as uv

   scene_paths = uv.scenes.load_urbanverse_scenes()
   filtered = uv.scenes.filter_scenes(
       scenes=scene_paths,
       min_objects=200,
       min_route_length=250.0,
   )

   print("Filtered scenes:", len(filtered))



Summary
-------

This page demonstrates how to:

- load the 160 built-in UrbanVerse scenes,
- inspect metadata,
- visualize scenes in Isaac Sim UI,
- optionally filter scenes by statistics.

UrbanVerse-160 offers a diverse set of real-world grounded environments — use them for
debugging, visualization, training preparation, and experimentation.
