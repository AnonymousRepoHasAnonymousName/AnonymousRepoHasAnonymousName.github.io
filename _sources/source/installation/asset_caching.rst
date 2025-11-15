.. _urbanverse-installation-assets:

UrbanVerse-100K Asset Caching
=============================

UrbanVerse-100K is our curated collection of high-quality urban 3D assets and textures, each annotated with semantic, physical, and affordance attributes in true metric scale.  
To use the full UrbanVerse-100K database with UrbanVerse-Gen or for your own custom pipelines, you must first download the dataset from our Hugging Face 🤗 repository.

This page describes how to download, verify, and cache UrbanVerse-100K locally.

Dataset Structure
-----------------
UrbanVerse-100K includes the following assets:

.. list-table::
   :header-rows: 1
   :widths: 22 45 18 15

   * - Component
     - Description
     - Quantity
     - Format

   * - 3D Object Assets
     - Metric-scale 3D object models spanning 667 urban categories.
     - 102,530
     - ``.glb``

   * - Object Thumbnails
     - Canonical-view thumbnail for each 3D object asset.
     - 102,530
     - ``.png``

   * - Multi-View Object Renders
     - Four standardized renders per asset at 0°, 90°, 180°, 270°.
     - 410,120 (4 × 102,530)
     - ``.png``

   * - Ground Materials (PBR)
     - 4K photorealistic PBR ground materials (road, sidewalk, terrain).
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
     - One annotation file per asset, each containing 33 semantic, physical, and affordance attributes.
     - 102,530
     - ``.json``

   * - Master Annotation File
     - Global index linking all assets, UIDs, categories, and metadata.
     - 1
     - ``urbanverse_annotation.json``



Each asset is keyed by a unique UID, which appears consistently across all files and metadata.

Downloading UrbanVerse-100K from Hugging Face
---------------------------------------------

We host UrbanVerse-100K on Hugging Face for fast, reliable downloads and resumable large-file transfers.  
You can download the dataset using either the **Hugging Face CLI** or **Git LFS**.

.. note::
   All download URLs in this documentation are anonymized with ``<URL OMITTED FOR DOUBLE-BLIND REVIEW>`` placeholderfor double-blind review.  

Method 1: Using the Hugging Face CLI (Recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Install the Hugging Face client:

   .. code:: bash

      pip install -U huggingface_hub

2. Log in (optional for public models, required for private access):

   .. code:: bash

      huggingface-cli login

3. Download the entire UrbanVerse-100K repository:

   .. code:: bash

      huggingface-cli repo download \
         "<URL OMITTED FOR DOUBLE-BLIND REVIEW>" \
         --local-dir ./UrbanVerse-100K \
         --local-dir-use-symlinks False

This will download all assets, textures, and annotation files into the ``./UrbanVerse-100K`` directory.

Method 2: Using Git LFS
~~~~~~~~~~~~~~~~~~~~~~~

For users who prefer dataset version control with Git:

1. Install Git LFS:

   .. code:: bash

      sudo apt-get install git-lfs
      git lfs install

2. Clone the dataset repository:

   .. code:: bash

      git clone "<URL OMITTED FOR DOUBLE-BLIND REVIEW>" UrbanVerse-100K

Git LFS will automatically fetch the necessary large binary files.

Verifying Your Local Cache
--------------------------

After downloading, ensure the following files exist:

.. code:: text

   UrbanVerse-100K/
   ├── assets_glb/                     # 3D object assets (.glb)
   ├── assets_thumbnails/              # Thumbnails (1 per asset)
   ├── assets_renders/                 # Multi-view renders (0°, 90°, 180°, 270°)
   ├── assets_annotations/             # Per-object attribute JSON files
   ├── ground_materials_mdl/           # PBR ground materials (.mdl)
   │   ├── road/
   │   └── sidewalk/
   ├── ground_materials_thumbnails/    # Thumbnails for each PBR ground material
   │   ├── road/
   │   └── sidewalk/
   ├── sky_maps_hdr/                   # HDRI sky maps (.hdr)
   ├── sky_maps_thumbnails/            # Thumbnails for each HDRI sky map
   ├── urbanverse_annotation.json      # Master annotation file
   └── README.md


If the annotation file is missing, the download may be incomplete.

Linking UrbanVerse-100K with UrbanVerse
---------------------------------------

Once the dataset is downloaded, set the cache path in your environment:

.. code:: bash

   export URBANVERSE_ASSET_ROOT="/path/to/UrbanVerse-100K"

UrbanVerse-Gen and UrbanVerse training pipelines will automatically detect  
the dataset and load assets, textures, and metadata from this directory.

.. note::

   If you place the dataset elsewhere, simply update ``URBANVERSE_ASSET_ROOT`` accordingly.

Using Asset Caching in UrbanVerse-Gen
-------------------------------------

UrbanVerse-Gen relies on the cached UrbanVerse-100K dataset to retrieve and assemble the correct 3D assets for each object detected in a scene. Retrieval is performed using:

- the asset’s GLB file, thumbnail, and multi-view renders (for matching and verification)
- the unique asset UID
- category and subcategory information
- semantic, physical, and affordance attribute filters

When the UrbanVerse-100K cache is properly configured, UrbanVerse-Gen will:

1. **Retrieve candidate assets** from the cached directory based on category tags and attribute constraints.  
2. **Parse per-object annotations** in the extracted semantic scene layout and bind the best-matching cached assets to each object instance.  
3. **Assemble the final simulation scene** by placing assets at metric-accurate coordinates, applying physical parameters from annotations, and exporting the complete scene as a USD environment.

With the asset cache in place, this entire process is automatic and requires no manual handling of files.

Troubleshooting
---------------

**Incomplete download**

If some files appear missing, re-run the download with:

.. code:: bash

   huggingface-cli repo download "<URL OMITTED FOR DOUBLE-BLIND REVIEW>" \
       --local-dir ./UrbanVerse-100K --resume-download

**Git LFS not pulling large files**

.. code:: bash

   git lfs pull

**UrbanVerse cannot find the asset cache**

Verify that:

.. code:: bash

   echo $URBANVERSE_ASSET_ROOT

points to your dataset root folder.