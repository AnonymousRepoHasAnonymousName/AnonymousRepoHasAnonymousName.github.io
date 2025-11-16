.. _urbanverse-developer-adding-assets:

Adding New Assets to UrbanVerse-100K
=====================================

UrbanVerse-100K provides an automatic annotation tool that enables you to add new 3D assets to the dataset with semantic, physical, and affordance attributes. This tool uses GPT-4.1 to automatically annotate assets, making it easy to extend UrbanVerse-100K with custom objects.

.. note::

   **Blender Installation Required**: The automatic annotation tool uses Blender's Python interface for rendering multi-view images of assets, which are used by GPT-4.1 for visual analysis. Please install Blender and configure its Python interface before using the annotation tool:

   **Installation Steps:**

   1. **Install Blender**: Install Blender (version 3.0 or later recommended) from `AnonymousForDoubleBlindReview`

   2. **Locate Blender's Python**: After installation, Blender includes its own Python interpreter. The location depends on your system:
      
      - **Linux**: ``/path/to/blender/3.x/python/bin/python3.x`` (typically in the Blender installation directory)
      - **macOS**: ``/Applications/Blender.app/Contents/Resources/3.x/python/bin/python3.x``
      - **Windows**: ``C:\Program Files\Blender Foundation\Blender 3.x\3.x\python\bin\python.exe``

   3. **Set Environment Variable**: Set the ``BLENDER_PYTHON_PATH`` environment variable to point to Blender's Python executable:

      .. code-block:: bash

         # Linux/macOS
         export BLENDER_PYTHON_PATH="/path/to/blender/3.x/python/bin/python3.x"
         
         # Windows (PowerShell)
         $env:BLENDER_PYTHON_PATH="C:\Program Files\Blender Foundation\Blender 3.x\3.x\python\bin\python.exe"

   4. **Verify Installation**: Test that Blender's Python is accessible:

      .. code-block:: bash

         $BLENDER_PYTHON_PATH --version
         # Should output Python version (e.g., Python 3.10.x)

   5. **Install Required Python Packages**: Install bpy (Blender Python API) and other dependencies in Blender's Python environment:

      .. code-block:: bash

         $BLENDER_PYTHON_PATH -m pip install bpy numpy pillow

   The annotation tool will use this Python interpreter to run Blender rendering scripts. If ``BLENDER_PYTHON_PATH`` is not set, the tool will attempt to auto-detect Blender's Python installation, but manual configuration is recommended for reliability.

Overview
---------

The automatic annotation tool processes 3D asset files (GLB, OBJ, USD, FBX, etc.) and generates comprehensive metadata including:

- **Semantic attributes**: Category labels (L1, L2, L3), object type, material composition
- **Physical attributes**: Dimensions, weight, material properties, collision properties
- **Affordance attributes**: Functional capabilities, interaction possibilities, usage contexts

This metadata is stored in a standardized format compatible with UrbanVerse-100K's asset database.

Prerequisites
-------------

Before adding new assets, ensure you have:

- 3D asset files in supported formats (GLB, OBJ, USD, FBX)
- Blender installed (version 3.0 or later) for rendering multi-view images
- Access to GPT-4.1 API (for automatic annotation)
- UrbanVerse-100K dataset structure set up locally

Basic Usage
-----------

The automatic annotation tool is accessed through UrbanVerse's asset management API:

.. code-block:: python

   import urbanverse as uv

   # Add a new asset with automatic annotation
   asset_info = uv.assets.annotate_asset(
       asset_path="/path/to/your/asset.glb",
       output_dir="/path/to/UrbanVerse-100K/assets",
       asset_name="custom_object_001",
       category_hint="furniture",
   )

   print(f"Asset added: {asset_info['asset_id']}")
   print(f"Metadata saved to: {asset_info['metadata_path']}")

API Reference
-------------

Annotate Asset
~~~~~~~~~~~~~~~

.. code-block:: python

   uv.assets.annotate_asset(
       asset_path: str,
       output_dir: str,
       asset_name: str,
       category_hint: str | None = None,
       gpt_api_key: str | None = None,
       overwrite: bool = False,
   ) -> dict

**Parameters:**

- **asset_path** (str): Path to the 3D asset file (GLB, OBJ, USD, FBX). GLB format is recommended for best compatibility.
- **output_dir** (str): Directory where the asset and metadata will be saved (typically UrbanVerse-100K assets directory)
- **asset_name** (str): Unique identifier for the asset (used in asset database)
- **category_hint** (str, optional): Suggested category to help GPT-4.1 classification (e.g., "furniture", "vehicle", "signage")
- **gpt_api_key** (str, optional): GPT-4.1 API key. If not provided, uses environment variable ``OPENAI_API_KEY``
- **overwrite** (bool, optional): Whether to overwrite existing asset with same name. Default: ``False``

**Returns:**

- **dict**: Dictionary containing:
  - ``asset_id``: Unique asset identifier
  - ``asset_path``: Path to saved asset file
  - ``metadata_path``: Path to generated metadata JSON file
  - ``annotation_status``: Status of annotation process

**Example:**

.. code-block:: python

   import urbanverse as uv

   # Add multiple assets in batch
   asset_files = [
       "/path/to/chair_001.glb",
       "/path/to/table_002.glb",
       "/path/to/lamp_003.glb",
   ]

   for asset_file in asset_files:
       asset_info = uv.assets.annotate_asset(
           asset_path=asset_file,
           output_dir="/path/to/UrbanVerse-100K/assets",
           asset_name=asset_file.stem,  # Use filename without extension
           category_hint="furniture",
       )
       print(f"✓ Added: {asset_info['asset_id']}")

Annotation Process
------------------

The automatic annotation tool performs the following steps:

1. **Asset Validation**: Verifies the asset file is valid and can be loaded
2. **Multi-View Rendering**: Uses Blender to render the asset from four standardized viewpoints (0°, 90°, 180°, 270°)
3. **Geometry Analysis**: Extracts dimensions, bounding box, and geometric properties
4. **GPT-4.1 Annotation**: Uses GPT-4.1 with rendered images to generate semantic, physical, and affordance attributes
5. **Metadata Generation**: Creates standardized metadata JSON file following UrbanVerse-100K format
6. **Asset Integration**: Copies asset to UrbanVerse-100K directory structure

Metadata Format
---------------

The generated metadata follows UrbanVerse-100K's standard format, matching the comprehensive annotation structure used throughout the dataset. Below is an example annotation for a custom chair asset:

.. code-block:: json

   {
     "description_long": "A modern office chair with ergonomic design featuring adjustable height and lumbar support...",
     "description": "A black mesh office chair with metal frame and five-wheel base",
     "description_view_0": "Front view shows the chair's backrest with mesh material and adjustable headrest",
     "description_view_1": "Left side view highlights the armrests and seat depth",
     "description_view_2": "Rear view displays the backrest structure and base attachment",
     "description_view_3": "Right side view mirrors the left side, showing symmetrical design",

     "category": "office chair",
     "height": 1.2,
     "max_dimension": 0.6,
     "length": 0.6,
     "width": 0.6,

     "materials": ["plastic", "metal", "fabric", "foam"],
     "materials_composition": [0.3, 0.4, 0.2, 0.1],

     "mass": 12.5,
     "receptacle": false,
     "frontView": 0,
     "quality": 8,
     "movable": true,
     "required_force": 50,
     "walkable": false,
     "enterable": false,

     "affordances": [
       "sit", "move", "adjustable"
     ],

     "support_surface": true,
     "interactive_parts": [
       "seat", "backrest", "armrest", "base", "wheels"
     ],

     "traversability": "obstacle",
     "traversable_by": [],

     "colors": ["black", "gray", "silver"],
     "colors_composition": [0.6, 0.3, 0.1],

     "surface_hardness": "medium",
     "surface_roughness": 0.3,
     "surface_finish": "matte",
     "reflectivity": 0.15,
     "index_of_refraction": 1.5,
     "youngs_modulus": 5000,
     "friction_coefficient": 0.7,
     "bounciness": 0.1,
     "recommended_clearance": 0.1,

     "asset_composition_type": "single",

     "uid": "custom_object_001",
     "filename": "custom_object_001.glb",
     "CLASS_NAME": "office chair",
     "foldername": null,

     "hshift": 0.0,
     "is_building": false,

     "near_synsets": {
       "chair.n.01": 0.5234,
       "seat.n.01": 0.6123,
       "furniture.n.01": 0.4456
     },

     "synset": "chair.n.01",
     "wn_version": "oewn:2022",

     "annotation_info": {
       "vision_llm": "gpt-4.1-2025-11-16",
       "text_llm": "gpt-4.1-2025-11-16"
     },

     "license_info": {
       "license": "by",
       "uri": "AnonymousForDoubleBlindReview",
       "creator_username": "user_name",
       "creator_display_name": "User Name",
       "creator_profile_url": "AnonymousForDoubleBlindReview"
     }
   }

The annotation includes all standard UrbanVerse-100K fields: descriptions (long, short, and multi-view), semantic categories, geometry dimensions, material properties, physical attributes, affordances, traversability, surface properties, and metadata. Category-specific attributes (like ``attribute_car_manufacturer`` for vehicles) are automatically included when relevant.

Customizing Annotations
------------------------

You can provide additional context to improve annotation quality:

.. code-block:: python

   asset_info = uv.assets.annotate_asset(
       asset_path="/path/to/asset.glb",
       output_dir="/path/to/UrbanVerse-100K/assets",
       asset_name="custom_object_001",
       category_hint="outdoor_furniture",
       additional_context={
           "description": "Park bench with metal frame",
           "location": "outdoor",
           "use_case": "public_space",
       },
   )

Manual Annotation Review
-------------------------

After automatic annotation, you can review and edit the generated metadata:

.. code-block:: python

   import json

   # Load metadata
   metadata_path = asset_info['metadata_path']
   with open(metadata_path, 'r') as f:
       metadata = json.load(f)

   # Review and edit
   metadata['CLASS_NAME'] = "park bench"  # Correct category
   metadata['category'] = "park bench"
   metadata['affordances'].append("outdoor_use")  # Add affordance

   # Save updated metadata
   with open(metadata_path, 'w') as f:
       json.dump(metadata, f, indent=2)

Batch Processing
-----------------

For adding multiple assets, use batch processing:

.. code-block:: python

   import urbanverse as uv
   from pathlib import Path

   asset_directory = Path("/path/to/your/assets")
   output_dir = "/path/to/UrbanVerse-100K/assets"

   # Process all GLB files in directory (also supports .obj, .usd, .fbx)
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

   # You can also process multiple formats in one batch:
   for ext in ["*.glb", "*.obj", "*.usd"]:
       for asset_file in asset_directory.glob(ext):
           try:
               asset_info = uv.assets.annotate_asset(
                   asset_path=str(asset_file),
                   output_dir=output_dir,
                   asset_name=asset_file.stem,
               )
               print(f"Processed: {asset_file.name}")
           except Exception as e:
               print(f"Failed: {asset_file.name} - {e}")