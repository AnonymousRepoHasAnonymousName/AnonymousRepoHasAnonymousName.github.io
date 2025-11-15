.. _urbanverse-quickstart-urbanverse100k:

Use UrbanVerse-100K with APIs
=============================

UrbanVerse-100K is a standalone, Python-friendly dataset of **102,530 metric-scale urban 3D assets**,  
organized into **8 top-level**, **59 mid-level**, and **667 leaf-level categories**.  
In addition, it provides **288 ground materials** and **306 HDRI sky maps** for realistic simulation.

Each 3D object asset is annotated with **33+ semantic, physical, and affordance attributes**  
(e.g., mass, friction, traversability, material composition, affordances such as ``drivable`` or ``openable``).

This section shows how to:

- explore the dataset structure and category statistics,
- load categories, UIDs, and annotations,
- filter objects by attributes,
- download object meshes, ground materials, and sky maps.

Install the UrbanVerse-100K API as:

.. code:: bash

   pip install urbanverse-100k

and import it in Python as:

.. code:: python

   import urbanverse_100k as uvk


Interactive Dataset Overview (Sunburst Plot)
--------------------------------------------

UrbanVerse-100K ships with an interactive **sunburst visualization** summarizing the distribution of assets
across the category hierarchy (``l1``, ``l2``, ``l3``), ground materials, and sky maps.  
The HTML file is bundled inside the package at:

- ``assets/urbanverse_distribution.html``

You can open it from a Jupyter notebook:

.. code:: python

   from IPython.display import IFrame

   html_path = uvk.get_distribution_html()  # returns the absolute path to the HTML file
   IFrame(src=html_path, width=900, height=600)

Or open it in your default browser:

.. code:: python

   import webbrowser

   html_path = uvk.get_distribution_html()
   webbrowser.open(f"file://{html_path}")

This is a convenient way to visually inspect the category hierarchy
before using the Python API.


Quick Exploration of Categories and Components
----------------------------------------------

At a high level, UrbanVerse-100K is organized as follows:

.. list-table::
   :header-rows: 1
   :widths: 22 45 18 15

   * - Component
     - Description
     - Quantity
     - Format

   * - 3D Object Assets
     - Metric-scale 3D object models spanning hundreds of urban categories.
     - 102,530
     - ``.glb``

   * - Object Thumbnails
     - Canonical-view thumbnail for each 3D object asset.
     - 102,530
     - ``.png``

   * - Multi-View Object Renders
     - Four standardized renders per asset at 0°, 90°, 180°, 270°.
     - 4 × 102,530
     - ``.png``

   * - Ground Materials (PBR)
     - 4K photorealistic PBR ground materials for **road**, **sidewalk**, and terrain.
     - 288
     - ``.mdl``

   * - Ground Material Thumbnails
     - Preview thumbnail for each ground material.
     - 288
     - ``.png``

   * - HDRI Sky Maps
     - High-resolution 4K HDRI domes for realistic, full-environment lighting.
     - 306
     - ``.hdr``

   * - HDRI Thumbnails
     - Thumbnail previews for each HDRI sky map.
     - 306
     - ``.png``

   * - Per-Object Annotations
     - One annotation file per asset, each containing semantic, physical, and affordance attributes.
     - 102,530
     - ``.json``

   * - Master Annotation File
     - Global index describing dataset statistics and the ``l1/l2/l3`` hierarchy.
     - 1
     - ``urbanverse_annotation.json``

You can query the global statistics and hierarchy as:

.. code:: python

   about, stats, hierarchy = uvk.load_dataset_metadata()

   print(about["version"])          # e.g., "1.0"
   print(stats["number_of_assets"]) # e.g., 102,530
   print(stats["number_of_classes_l1"], stats["number_of_classes_l2"], stats["number_of_classes_l3"])

   # First few hierarchical entries (l1, l2, l3)
   for row in hierarchy[:5]:
       print(row["l1"], ">", row["l2"], ">", row["l3"])


Loading Categories
------------------

UrbanVerse-100K uses a three-level semantic hierarchy:

- ``l1``: top-level (e.g., ``"building"``, ``"road"``, ``"street user"``, ``"urban object"``, ``"amenity"``, ``"nature"``)
- ``l2``: mid-level (e.g., ``"commercial building"``, ``"transportation amenity"``, ``"vegetation"``)
- ``l3``: leaf-level, fine-grained categories  
  (e.g., ``"traffic light"``, ``"trash bin"``, ``"apartment building"``, ``"electric car"``, ``"delivery robot"``)

API:

.. code:: python

   uvk.load_categories(
       level: str = "leaf",  # "top", "mid", or "leaf"
   ) -> list[str]

   uvk.load_category_stats() -> list[dict]

Examples:

.. code:: python

   import urbanverse_100k as uvk

   # All leaf-level categories (667 in v1.0)
   leaf_categories = uvk.load_categories(level="leaf")
   print("Leaf categories:", len(leaf_categories))
   print(leaf_categories[:10])

   # Coarser mid-level and top-level groups
   mid_categories = uvk.load_categories(level="mid")
   top_categories = uvk.load_categories(level="top")

   print("Top-level categories:", top_categories)

To inspect counts per category:

.. code:: python

   stats = uvk.load_category_stats()
   for row in stats[:5]:
       # Example: "street user > robot > delivery robot  :  42"
       print(f'{row["l1"]} > {row["l2"]} > {row["l3"]} : {row["count"]}')


Loading UIDs
------------

Each asset in UrbanVerse-100K is identified by a unique **UID**.  
We distinguish between:

- **object UIDs** for 3D assets (e.g., an ``"electric car"`` or ``"traffic light"``),
- **ground material IDs** (e.g., ``"Asphalt016"``, ``"PavingStones040"``),
- **sky map IDs** (e.g., ``"urban_street_01"``, ``"autumn_field_puresky"``).

APIs:

.. code:: python

   uvk.load_object_uids(
       top_category: str | None = None,   # maps to l1, e.g., "street user"
       mid_category: str | None = None,   # maps to l2, e.g., "robot"
       leaf_category: str | None = None,  # maps to l3, e.g., "delivery robot"
       limit: int | None = None,
   ) -> list[str]

   uvk.load_ground_ids(
       subset: str | None = None,  # "road", "sidewalk", or None
   ) -> list[str]

   uvk.load_sky_ids() -> list[str]

Examples:

.. code:: python

   import urbanverse_100k as uvk

   # 1) All object UIDs in the dataset
   all_object_uids = uvk.load_object_uids()
   print("Total objects:", len(all_object_uids))

   # 2) Only "street user" assets (top category)
   street_user_uids = uvk.load_object_uids(top_category="street user")
   print("Street users:", len(street_user_uids))

   # 3) Only "traffic light" assets (leaf category), capped at 20
   tl_uids = uvk.load_object_uids(leaf_category="traffic light", limit=20)
   print("Traffic lights (sample):", tl_uids[:5])

   # 4) Ground material IDs (all, road-only, sidewalk-only)
   all_ground_ids = uvk.load_ground_ids()
   road_ground_ids = uvk.load_ground_ids(subset="road")
   sidewalk_ground_ids = uvk.load_ground_ids(subset="sidewalk")

   print("Ground materials:", len(all_ground_ids))
   print("Road materials (e.g., 'Asphalt016', 'Road004'):", road_ground_ids[:5])
   print("Sidewalk materials (e.g., 'PavingStones040', 'wet_arc_cobble'):", sidewalk_ground_ids[:5])

   # 5) HDRI sky map IDs
   sky_ids = uvk.load_sky_ids()
   print("Sky maps:", len(sky_ids))
   print("Examples:", sky_ids[:5])  # e.g., "urban_street_01", "stuttgart_suburbs", "venice_sunset"


Loading Annotations
-------------------

Object annotations expose the full set of **semantic, physical, and affordance attributes** per asset.

API:

.. code:: python

   uvk.load_object_annotations(
       uids: list[str] | None = None,
   ) -> dict[str, dict]

- If ``uids`` is provided, only those objects are returned.
- If ``uids=None``, annotations for **all** objects are returned (and cached locally after first download).

Example: inspect a subset of ``"electric car"`` assets:

.. code:: python

   import urbanverse_100k as uvk

   # Sample a few "electric car" assets
   car_uids = uvk.load_object_uids(leaf_category="electric car", limit=3)

   annotations = uvk.load_object_annotations(car_uids)
   print("Loaded annotations for:", list(annotations.keys()))

   uid = car_uids[0]
   ann = annotations[uid]

   # Print a few key attributes
   print("UID:", ann["uid"])
   print("CLASS_NAME:", ann["CLASS_NAME"])               # e.g., "electric car"
   print("mass (kg):", ann["mass"])                     # e.g., 3000
   print("friction:", ann["friction_coefficient"])      # e.g., 0.9
   print("traversability:", ann["traversability"])      # e.g., "obstacle"
   print("affordances:", ann["affordances"])            # e.g., ["drivable", "openable", ...]
   print("materials:", ann["materials"])                # e.g., ["steel", "glass", "rubber", ...]
   print("license:", ann["license_info"]["license"])    # e.g., "by"

Per-object Annotation Example in UrbanVerse-100K
------------------------------------------------

Each object in UrbanVerse-100K is described by **33+ semantic, physical, material, affordance, and metadata attributes**.  
To help users understand the full structure, we provide a real annotation example below.

The following JSON block is an actual per-object annotation from UrbanVerse-100K  
(for UID ``5a87daef2ee3489dba8b173290029513`` — an *electric car*, a Tesla Cybertruck):

.. code-block:: json

   {
     "description_long": "This electric car features a sharply angular, geometric design with ...",
     "description": "A matte dark gray, angular electric pickup with ...",
     "description_view_0": "Front view shows a wide, flat hood ...",
     "description_view_1": "Left side view highlights ...",
     "description_view_2": "Rear view displays ...",
     "description_view_3": "Right side view mirrors ...",

     "category": "electric car",
     "height": 1.9,
     "max_dimension": 5.7,

     "materials": ["steel", "glass", "rubber", "plastic", "air"],
     "materials_composition": [0.7, 0.15, 0.08, 0.05, 0.02],

     "mass": 3000,
     "receptacle": false,
     "frontView": 0,
     "quality": 7,
     "movable": true,
     "required_force": 6000,
     "walkable": false,
     "enterable": true,

     "affordances": [
       "drivable", "openable", "closable",
       "pressable", "toggleable"
     ],

     "support_surface": true,
     "interactive_parts": [
       "door", "wheel", "window",
       "headlight", "taillight",
       "trunk", "charging port", "mirror"
     ],

     "traversability": "obstacle",
     "traversable_by": [],

     "colors": ["dark gray", "black", "red", "orange"],
     "colors_composition": [0.85, 0.1, 0.03, 0.02],

     "surface_hardness": "hard",
     "surface_roughness": 0.18,
     "surface_finish": "matte",
     "reflectivity": 0.18,
     "index_of_refraction": 1.52,
     "youngs_modulus": 200000,
     "friction_coefficient": 0.9,
     "bounciness": 0.05,
     "recommended_clearance": 1.5,

     "asset_composition_type": "single",

     "attribute_car_manufacturer": "Tesla",
     "attribute_car_model": "Cybertruck",
     "attribute_charging_port_location": "left rear quarter panel",
     "attribute_license_plate_design": "none",
     "attribute_badging_or_emblem": [],

     "uid": "5a87daef2ee3489dba8b173290029513",

     "near_synsets": {
       "electric.n.01": 0.5254,
       "pickup.n.01": 0.5421,
       "technical.n.01": 0.5443,
       "car_window.n.01": 0.5600,
       "bumper_car.n.01": 0.5702,
       "car.n.01": -1000.0,
       "car.n.02": -1000.0
     },

     "synset": "pickup.n.01",
     "wn_version": "oewn:2022",

     "annotation_info": {
       "vision_llm": "gpt-4.1-2025-04-14",
       "text_llm": "gpt-4.1-2025-04-14"
     },

     "license_info": {
       "license": "by",
       "uri": "AnonymousForDoubleBlindReview",
       "creator_username": "AnonymousForDoubleBlindReview",
       "creator_display_name": "AnonymousForDoubleBlindReview",
       "creator_profile_url": "AnonymousForDoubleBlindReview"
     },

     "filename": "5a87daef2ee3489dba8b173290029513.glb",
     "CLASS_NAME": "electric car",
     "foldername": null,

     "hshift": -90.0,
     "length": 6.12585,
     "width": 2.41919,
     "is_building": false
   }

Full List of Annotation Fields
------------------------------

Below is a structured overview of all annotation fields found in UrbanVerse-100K, grouped by functionality.


**1. Descriptions (LLM-generated)**
- ``description_long``
- ``description``
- ``description_view_0`` … ``description_view_3``

**2. Semantic Category**
- ``category`` (same as ``CLASS_NAME``)
- ``synset`` (WordNet synset)
- ``near_synsets`` (top-scoring related synsets)
- ``wn_version``

**3. Geometry & Dimensions**
- ``height``
- ``length``
- ``width``
- ``max_dimension``
- ``scale``
- ``z_axis_scale``
- ``pose_z_rot_angle``
- ``hshift``

**4. Materials**
- ``materials`` (e.g., steel, glass)
- ``materials_composition`` (fractions)
- ``colors`` (semantic)
- ``colors_composition``

**5. Physical Properties**
- ``mass``
- ``friction_coefficient``
- ``bounciness``
- ``surface_roughness``
- ``surface_hardness``
- ``surface_finish``
- ``reflectivity``
- ``index_of_refraction``
- ``youngs_modulus``
- ``max_dimension``

**6. Affordances & Interactions**
- ``movable``
- ``interactive_parts`` (doors, wheels, trunk, …)
- ``affordances`` (drivable, openable, pressable, …)
- ``enterable``
- ``walkable``
- ``support_surface``

**7. Traversability**
- ``traversability`` (e.g., ``obstacle``)
- ``traversable_by`` (list of agent types)

**8. Object Metadata**
- ``uid``
- ``filename``
- ``foldername`` (if grouped)
- ``quality`` (asset quality score)
- ``asset_composition_type``

**9. Additional Object-Specific Attributes**
(e.g., for ``electric car'' category)
- ``attribute_car_manufacturer``
- ``attribute_car_model``
- ``attribute_charging_port_location``
- ``attribute_license_plate_design``
- ``attribute_badging_or_emblem``

**10. Annotation Metadata**
- ``annotation_info`` (LLM models used)

**11. Licensing Information**
- ``license_info``  
  - ``license`` (e.g., ``by``)  
  - ``creator_username``  
  - ``creator_display_name``  
  - ``creator_profile_url``  
  - ``uri``  




Filtering by Attributes
-----------------------

With annotations loaded, you can filter assets using standard Python/NumPy/Pandas tooling.  
Below are some example filters based on real attribute patterns in UrbanVerse-100K.

First, if you prefer ultra-high quality assets, you can filter objects using the UrbanVerse-100K **quality score** (0–10).
We provide an example below.

Example: **high-quality buildings**:

.. code:: python

   annotations = uvk.load_object_annotations()

   high_quality_buildings = [
       uid
       for uid, ann in annotations.items()
       if ann.get("CLASS_NAME") == "building"
       and ann.get("quality", 0) >= 8
   ]

   print("High-quality buildings (quality ≥ 8):", len(high_quality_buildings))
   print(high_quality_buildings[:10])


Second, you can also filter objects based on their semantic category and physical attributes, as you would like for your own use cases. We provide some examples below.

Example: **light, movable street furniture**:

.. code:: python

   annotations = uvk.load_object_annotations()

   movable_light_uids = [
       uid
       for uid, ann in annotations.items()
       if ann.get("l2") == "facilities amenity"
       and ann.get("mass", 1e9) < 50.0
       and ann.get("movable", False) is True
   ]

   print("Movable light facilities (e.g., benches, picnic tables):", len(movable_light_uids))
   print(movable_light_uids[:10])

Example: **static obstacles** suitable as clutter:

.. code:: python

   static_obstacles = [
       uid
       for uid, ann in annotations.items()
       if ann.get("traversability") == "obstacle"
       and ann.get("movable", False) is False
   ]

   print("Static obstacles (e.g., walls, bollards, stone blocks):", len(static_obstacles))

Example: **drivable vehicles** with realistic mass:

.. code:: python

   vehicles = [
       uid
       for uid, ann in annotations.items()
       if ann.get("l1") == "street user"
       and ann.get("CLASS_NAME") in {"electric car", "car", "bus", "truck"}
       and "drivable" in ann.get("affordances", [])
       and 500.0 < ann.get("mass", 0) < 5000.0
   ]

   print("Drivable vehicles:", len(vehicles))
   print(vehicles[:10])

You can define your own filters using any combination of semantic labels and physical attributes,
for example:

- choose only low-friction surfaces (e.g., ``surface_roughness < 0.2``),
- filter for objects at human scale (e.g., ``1.0 <= height <= 2.5``),
- focus on objects with specific affordances (e.g., ``"sit-able"`` furniture, ``"pressable"`` buttons),
- or restrict to licensed subsets (e.g., only assets with ``license_info["license"] == "by"``).


Downloading Assets
------------------

UrbanVerse-100K assets are stored on Hugging Face and fetched lazily.  
The API downloads them to your local cache (typically under ``$URBANVERSE_ASSET_ROOT``)
and returns the corresponding file paths.

APIs:

.. code:: python

   uvk.load_objects(
       uids: list[str],
       download_processes: int = 1,
       include_thumbnails: bool = True,
       include_renders: bool = False,
   ) -> dict[str, dict]

   uvk.load_ground_materials(
       ids: list[str],
       download_processes: int = 1,
       include_thumbnails: bool = True,
   ) -> dict[str, dict]

   uvk.load_sky_maps(
       ids: list[str],
       download_processes: int = 1,
       include_thumbnails: bool = True,
   ) -> dict[str, dict]

For objects, the returned dictionary is structured as:

.. code:: python

   {
       "<uid>": {
           "glb": "/path/to/assets_glb/<uid>.glb",
           "thumbnail": "/path/to/assets_thumbnails/<uid>.png",
           "renders": {
               "0":   "/path/to/assets_renders/<uid>_view_000.png",
               "90":  "/path/to/assets_renders/<uid>_view_090.png",
               "180": "/path/to/assets_renders/<uid>_view_180.png",
               "270": "/path/to/assets_renders/<uid>_view_270.png",
           },
       },
       ...
   }

For ground materials:

.. code:: python

   {
       "<ground_id>": {
           "mdl": "/path/to/ground_materials_mdl/<subset>/<ground_id>.mdl",
           "thumbnail": "/path/to/ground_materials_thumbnails/<subset>/<ground_id>.png",
       },
       ...
   }

where ``<subset>`` is typically ``"road"`` or ``"sidewalk"``  
(e.g., ``"Asphalt016"``, ``"Road004"``, ``"PavingStones040"``, ``"wet_arc_cobble"``).

For sky maps:

.. code:: python

   {
       "<sky_id>": {
           "hdr": "/path/to/sky_maps_hdr/<sky_id>.hdr",
           "thumbnail": "/path/to/sky_maps_thumbnails/<sky_id>.png",
       },
       ...
   }

with IDs such as ``"urban_street_01"``, ``"stuttgart_suburbs"``, ``"venice_sunset"``,
``"autumn_field_puresky"``, or ``"the_sky_is_on_fire"``.

Example: download and inspect a small random subset of objects:

.. code:: python

   import random
   import multiprocessing
   import urbanverse_100k as uvk

   # Sample 50 random objects
   all_uids = uvk.load_object_uids()
   random.seed(42)
   sample_uids = random.sample(all_uids, 50)

   processes = multiprocessing.cpu_count()

   object_paths = uvk.load_objects(
       uids=sample_uids,
       download_processes=processes,
       include_thumbnails=True,
       include_renders=True,
   )

   uid = sample_uids[0]
   print("Paths for", uid)
   print(object_paths[uid])

Example: download all road ground materials and a few sky maps:

.. code:: python

   road_ids = uvk.load_ground_ids(subset="road")
   sky_ids = uvk.load_sky_ids()[:10]

   ground_paths = uvk.load_ground_materials(road_ids)
   sky_paths = uvk.load_sky_maps(sky_ids)

   print("One road material:", next(iter(ground_paths.values())))
   print("One sky map:", next(iter(sky_paths.values())))

Once meshes, materials, and sky domes are cached locally, subsequent calls reuse the local files,
making development, visualization, and real-to-sim scene generation with UrbanVerse-Gen much faster.
