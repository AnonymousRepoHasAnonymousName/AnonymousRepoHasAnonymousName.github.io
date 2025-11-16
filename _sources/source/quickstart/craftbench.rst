.. _urbanverse-quickstart-craftbench:


Use Built-in CraftBench Scenes
==============================

CraftBench is a curated benchmark of **high-quality, artist-designed 3D urban scenes**
created by professional environment artists.  
These scenes complement UrbanVerse-160 by providing **clean, controllable, visually refined**
simulation environments—ideal for benchmarking, policy evaluation, and qualitative inspection.

Each CraftBench scene includes:

- a fully assembled **USD environment** (`scene.usd`)
- a **flythrough video** (`preview.mp4`) for quick browsing
- high-quality **PBR materials**, **HDRI lighting**, and consistent native scale

This page explains how to:

- load CraftBench scenes,
- inspect scene metadata,
- open scenes in Isaac Sim UI for interactive exploration.


Prerequisite
------------

Before using CraftBench, ensure you have set:

.. code:: bash

   export URBANVERSE_CRAFTBENCH_ROOT="/path/to/UrbanVerse-CraftBench"

The directory structure is:

.. code:: text

   UrbanVerse-CraftBench/
   ├── CraftBench_0001/
   │    ├── scene.usd
   │    └── preview.mp4
   ├── CraftBench_0002/
   │    ├── scene.usd
   │    └── preview.mp4
   └── ...



Loading CraftBench Scenes
-------------------------

UrbanVerse provides a simple, unified API for loading all CraftBench scene paths.

API
~~~

.. code:: python

   uv.scenes.load_craftbench_scenes(
       scene_root: str | None = None,
   ) -> list[str]

If ``scene_root`` is not given, the value of  
``$URBANVERSE_CRAFTBENCH_ROOT`` is used.

Example
~~~~~~~

.. code:: python

   import urbanverse as uv

   craft_scenes = uv.scenes.load_craftbench_scenes()
   print("Total CraftBench scenes:", len(craft_scenes))
   print("Example:", craft_scenes[0])

Typical console output:

.. code:: text

   Total CraftBench scenes: 10
   Example: /data/UrbanVerse-CraftBench/CraftBench_0001/scene.usd



Previewing Scenes (Optional)
----------------------------

Each CraftBench scene includes a short 10–20 second flythrough video, allowing you
to quickly browse the artistic environment.

API
~~~

.. code:: python

   uv.scenes.get_preview_video(scene_path: str) -> str

Example
~~~~~~~

.. code:: python

   preview = uv.scenes.get_preview_video(craft_scenes[0])
   print(preview)

Outputs something like:

.. code:: text

   /data/UrbanVerse-CraftBench/CraftBench_0001/preview.mp4



Spawning CraftBench Scenes in IsaacSim UI
-----------------------------------------

CraftBench scenes are ready-to-run USD environments compatible with Isaac Sim.
UrbanVerse provides a direct helper to open these scenes in the Isaac Sim UI.

API
~~~

.. code:: python

   uv.scenes.launch_in_isaacsim(
       scene_usd_path: str,
       headless: bool = False,
   )

Example
~~~~~~~

To inspect **CraftBench_0001** in Isaac Sim:

.. code:: python

   import urbanverse as uv

   craft_scenes = uv.scenes.load_craftbench_scenes()

   uv.scenes.launch_in_isaacsim(
       scene_usd_path=craft_scenes[0],
       headless=False
   )

This opens Isaac Sim UI and loads the selected CraftBench environment, allowing
you to:

- orbit the camera around the environment,
- inspect object geometry, materials, and lighting,
- place robots manually,
- debug navigation behavior,
- test simulation stability.

CraftBench scenes offer consistent, high-quality lighting and geometry, making
them ideal for **evaluation**, **ablation studies**, or **policy demonstrations**.



Filtering CraftBench Scenes by Attributes (Optional)
----------------------------------------------------

CraftBench metadata includes fields such as:

- scene type (CBD, bar street, residential block, etc.)
- number of objects
- complexity level
- lighting type (sunny, overcast, sunset)
- material richness

API
~~~

.. code:: python

   uv.scenes.filter_craftbench(
       scenes: list[str],
       type: str | None = None,
       min_objects: int | None = None,
       complexity: str | None = None,
   ) -> list[str]

Example
~~~~~~~

Select all **high-complexity street scenes**:

.. code:: python

   filtered = uv.scenes.filter_craftbench(
       scenes=craft_scenes,
       type="bar street",
       complexity="high",
   )

   print("Filtered:", len(filtered))



Summary
-------

This quickstart page shows how to:

- load the artist-designed CraftBench scenes,
- preview them using included videos,
- and launch them in Isaac Sim UI for inspection and debugging.

CraftBench provides **high-quality, aesthetically consistent** environments that
are perfect for testing your trained UrbanVerse RL policies, running benchmarks,
or creating demonstration videos.
