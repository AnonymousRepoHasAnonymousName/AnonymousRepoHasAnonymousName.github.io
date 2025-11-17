.. _urbanverse-quickstart-urbanversegen:


Real-to-Sim Scene Generation with UrbanVerse-Gen
================================================

UrbanVerse-Gen is an automatic **real-to-simulation** pipeline that converts raw,
uncalibrated RGB city-tour videos into **fully interactive, metric-scale 3D simulation
environments** in USD format.

UrbanVerse-Gen operates in three main stages:

1. **Scene Distillation** – Extract object semantics, metric 3D layout, ground geometry,  
   and sky appearance.
2. **Materialization** – Match each real-world instance to multiple digital-cousin
   assets from UrbanVerse-100K.
3. **Scene Generation** – Assemble physically plausible USD scenes using Isaac Sim.

Everything is exposed through:

.. code:: python

   import urbanverse as uv



Prepare Your Video
------------------

UrbanVerse-Gen accepts three types of video inputs:

1. **YouTube URL:**  
   UrbanVerse automatically downloads the segment you specify using ``yt-dlp``.

2. **Local RGB video file:**  
   Any phone-recorded or camera-recorded city-tour video is allowed.

3. **A folder or list of pre-extracted image frames:**

All inputs are normalized to:

``output_dir/images/``

where UrbanVerse stores sequential PNG frames.

.. note::

   **Timestamps (``start_time`` and ``end_time``) are required** for video inputs  
   (YouTube or local).  
   MASt3R reconstructs global 3D geometry; long clips cause **GPU OOM**.

   Recommended clip durations:

   - **Walk videos:** ≤ **2 minutes**
   - **Drive videos:** ≤ **1 minute**

   Trim longer videos or specify a smaller interval.

API
~~~

.. code:: python

   uv.gen.prepare_input_video(
       input_source: str | list[str],
       output_dir: str,
       start_time: float,
       end_time: float,
       min_side: int = 540,
       frames_per_clip: int | None = None,
   ) -> str


Examples (pipeline step 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~

**1) From YouTube URL**

.. code:: python

   uv.gen.prepare_input_video(
       input_source="https://www.AnonymousYouTubeVideo/PlaceHolder/ForDoubleBlindReview",
       output_dir="outputs/tokyo",
       start_time=60,
       end_time=120
   )

**2) From local video file**

.. code:: python

   uv.gen.prepare_input_video(
       input_source="/data/videos/tokyo_walk.mp4",
       output_dir="outputs/tokyo"
   )

**3) From existing image frames**

.. code:: python

   uv.gen.prepare_input_video(
       input_source=[
           "my_frames/000001.png",
           "my_frames/000002.png",
           ...
       ],
       output_dir="outputs/tokyo"
   )

The function returns the normalized image directory:


``outputs/tokyo/images/``



Extracting Semantic Scene Layout from Videos
--------------------------------------------

UrbanVerse-Gen performs **open-vocabulary scene distillation** using:

- GPT-4.1 for category enumeration  
- MASt3R for metric depth + SE(3) camera poses  
- YOLO-World + SAM2 for 2D instance segmentation  
- Mask2Former for road/sidewalk segmentation

.. note::

   UrbanVerse-Gen **requires** an OpenAI GPT-4.1 key:

   ``export OPENAI_API_KEY="your_openai_key"``


API
~~~

.. code:: python

   uv.gen.scene_distillation(
       image_dir: str,
       output_dir: str,
       use_openai_gpt: bool = True,
   ) -> str


Example (pipeline step 2)
~~~~~~~~~~~~~~~~~~~~~~~~~

Continuing from step 1:

.. code:: python

   distilled_path = uv.gen.scene_distillation(
       image_dir="outputs/tokyo/images",
       output_dir="outputs/tokyo",
   )

   print("Distilled scene graph at:", distilled_path)

Output Structure
~~~~~~~~~~~~~~~~

.. code:: text

   outputs/tokyo/
   ├── conf/                          # depth confidence maps (.npy)
   ├── depth/                         # metric depth maps (.npy)
   ├── poses/                         # camera SE(3) poses (.npy)
   ├── segmentations_2d/              # YOLO-World + SAM2 + Mask2Former masks (.jpg)
   ├── camera.yaml                    # estimated intrinsics
   ├── config_params.json             # pipeline config file
   ├── scene_pcd.glb                  # reconstructed 3D point cloud
   └── distilled_scene_graph.pkl.gz   # unified distilled 3D scene graph



Retrieving 3D Assets and Materials from UrbanVerse-100K
-------------------------------------------------------

UrbanVerse-Gen enriches the scene graph by attaching ``k_cousins`` matched assets to:

- object nodes  
- road nodes  
- sidewalk nodes  
- sky node  

Using:

- **CLIP semantic similarity**
- **Geometry filtering (minimal BBD)**
- **DINOv2 appearance similarity**
- **PBR material matching (pixel MSE)**
- **HDRI sky matching (HSV histograms)**


API
~~~

.. code:: python

   uv.gen.materialization(
       distilled_graph_dir: str,
       output_dir: str,
       k_cousins: int = 5,
   ) -> str


Example (pipeline step 3)
~~~~~~~~~~~~~~~~~~~~~~~~~

Continuing from step 2:

.. code:: python

   materialized_path = uv.gen.materialization(
       distilled_graph_dir="outputs/tokyo",
       output_dir="outputs/tokyo",
       k_cousins=5,
   )

   print("Materialized graph saved to:", materialized_path)

Output
~~~~~~

.. code:: text

   outputs/tokyo/materialized_scene_with_cousins.pkl.gz

This file contains the distilled scene graph plus matched digital-cousin assets.



Creating and Instantiating Simulation Scenes
--------------------------------------------

UrbanVerse-Gen generates **interactive Isaac Sim USD scenes** by:

- fitting road / sidewalk planes (sidewalk +15 cm)
- applying matched PBR ground materials
- selecting HDRI dome for lighting / background
- placing objects using metric 3D centroids + yaw orientation
- assigning physics (mass, friction, restitution)
- resolving small penetrations
- exporting USD scenes


API
~~~

.. code:: python

   uv.gen.spawn(
       materialized_graph_path: str,
       output_dir: str,
   ) -> str


Example (pipeline step 4)
~~~~~~~~~~~~~~~~~~~~~~~~~

Continuing seamlessly:

.. code:: python

   generated_dir = uv.gen.spawn(
       materialized_graph_path="outputs/tokyo/materialized_scene_with_cousins.pkl.gz",
       output_dir="outputs/tokyo",
   )

   print("Generated scenes located at:", generated_dir)


Output Structure
~~~~~~~~~~~~~~~~

.. code:: text

   outputs/tokyo/
   ├── scene_cousin_01/
   │    └── scene.usd
   ├── scene_cousin_02/
   │    └── scene.usd
   ...
   └── scene_cousin_05/
        └── scene.usd

Each folder contains a fully interactive simulation scene compatible with Isaac Sim.



Summary: End-to-End Example Pipeline
------------------------------------

The entire pipeline uses **one output directory** and is run as:

.. code:: python

   import urbanverse as uv

   # Step 1 — Normalize input video into frames
   image_dir = uv.gen.prepare_input_video(
       input_source="https://www.AnonymousURL/ForDoubleBlindReview",
       output_dir="outputs/tokyo",
       start_time=20,
       end_time=110,
   )

   # Step 2 — Distill the real-world video into a metric 3D scene graph
   distilled_path = uv.gen.scene_distillation(
       image_dir=image_dir,
       output_dir="outputs/tokyo",
   )

   # Step 3 — Retrieve digital cousins from UrbanVerse-100K
   materialized_path = uv.gen.materialization(
       distilled_graph_dir="outputs/tokyo",
       output_dir="outputs/tokyo",
       k_cousins=5,
   )

   # Step 4 — Generate interactive USD simulation scenes
   generated_dir = uv.gen.spawn(
       materialized_graph_path=materialized_path,
       output_dir="outputs/tokyo",
   )

   print("Scenes generated at:", generated_dir)
