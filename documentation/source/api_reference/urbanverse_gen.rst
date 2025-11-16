.. _urbanverse-api-urbanverse-gen:

UrbanVerse-Gen API
==================

The UrbanVerse-Gen API provides functions for converting raw city-tour videos into fully interactive, metric-scale 3D simulation environments in USD format.

Import
------

.. code-block:: python

   import urbanverse as uv

The UrbanVerse-Gen pipeline consists of four main steps:

1. **Prepare Input Video**: Normalize video input into image frames
2. **Scene Distillation**: Extract semantic scene layout from video
3. **Materialization**: Retrieve 3D assets and materials from UrbanVerse-100K
4. **Scene Generation**: Create and instantiate USD simulation scenes

Prepare Input Video
-------------------

.. code-block:: python

   uv.gen.prepare_input_video(
       input_source: str | list[str],
       output_dir: str,
       start_time: float | None = None,
       end_time: float | None = None,
       min_side: int = 540,
       frames_per_clip: int | None = None,
   ) -> str

Normalize video input into sequential PNG frames for processing.

**Parameters:**

- **input_source** (str | list[str]): Video input source. Can be:
  - YouTube URL (string): URL to YouTube video
  - Local video file path (string): Path to video file (MP4, AVI, etc.)
  - List of image paths (list[str]): Pre-extracted image frames
- **output_dir** (str): Directory where processed frames will be saved
- **start_time** (float, optional): Start time in seconds (required for video inputs). Default: ``None``
- **end_time** (float, optional): End time in seconds (required for video inputs). Default: ``None``
- **min_side** (int, optional): Minimum side length for resizing. Default: ``540``
- **frames_per_clip** (int, optional): Maximum frames per clip. Default: ``None``

**Returns:**

- **str**: Path to the normalized image directory (``output_dir/images/``)

**Note:**

For video inputs, ``start_time`` and ``end_time`` are required. Recommended clip durations:
- Walk videos: ≤ 2 minutes
- Drive videos: ≤ 1 minute

**Example:**

.. code-block:: python

   # From YouTube URL
   image_dir = uv.gen.prepare_input_video(
       input_source="https://www.youtube.com/watch?v=example",
       output_dir="outputs/tokyo",
       start_time=60,
       end_time=120,
   )

   # From local video file
   image_dir = uv.gen.prepare_input_video(
       input_source="/data/videos/tokyo_walk.mp4",
       output_dir="outputs/tokyo",
       start_time=20,
       end_time=110,
   )

   # From existing image frames
   image_dir = uv.gen.prepare_input_video(
       input_source=[
           "my_frames/000001.png",
           "my_frames/000002.png",
           "my_frames/000003.png",
       ],
       output_dir="outputs/tokyo",
   )

Scene Distillation
------------------

.. code-block:: python

   uv.gen.scene_distillation(
       image_dir: str,
       output_dir: str,
       use_openai_gpt: bool = True,
   ) -> str

Extract semantic scene layout from video frames using open-vocabulary scene distillation.

This function performs:
- GPT-4.1 for category enumeration
- MASt3R for metric depth + SE(3) camera poses
- YOLO-World + SAM2 for 2D instance segmentation
- Mask2Former for road/sidewalk segmentation

**Parameters:**

- **image_dir** (str): Path to directory containing input image frames
- **output_dir** (str): Directory where distilled scene data will be saved
- **use_openai_gpt** (bool, optional): Whether to use OpenAI GPT-4.1. Default: ``True``

**Returns:**

- **str**: Path to the distilled scene graph file (``output_dir/distilled_scene_graph.pkl.gz``)

**Prerequisites:**

- OpenAI GPT-4.1 API key must be set: ``export OPENAI_API_KEY="your_key"``

**Output Structure:**

The function creates the following files in ``output_dir``:

- ``conf/``: Depth confidence maps (.npy)
- ``depth/``: Metric depth maps (.npy)
- ``poses/``: Camera SE(3) poses (.npy)
- ``segmentations_2d/``: YOLO-World + SAM2 + Mask2Former masks (.jpg)
- ``camera.yaml``: Estimated camera intrinsics
- ``config_params.json``: Pipeline configuration
- ``scene_pcd.glb``: Reconstructed 3D point cloud
- ``distilled_scene_graph.pkl.gz``: Unified distilled 3D scene graph

**Example:**

.. code-block:: python

   distilled_path = uv.gen.scene_distillation(
       image_dir="outputs/tokyo/images",
       output_dir="outputs/tokyo",
   )
   print("Distilled scene graph at:", distilled_path)

Materialization
---------------

.. code-block:: python

   uv.gen.materialization(
       distilled_graph_dir: str,
       output_dir: str,
       k_cousins: int = 5,
   ) -> str

Enrich the scene graph by retrieving matched assets from UrbanVerse-100K.

This function attaches ``k_cousins`` matched assets to:
- Object nodes
- Road nodes
- Sidewalk nodes
- Sky node

Matching uses:
- CLIP semantic similarity
- Geometry filtering (minimal BBD)
- DINOv2 appearance similarity
- PBR material matching (pixel MSE)
- HDRI sky matching (HSV histograms)

**Parameters:**

- **distilled_graph_dir** (str): Directory containing the distilled scene graph (from ``scene_distillation``)
- **output_dir** (str): Directory where materialized scene will be saved
- **k_cousins** (int, optional): Number of digital-cousin variants to retrieve per object. Default: ``5``

**Returns:**

- **str**: Path to the materialized scene graph file (``output_dir/materialized_scene_with_cousins.pkl.gz``)

**Example:**

.. code-block:: python

   materialized_path = uv.gen.materialization(
       distilled_graph_dir="outputs/tokyo",
       output_dir="outputs/tokyo",
       k_cousins=5,
   )
   print("Materialized graph saved to:", materialized_path)

Scene Generation
----------------

.. code-block:: python

   uv.gen.spawn(
       materialized_graph_path: str,
       output_dir: str,
   ) -> str

Generate interactive Isaac Sim USD scenes from the materialized scene graph.

This function:
- Fits road/sidewalk planes (sidewalk +15 cm)
- Applies matched PBR ground materials
- Selects HDRI dome for lighting/background
- Places objects using metric 3D centroids + yaw orientation
- Assigns physics (mass, friction, restitution)
- Resolves small penetrations
- Exports USD scenes

**Parameters:**

- **materialized_graph_path** (str): Path to materialized scene graph file (from ``materialization``)
- **output_dir** (str): Directory where generated USD scenes will be saved

**Returns:**

- **str**: Path to directory containing generated scene folders

**Output Structure:**

The function creates multiple scene variants in ``output_dir``:

.. code-block:: text

   output_dir/
   ├── scene_cousin_01/
   │    └── scene.usd
   ├── scene_cousin_02/
   │    └── scene.usd
   ...
   └── scene_cousin_05/
        └── scene.usd

Each folder contains a fully interactive simulation scene compatible with Isaac Sim.

**Example:**

.. code-block:: python

   generated_dir = uv.gen.spawn(
       materialized_graph_path="outputs/tokyo/materialized_scene_with_cousins.pkl.gz",
       output_dir="outputs/tokyo",
   )
   print("Generated scenes located at:", generated_dir)

Complete Pipeline Example
--------------------------

.. code-block:: python

   import urbanverse as uv

   # Step 1: Normalize input video into frames
   image_dir = uv.gen.prepare_input_video(
       input_source="https://www.youtube.com/watch?v=example",
       output_dir="outputs/tokyo",
       start_time=20,
       end_time=110,
   )

   # Step 2: Distill the real-world video into a metric 3D scene graph
   distilled_path = uv.gen.scene_distillation(
       image_dir=image_dir,
       output_dir="outputs/tokyo",
   )

   # Step 3: Retrieve digital cousins from UrbanVerse-100K
   materialized_path = uv.gen.materialization(
       distilled_graph_dir="outputs/tokyo",
       output_dir="outputs/tokyo",
       k_cousins=5,
   )

   # Step 4: Generate interactive USD simulation scenes
   generated_dir = uv.gen.spawn(
       materialized_graph_path=materialized_path,
       output_dir="outputs/tokyo",
   )

   print("Scenes generated at:", generated_dir)

