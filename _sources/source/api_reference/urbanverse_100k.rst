.. _urbanverse-api-urbanverse-100k:

UrbanVerse-100K API
===================

The UrbanVerse-100K API provides access to the large-scale dataset of 102,530 metric-scale urban 3D assets, ground materials, and HDRI sky maps.

Installation
------------

.. code-block:: bash

   pip install urbanverse-100k

Import
------

.. code-block:: python

   import urbanverse_100k as uvk

Dataset Metadata
----------------

Load Dataset Metadata
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_dataset_metadata() -> tuple[dict, dict, list[dict]]

Load global dataset statistics, version information, and category hierarchy.

**Returns:**

- **about** (dict): Dataset metadata including version information
- **stats** (dict): Global statistics including:
  - ``number_of_assets``: Total number of 3D object assets
  - ``number_of_classes_l1``: Number of top-level categories
  - ``number_of_classes_l2``: Number of mid-level categories
  - ``number_of_classes_l3``: Number of leaf-level categories
- **hierarchy** (list[dict]): Category hierarchy with ``l1``, ``l2``, ``l3`` fields

**Example:**

.. code-block:: python

   about, stats, hierarchy = uvk.load_dataset_metadata()
   print(about["version"])          # e.g., "1.0"
   print(stats["number_of_assets"]) # e.g., 102,530
   print(stats["number_of_classes_l1"], stats["number_of_classes_l2"], stats["number_of_classes_l3"])

Categories
----------

Load Categories
~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_categories(
       level: str = "leaf",
   ) -> list[str]

Load category names at the specified hierarchy level.

**Parameters:**

- **level** (str, optional): Hierarchy level. Options: ``"top"``, ``"mid"``, ``"leaf"``. Default: ``"leaf"``

**Returns:**

- **list[str]**: List of category names

**Example:**

.. code-block:: python

   leaf_categories = uvk.load_categories(level="leaf")
   mid_categories = uvk.load_categories(level="mid")
   top_categories = uvk.load_categories(level="top")

Load Category Statistics
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_category_stats() -> list[dict]

Load statistics for each category in the hierarchy.

**Returns:**

- **list[dict]**: List of dictionaries, each containing:
  - ``l1``: Top-level category
  - ``l2``: Mid-level category
  - ``l3``: Leaf-level category
  - ``count``: Number of assets in this category

**Example:**

.. code-block:: python

   stats = uvk.load_category_stats()
   for row in stats[:5]:
       print(f'{row["l1"]} > {row["l2"]} > {row["l3"]} : {row["count"]}')

UIDs
----

Load Object UIDs
~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_object_uids(
       top_category: str | None = None,
       mid_category: str | None = None,
       leaf_category: str | None = None,
       limit: int | None = None,
   ) -> list[str]

Load unique identifiers (UIDs) for 3D object assets, optionally filtered by category.

**Parameters:**

- **top_category** (str, optional): Filter by top-level category (l1), e.g., ``"street user"``
- **mid_category** (str, optional): Filter by mid-level category (l2), e.g., ``"robot"``
- **leaf_category** (str, optional): Filter by leaf-level category (l3), e.g., ``"delivery robot"``
- **limit** (int, optional): Maximum number of UIDs to return

**Returns:**

- **list[str]**: List of object UIDs

**Example:**

.. code-block:: python

   all_uids = uvk.load_object_uids()
   street_user_uids = uvk.load_object_uids(top_category="street user")
   delivery_robot_uids = uvk.load_object_uids(leaf_category="delivery robot", limit=20)

Load Ground Material IDs
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_ground_ids(
       subset: str | None = None,
   ) -> list[str]

Load identifiers for ground materials.

**Parameters:**

- **subset** (str, optional): Filter by subset. Options: ``"road"``, ``"sidewalk"``, or ``None`` for all

**Returns:**

- **list[str]**: List of ground material IDs (e.g., ``"Asphalt016"``, ``"PavingStones040"``)

**Example:**

.. code-block:: python

   all_ground_ids = uvk.load_ground_ids()
   road_ids = uvk.load_ground_ids(subset="road")
   sidewalk_ids = uvk.load_ground_ids(subset="sidewalk")

Load Sky Map IDs
~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_sky_ids() -> list[str]

Load identifiers for HDRI sky maps.

**Returns:**

- **list[str]**: List of sky map IDs (e.g., ``"urban_street_01"``, ``"stuttgart_suburbs"``)

**Example:**

.. code-block:: python

   sky_ids = uvk.load_sky_ids()
   print("Sky maps:", len(sky_ids))

Annotations
-----------

Load Object Annotations
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_object_annotations(
       uids: list[str] | None = None,
   ) -> dict[str, dict]

Load annotations for 3D object assets. Each annotation contains 33+ semantic, physical, and affordance attributes.

**Parameters:**

- **uids** (list[str], optional): List of object UIDs to load. If ``None``, loads all annotations (cached after first download)

**Returns:**

- **dict[str, dict]**: Dictionary mapping UID to annotation dictionary. Each annotation includes:
  - ``uid``: Unique identifier
  - ``CLASS_NAME``: Category name
  - ``category``: Category string
  - ``height``, ``length``, ``width``: Dimensions in meters
  - ``mass``: Mass in kg
  - ``materials``: List of material types
  - ``affordances``: List of affordance labels
  - ``traversability``: Traversability classification
  - ``friction_coefficient``: Surface friction
  - And 20+ additional attributes (see :doc:`../quickstart/urbanverse_100k` for full list)

**Example:**

.. code-block:: python

   car_uids = uvk.load_object_uids(leaf_category="electric car", limit=3)
   annotations = uvk.load_object_annotations(car_uids)
   
   uid = car_uids[0]
   ann = annotations[uid]
   print("Category:", ann["CLASS_NAME"])
   print("Mass:", ann["mass"], "kg")
   print("Affordances:", ann["affordances"])

Asset Download
--------------

Load Objects
~~~~~~~~~~~~

.. code-block:: python

   uvk.load_objects(
       uids: list[str],
       download_processes: int = 1,
       include_thumbnails: bool = True,
       include_renders: bool = False,
   ) -> dict[str, dict]

Download and cache 3D object assets from UrbanVerse-100K.

**Parameters:**

- **uids** (list[str]): List of object UIDs to download
- **download_processes** (int, optional): Number of parallel download processes. Default: ``1``
- **include_thumbnails** (bool, optional): Whether to download thumbnail images. Default: ``True``
- **include_renders** (bool, optional): Whether to download multi-view renders. Default: ``False``

**Returns:**

- **dict[str, dict]**: Dictionary mapping UID to asset paths:
  - ``glb``: Path to GLB mesh file
  - ``thumbnail``: Path to thumbnail image (if requested)
  - ``renders``: Dictionary of render paths keyed by angle (if requested)

**Example:**

.. code-block:: python

   uids = uvk.load_object_uids(leaf_category="traffic light", limit=10)
   object_paths = uvk.load_objects(
       uids=uids,
       download_processes=4,
       include_thumbnails=True,
       include_renders=True,
   )
   
   uid = uids[0]
   print("GLB:", object_paths[uid]["glb"])
   print("Thumbnail:", object_paths[uid]["thumbnail"])

Load Ground Materials
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_ground_materials(
       ids: list[str],
       download_processes: int = 1,
       include_thumbnails: bool = True,
   ) -> dict[str, dict]

Download and cache ground material assets.

**Parameters:**

- **ids** (list[str]): List of ground material IDs
- **download_processes** (int, optional): Number of parallel download processes. Default: ``1``
- **include_thumbnails** (bool, optional): Whether to download thumbnail images. Default: ``True``

**Returns:**

- **dict[str, dict]**: Dictionary mapping ID to asset paths:
  - ``mdl``: Path to MDL material file
  - ``thumbnail``: Path to thumbnail image (if requested)

**Example:**

.. code-block:: python

   road_ids = uvk.load_ground_ids(subset="road")
   material_paths = uvk.load_ground_materials(road_ids[:5])
   print("Materials downloaded:", len(material_paths))

Load Sky Maps
~~~~~~~~~~~~~

.. code-block:: python

   uvk.load_sky_maps(
       ids: list[str],
       download_processes: int = 1,
       include_thumbnails: bool = True,
   ) -> dict[str, dict]

Download and cache HDRI sky map assets.

**Parameters:**

- **ids** (list[str]): List of sky map IDs
- **download_processes** (int, optional): Number of parallel download processes. Default: ``1``
- **include_thumbnails** (bool, optional): Whether to download thumbnail images. Default: ``True``

**Returns:**

- **dict[str, dict]**: Dictionary mapping ID to asset paths:
  - ``hdr``: Path to HDR sky map file
  - ``thumbnail``: Path to thumbnail image (if requested)

**Example:**

.. code-block:: python

   sky_ids = uvk.load_sky_ids()[:10]
   sky_paths = uvk.load_sky_maps(sky_ids)
   print("Sky maps downloaded:", len(sky_paths))

Visualization
-------------

Get Distribution HTML
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   uvk.get_distribution_html() -> str

Get the path to the interactive sunburst visualization HTML file.

**Returns:**

- **str**: Absolute path to the distribution HTML file

**Example:**

.. code-block:: python

   from IPython.display import IFrame
   
   html_path = uvk.get_distribution_html()
   IFrame(src=html_path, width=900, height=600)

