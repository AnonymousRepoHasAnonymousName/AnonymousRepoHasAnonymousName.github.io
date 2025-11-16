.. _urbanverse-quickstart-test:


Test Your Robots on CraftBench
==============================

Once you have trained a navigation policy in UrbanVerse, you can evaluate it on
**UrbanVerse-CraftBench** — a curated collection of **artist-designed, high-quality
urban test scenes**. These scenes contain clean geometry, consistent scale, and rich
visual detail, making them ideal for benchmarking policy generalization.

UrbanVerse provides a unified evaluation API for navigation policies, producing:

- **Success Rate (SR)**  
- **Route Completion (RC)**  
- **Collision Times (CT)**  
- **Distance to Goal (DTG)**  

All evaluation APIs follow the same high-level convention:

.. code:: python

   import urbanverse as uv



Prerequisite
------------

Before running CraftBench evaluation, ensure you have set:

.. code:: bash

   export URBANVERSE_CRAFTBENCH_ROOT="/path/to/UrbanVerse-CraftBench"

This directory should contain the 10 high-quality CraftBench scenes (each a folder
containing a ``scene.usd`` and a ``flythrough.mp4``).



Loading CraftBench Scenes
-------------------------

You can load CraftBench scenes using:

API
~~~

.. code:: python

   uv.navigation.eval.load_craftbench_scenes(
       scene_root: str | None = None,
   ) -> list[str]

If ``scene_root`` is ``None``, it defaults to ``$URBANVERSE_CRAFTBENCH_ROOT``.

Example
~~~~~~~

.. code:: python

   import urbanverse as uv

   craft_scenes = uv.navigation.eval.load_craftbench_scenes()
   print("Loaded CraftBench scenes:", len(craft_scenes))
   print(craft_scenes[:2])



Loading a Trained Policy
------------------------

UrbanVerse saves policy checkpoints in the directory specified during training (e.g.,
``outputs/coco_nav``).

You can load a trained PPO policy using:

API
~~~

.. code:: python

   uv.navigation.eval.load_policy(
       checkpoint_path: str,
       device: str = "cuda",
   ) -> "Policy"
   
Example
~~~~~~~

.. code:: python

   import urbanverse as uv

   policy = uv.navigation.eval.load_policy(
       checkpoint_path="outputs/coco_nav/checkpoints/epoch_1500.pt"
   )



Evaluation API
--------------

The core evaluation function is:

API
~~~

.. code:: python

   uv.navigation.eval.evaluate_navigation_policy(
       policy,
       scene_paths: list[str],
       robot_type: str,
       num_episodes_per_scene: int = 10,
       max_episode_seconds: float = 30.0,
       goal_tolerance: float = 0.5,
       device: str = "cuda",
   ) -> dict

The returned dictionary contains aggregated metrics:

.. code:: text

   {
       "SR": 0.78,         # Success Rate
       "RC": 0.85,         # Route Completion
       "CT": 0.42,         # Collision Times (avg)
       "DTG": 1.87,        # Distance to Goal (meters)
       "per_scene": { ... }  # detailed metrics
   }



Metric Definitions
------------------

**Success Rate (SR):**  
Fraction of episodes where the robot reaches the goal within the tolerance.

**Route Completion (RC):**  
Average fraction of the path completed before termination.

**Collision Times (CT):**  
Mean number of collision events per episode.

**Distance to Goal (DTG):**  
Final Euclidean distance to the goal when the episode ends.



End-to-End Example
------------------

Below is a full example demonstrating loading CraftBench scenes, loading a trained
policy, and running evaluation.

.. code:: python

   import urbanverse as uv

   # 1. Load CraftBench scenes
   craft_scenes = uv.navigation.eval.load_craftbench_scenes()

   # 2. Load a trained navigation policy
   policy = uv.navigation.eval.load_policy(
       checkpoint_path="outputs/coco_nav/checkpoints/epoch_1500.pt"
   )

   # 3. Run evaluation
   results = uv.navigation.eval.evaluate_navigation_policy(
       policy=policy,
       scene_paths=craft_scenes,
       robot_type="coco_wheeled",
       num_episodes_per_scene=10,    # evaluate 10 trajectories per test scene
       goal_tolerance=0.5,
       max_episode_seconds=30.0,
   )

   print("Overall CraftBench Evaluation:")
   print(results)


Output Example
~~~~~~~~~~~~~~

.. code:: text

   {
       "SR": 0.72,
       "RC": 0.81,
       "CT": 0.56,
       "DTG": 1.94,
       "per_scene": {
           "CraftBench_0001": {"SR": 0.7, "RC": 0.84, "CT": 0.4, "DTG": 1.8},
           "CraftBench_0002": {"SR": 0.8, "RC": 0.90, "CT": 0.3, "DTG": 1.2},
           ...
       }
   }


Summary
-------

This page demonstrates how to:

- load CraftBench scenes,
- load a trained RL policy,
- run an UrbanVerse-compliant navigation evaluator,
- compute SR, RC, CT, and DTG metrics.

CraftBench serves as UrbanVerse’s **standardized, challenging generalization
benchmark**, allowing you to objectively measure real-world readiness of your trained
navigation policies.
