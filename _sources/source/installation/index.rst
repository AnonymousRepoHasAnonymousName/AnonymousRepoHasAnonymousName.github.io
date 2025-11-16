.. _urbanverse-installation-root:

Installation
============

.. note::

    We recommend system requirements with at least 32GB RAM and 16GB VRAM for UrbanVerse.
    For workflows with rendering enabled, additional VRAM may be required.
    For the full list of system requirements for Isaac Sim, please refer to the
    Isaac Sim system requirements.

UrbanVerse runs on top of the NVIDIA Isaac Sim simulation engine. This section covers the complete installation process:

- **Installing Isaac Sim**: Setting up Isaac Sim from pre-built binaries and configuring UrbanVerse source code
- **Caching UrbanVerse-100K Assets**: Downloading the 102,530 3D object assets, 288 ground materials, and 306 HDRI sky maps from Hugging Face
- **Caching UrbanVerse Scenes**: Downloading UrbanVerse-160 (160 real-to-sim environments) and CraftBench (10 artist-crafted test scenes) from Hugging Face
- **Verifying Installation**: Testing that UrbanVerse-Gen, Isaac Sim integration, and scene loading work correctly

.. toctree::
    :maxdepth: 2

    binaries_installation
    asset_caching
    scene_caching
    verifying_installation


