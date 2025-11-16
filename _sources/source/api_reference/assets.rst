.. _urbanverse-api-assets:

Assets API
==========

The Assets API provides functions for annotating and managing 3D assets in UrbanVerse-100K.

Import
------

.. code-block:: python

   import urbanverse as uv

Annotate Asset
--------------

.. code-block:: python

   uv.assets.annotate_asset(
       asset_path: str,
       output_dir: str,
       asset_name: str,
       category_hint: str | None = None,
       gpt_api_key: str | None = None,
       overwrite: bool = False,
   ) -> dict

Automatically annotate a 3D asset with semantic, physical, and affordance attributes using GPT-4.1.

This function:
1. Validates the asset file
2. Renders multi-view images using Blender (0°, 90°, 180°, 270°)
3. Extracts geometry properties
4. Uses GPT-4.1 to generate comprehensive annotations
5. Creates standardized metadata JSON file
6. Copies asset to UrbanVerse-100K directory structure

**Parameters:**

- **asset_path** (str): Path to the 3D asset file (GLB, OBJ, USD, FBX). GLB format is recommended for best compatibility
- **output_dir** (str): Directory where the asset and metadata will be saved (typically UrbanVerse-100K assets directory)
- **asset_name** (str): Unique identifier for the asset (used in asset database)
- **category_hint** (str, optional): Suggested category to help GPT-4.1 classification (e.g., ``"furniture"``, ``"vehicle"``, ``"signage"``)
- **gpt_api_key** (str, optional): GPT-4.1 API key. If not provided, uses environment variable ``OPENAI_API_KEY``
- **overwrite** (bool, optional): Whether to overwrite existing asset with same name. Default: ``False``

**Returns:**

- **dict**: Dictionary containing:
  - ``asset_id``: Unique asset identifier
  - ``asset_path``: Path to saved asset file
  - ``metadata_path``: Path to generated metadata JSON file
  - ``annotation_status``: Status of annotation process

**Prerequisites:**

- Blender (version 3.0+) installed and accessible
- OpenAI GPT-4.1 API key set in environment or provided as parameter
- ``BLENDER_PYTHON_PATH`` environment variable set (optional, auto-detected if not set)

**Example:**

.. code-block:: python

   asset_info = uv.assets.annotate_asset(
       asset_path="/path/to/your/asset.glb",
       output_dir="/path/to/UrbanVerse-100K/assets",
       asset_name="custom_object_001",
       category_hint="furniture",
   )

   print(f"Asset added: {asset_info['asset_id']}")
   print(f"Metadata saved to: {asset_info['metadata_path']}")

**Batch Processing:**

.. code-block:: python

   from pathlib import Path

   asset_directory = Path("/path/to/your/assets")
   output_dir = "/path/to/UrbanVerse-100K/assets"

   for asset_file in asset_directory.glob("*.glb"):
       try:
           asset_info = uv.assets.annotate_asset(
               asset_path=str(asset_file),
               output_dir=output_dir,
               asset_name=asset_file.stem,
           )
           print(f"Processed: {asset_file.name}")
       except Exception as e:
           print(f"Failed: {asset_file.name} - {e}")

**Metadata Format:**

The generated metadata follows UrbanVerse-100K's standard format, including:

- Descriptions (long, short, and multi-view)
- Semantic categories (l1, l2, l3 hierarchy)
- Geometry dimensions (height, length, width, max_dimension)
- Material properties (materials, materials_composition, colors)
- Physical attributes (mass, friction_coefficient, bounciness, etc.)
- Affordances (list of interaction capabilities)
- Traversability classification
- Surface properties (hardness, roughness, finish, reflectivity)
- Synset information (WordNet)
- Annotation metadata (LLM models used, date)
- License information

See :doc:`../quickstart/urbanverse_100k` for the complete annotation format specification.

