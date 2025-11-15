.. _urbanverse-installation-scenes:

UrbanVerse Scene Caching
=============================

UrbanVerse provides two types of urban simulation environments:

1. **UrbanVerse-160** — 160 real-to-sim environments reconstructed from YouTube city-tour videos.  
2. **CraftBench** — 10 professionally designed artist-crafted scenes reserved strictly for test-only evaluation.

Both sets of scenes are hosted on Hugging Face 🤗 for fast, resumable downloads.  
This page describes how to download, verify, and use these scenes with UrbanVerse-Gen and UrbanVerse pipelines.


UrbanVerse-160 (Real-to-Sim Scenes)
-----------------------------------

UrbanVerse-160 is our collection of **160 metric-scaled urban scenes** reconstructed from real-world city-tour videos spanning **7 continents, 24 countries, and 27 cities**.  
Each scene includes:

- a final **USD environment** (lighting, ground, object placements)
- the **semantic scene layout** (object instances, poses, categories, UIDs)
- **scene-level metadata** (geo-region, asset statistics, reconstruction info)

You can download UrbanVerse-160 in two different ways depending on your needs.


Method 1: Download the Complete Pre-Built Scenes (Recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This method downloads the final USD simulations directly.

1. Install the Hugging Face client (if not already installed):

   .. code:: bash

      pip install -U huggingface_hub

2. Download the full UrbanVerse-160 package:

   .. code:: bash

      huggingface-cli repo download \
         "<URL OMITTED FOR DOUBLE-BLIND REVIEW>" \
         --local-dir ./UrbanVerse-160 \
         --local-dir-use-symlinks False

This will download all 160 pre-constructed USD scenes along with their scene metadata.

The resulting directory structure will look like:

.. code:: text

   UrbanVerse-160/
   ├── scenes_usd/
   ├── scenes_layouts/
   ├── scenes_metadata/
   └── README.md


Method 2: Download Only the Scene Layouts (If UrbanVerse-100K Is Already Installed)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you have already downloaded **UrbanVerse-100K**, you do *not* need the full USD scenes.  
Instead, you can download the **scene layout JSON files only**, and reconstruct each scene locally using UrbanVerse-Gen.

1. Download only the layout files:

   .. code:: bash

      huggingface-cli repo download \
         "<URL OMITTED FOR DOUBLE-BLIND REVIEW>" \
         --include "scenes_layouts/*" \
         --local-dir ./UrbanVerse-160-Layouts \
         --local-dir-use-symlinks False

2. Reconstruct scenes locally:

   .. code:: bash

      python -m urbanverse.gen.spawn \
         --layout ./UrbanVerse-160-Layouts/<scene_id>.json \
         --asset-root $URBANVERSE_ASSET_ROOT \
         --output ./my_generated_scenes/<scene_id>.usd

UrbanVerse-Gen will automatically:

- load the scene layout  
- match each object to its digital cousin assets from UrbanVerse-100K  
- assemble the scene with correct metric scale  
- export a final USD environment identical to the pre-built version  

This method is far smaller in download size and ideal for users with UrbanVerse-100K installed.


CraftBench (Artist-Designed Scenes)
-----------------------------------

CraftBench is a curated collection of **10 high-fidelity urban scenes** created entirely by professional 3D artists.  
These scenes are intended **solely for evaluation**, and serve as the official held-out test set for UrbanVerse benchmarks.

Each CraftBench scene is provided as an individual folder containing:

- a fully authored **USD scene file**, ready for simulation  
- an accompanying **flythrough video** (``.mp4``) visualizing the scene from multiple viewpoints

These scenes do *not* include reconstruction layouts and are *not* used for training or data generation.

To download the CraftBench package:

.. code:: bash

   huggingface-cli repo download \
      "<URL OMITTED FOR DOUBLE-BLIND REVIEW>" \
      --local-dir ./UrbanVerse-CraftBench \
      --local-dir-use-symlinks False

Directory structure:

.. code:: text

   UrbanVerse-CraftBench/
   ├── scene_001/
   │   ├── scene.usd               # Final authored simulation scene
   │   └── flythrough.mp4          # Artist-created walkthrough video
   ├── scene_002/
   │   ├── scene.usd
   │   └── flythrough.mp4
   ├── ...
   ├── scene_010/
   │   ├── scene.usd
   │   └── flythrough.mp4
   └── README.md

Once downloaded, you can load any CraftBench scene directly into Isaac Sim or Isaac Lab for evaluation.



Using Cached Scenes in UrbanVerse
---------------------------------

After downloading the scene packages, set the environment variables for both the real-to-sim scenes and the CraftBench evaluation set:

.. code:: bash

   export URBANVERSE_SCENE_ROOT="/path/to/UrbanVerse-160"        # Root for reconstructed + user-generated scenes
   export URBANVERSE_CRAFTBENCH_ROOT="/path/to/UrbanVerse-CraftBench"

UrbanVerse uses these paths as follows:

- **`URBANVERSE_SCENE_ROOT`**  
  - Stores the 160 pre-built UrbanVerse-160 USD scenes (if downloaded)  
  - Stores the scene layout JSON files (if using the lightweight download option)  
  - **Serves as the default directory for saving any customized or newly generated scenes** created with UrbanVerse-Gen  

- **`URBANVERSE_CRAFTBENCH_ROOT`**  
  - Stores the 10 artist-designed CraftBench scenes  
  - Used exclusively for test-time evaluation  

Once these paths are set, UrbanVerse pipelines will automatically detect:

- Pre-built USD scenes (if available)
- Scene layouts and rebuild the environment using UrbanVerse-Gen (if only layouts are present)
- Newly generated scenes placed under ``$URBANVERSE_SCENE_ROOT``

All UrbanVerse training, evaluation, and generation workflows will load and save scenes directly in these configured directories.
