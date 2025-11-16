.. _urbanverse-robot-learning-il-guide-root:

Imitation Learning in UrbanVerse
==================================

This chapter explains how to train Behavior Cloning (BC) policies for goal-directed navigation in UrbanVerse scenes. You can learn from expert demonstrations collected directly within UrbanVerse's simulation environment, or import real-world teleoperated demonstrations mapped into UrbanVerse's urban scenes.

UrbanVerse provides a unified framework for imitation learning, including consistent data formats, streamlined training APIs, and comprehensive evaluation tools that work seamlessly with UrbanVerse-160, CraftBench, and custom scenes.

Documentation Overview
-----------------------

This documentation covers the complete imitation learning workflow:

- **Collecting expert demonstrations** through teleoperation (keyboard, joystick, gamepad, VR) or importing external data
- **Understanding the demonstration dataset format** and how observations and actions are structured
- **Configuring BC training** with appropriate architectures, hyperparameters, and loss functions
- **Using UrbanVerse's IL APIs** for training, inference, and evaluation
- **Best practices** for effective behavior cloning in urban navigation tasks

.. toctree::
   :maxdepth: 1
   :caption: Imitation Learning Guide
   
   introduction
   data_collection
   dataset_format
   training_config
   api_reference
   end_to_end_example
   evaluation
   best_practices

Basic Usage
-----------

The following example demonstrates how to collect demonstrations and train a BC policy:

.. code-block:: python

   import urbanverse as uv

   # 1. Collect expert demonstrations
   demo_dir = uv.navigation.il.collect_data(
       scene_paths=["/path/to/UrbanVerse-160/CapeTown_0001/scene.usd"],
       robot_type="coco_wheeled",
       output_dir="demos/cape_town_teleop",
       control_mode="teleop_gamepad",
       max_episodes=20,
   )

   # 2. Train Behavior Cloning policy
   checkpoint_path = uv.navigation.il.train_bc(
       demo_dir=demo_dir,
       robot_type="coco_wheeled",
       output_dir="outputs/bc_coco_capetown",
   )

   # 3. Load and use the policy
   policy = uv.navigation.il.load_bc_policy(
       checkpoint_path=checkpoint_path,
       robot_type="coco_wheeled",
   )

   # 4. Evaluate the policy
   results = uv.navigation.il.evaluate(
       policy=policy,
       scene_paths=["/path/to/UrbanVerse-160/Tokyo_0001/scene.usd"],
       robot_type="coco_wheeled",
       num_episodes=50,
   )

   print(f"Success Rate: {results['SR']:.2%}")
   print(f"Route Completion: {results['RC']:.2%}")

Benefits of Imitation Learning
--------------------------------

Imitation learning provides several advantages for training navigation policies:

- **Fast bootstrapping**: Learn from expert demonstrations without designing reward functions
- **Real-world data integration**: Incorporate teleoperated demonstrations from actual robot deployments
- **Warm start for RL**: Use BC policies as initialization for reinforcement learning, accelerating training
- **Human-in-the-loop**: Leverage human expertise and intuition for complex navigation scenarios

UrbanVerse's imitation learning framework is designed to work seamlessly with the same scenes, robots, and observation/action spaces used in reinforcement learning, making it easy to combine both approaches.
