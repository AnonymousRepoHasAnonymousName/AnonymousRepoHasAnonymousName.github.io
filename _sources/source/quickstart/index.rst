.. _urbanverse-quickstart-root:

Quickstart Guide
================

This section provides step-by-step guides to get you started with UrbanVerse's core features and workflows. Whether you want to explore the UrbanVerse-100K dataset, generate custom scenes from videos, use pre-built environments, or train navigation policies, these guides will help you get up and running quickly.

The quickstart guide covers:

- **UrbanVerse-100K Dataset**: Exploring and using the 102,530 3D urban assets, 288 ground materials, and 306 HDRI sky maps through Python APIs
- **UrbanVerse-Gen Pipeline**: Converting raw city-tour videos into fully interactive 3D simulation environments
- **Pre-Built Scenes**: Loading and using UrbanVerse-160 (160 real-to-sim scenes) and CraftBench (10 artist-designed test scenes)
- **Robot Training**: Training goal-point navigation policies using reinforcement learning in UrbanVerse environments
- **Policy Evaluation**: Testing trained policies on CraftBench scenes with standardized evaluation metrics

.. note::

    We recommend system requirements with at least 32GB RAM and 16GB VRAM for UrbanVerse.
    For workflows with rendering enabled, additional VRAM may be required.
    For the full list of system requirements for Isaac Sim, please refer to the
    Isaac Sim system requirements.
    
    Before starting, ensure you have completed the :doc:`../installation/index` process, including installing Isaac Sim, caching UrbanVerse-100K assets, and downloading scenes.


.. toctree::
    :maxdepth: 3

    Introduction to Quickstart Guide <intro_quickstart>
    Use UrbanVerse-100K with APIs <urbanverse_100k>
    Real-to-Sim Scene Generation with UrbanVerse-Gen <urbanverse_gen>
    Use Built-in UrbanVerse Scenes <urbanverse_scenes>
    Use CraftBench Scenes <craftbench>
    Train Your Robots in UrbanVerse <train_your_own_robots>
    Test Your Robots in CraftBench <test_your_robots>


