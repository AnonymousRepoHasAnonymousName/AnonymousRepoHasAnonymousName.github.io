.. _urbanverse-robot-learning-il-guide-end-to-end:

End-to-End Example
===================

This section provides a complete, working example that demonstrates the full imitation learning workflow in UrbanVerse: from collecting demonstrations to training a BC policy and evaluating its performance.

Example Scenario
-----------------

We'll train a behavior cloning policy for a COCO wheeled robot to navigate in UrbanVerse-160 scenes. The workflow includes:

1. Collecting 20 expert demonstrations in Cape Town scenes
2. Training a BC policy on the collected data
3. Evaluating the trained policy on Tokyo scenes (unseen during training)
4. Analyzing the results

Step 1: Collect Expert Demonstrations
--------------------------------------

First, we collect demonstrations by teleoperating the robot:

.. code-block:: python

   import urbanverse as uv
   import os

   # Set up scene paths
   scene_root = os.environ.get("URBANVERSE_SCENE_ROOT", "/path/to/UrbanVerse-160")
   
   scene_paths = [
       f"{scene_root}/Africa_SouthAfrica_CapeTown_0001/scene.usd",
       f"{scene_root}/Africa_SouthAfrica_CapeTown_0002/scene.usd",
       f"{scene_root}/Africa_SouthAfrica_CapeTown_0003/scene.usd",
   ]

   # Collect demonstrations
   print("Starting data collection...")
   print("Use your gamepad to control the robot. Navigate to the goal positions.")
   print("Press 'A' button to end each episode and start the next one.")
   
   demo_dir = uv.navigation.il.collect_data(
       scene_paths=scene_paths,
       robot_type="coco_wheeled",
       output_dir="demos/capetown_bc_demos",
       control_mode="teleop_gamepad",
       max_episodes=20,
       episode_length=300,
       goal_sampling="random",
   )

   print(f"✓ Collected {20} demonstration episodes")
   print(f"✓ Data saved to: {demo_dir}")

**Tips for Data Collection:**
- Navigate smoothly and efficiently to goals
- Include some recovery behaviors (e.g., backing up from obstacles)
- Try to demonstrate diverse navigation scenarios
- Aim for a mix of short and long-range navigation

Step 2: Train Behavior Cloning Policy
--------------------------------------

Now we train a BC policy on the collected demonstrations:

.. code-block:: python

   import urbanverse as uv

   # Configure training
   train_cfg = {
       "learning_rate": 1e-4,
       "batch_size": 256,
       "train_epochs": 50,
       "weight_decay": 1e-5,
       "validation_split": 0.1,
       "early_stopping": True,
       "data_augmentation": {
           "color_jitter": True,
       },
   }

   print("Starting BC training...")
   checkpoint_path = uv.navigation.il.train_bc(
       demo_dir="demos/capetown_bc_demos",
       robot_type="coco_wheeled",
       output_dir="outputs/bc_coco_capetown",
       train_cfg=train_cfg,
   )

   print(f"✓ Training complete!")
   print(f"✓ Best model saved to: {checkpoint_path}")

**Training Output:**
The training process will display progress information:
- Training loss and validation loss per epoch
- Training time and estimated completion
- Best model checkpoint path

You can monitor training progress using TensorBoard:

.. code-block:: bash

   tensorboard --logdir outputs/bc_coco_capetown/logs/tensorboard

Step 3: Evaluate the Trained Policy
------------------------------------

Evaluate the BC policy on unseen Tokyo scenes to test generalization:

.. code-block:: python

   import urbanverse as uv

   # Load the trained policy
   policy = uv.navigation.il.load_bc_policy(
       checkpoint_path="outputs/bc_coco_capetown/checkpoints/best.pt",
       robot_type="coco_wheeled",
   )

   # Prepare test scenes (different from training scenes)
   scene_root = os.environ.get("URBANVERSE_SCENE_ROOT")
   test_scenes = [
       f"{scene_root}/Asia_Japan_Tokyo_0001/scene.usd",
       f"{scene_root}/Asia_Japan_Tokyo_0002/scene.usd",
   ]

   # Evaluate
   print("Evaluating BC policy on Tokyo scenes...")
   results = uv.navigation.il.evaluate(
       policy=policy,
       scene_paths=test_scenes,
       robot_type="coco_wheeled",
       num_episodes=50,
       max_episode_steps=300,
   )

   # Print results
   print("\n" + "="*50)
   print("Evaluation Results")
   print("="*50)
   print(f"Success Rate (SR):        {results['SR']:.2%}")
   print(f"Route Completion (RC):    {results['RC']:.2%}")
   print(f"Collision Times (CT):     {results['CT']:.2f}")
   print(f"Distance-to-Goal (DTG):   {results['DTG']:.2f} m")
   print("="*50)

**Expected Results:**
- BC policies typically achieve **50-70% success rate** on similar scenes
- Performance may drop to **30-50%** on significantly different scenes (cross-city evaluation)
- Route completion is usually higher than success rate (policies often get close but don't reach the goal)

Step 4: Deploy the Policy
--------------------------

Use the trained policy for autonomous navigation:

.. code-block:: python

   import urbanverse as uv
   from urbanverse.navigation.config import EnvCfg, SceneCfg

   # Load policy
   policy = uv.navigation.il.load_bc_policy(
       checkpoint_path="outputs/bc_coco_capetown/checkpoints/best.pt",
       robot_type="coco_wheeled",
   )

   # Create environment
   cfg = EnvCfg(
       scenes=SceneCfg(
           scene_paths=["/path/to/UrbanVerse-160/CapeTown_0001/scene.usd"],
           async_sim=False,
       ),
       robot_type="coco_wheeled",
       ...
   )

   env = uv.navigation.rl.create_env(cfg)

   # Run policy
   obs = env.reset()
   for step in range(300):
       action = policy(obs)  # BC policy prediction
       obs, reward, done, info = env.step(action)
       
       if done:
           print(f"Episode ended: {info.get('outcome', 'unknown')}")
           obs = env.reset()

Complete Script
---------------

Here's the complete end-to-end script combining all steps:

.. code-block:: python

   """
   Complete BC Training and Evaluation Example
   """
   import urbanverse as uv
   import os

   # Configuration
   SCENE_ROOT = os.environ.get("URBANVERSE_SCENE_ROOT", "/path/to/UrbanVerse-160")
   ROBOT_TYPE = "coco_wheeled"
   
   # Step 1: Collect demonstrations
   print("="*60)
   print("Step 1: Collecting Expert Demonstrations")
   print("="*60)
   
   train_scenes = [
       f"{SCENE_ROOT}/Africa_SouthAfrica_CapeTown_{i:04d}/scene.usd"
       for i in range(1, 4)
   ]
   
   demo_dir = uv.navigation.il.collect_data(
       scene_paths=train_scenes,
       robot_type=ROBOT_TYPE,
       output_dir="demos/capetown_bc",
       control_mode="teleop_gamepad",
       max_episodes=20,
   )
   
   # Step 2: Train BC policy
   print("\n" + "="*60)
   print("Step 2: Training BC Policy")
   print("="*60)
   
   checkpoint = uv.navigation.il.train_bc(
       demo_dir=demo_dir,
       robot_type=ROBOT_TYPE,
       output_dir="outputs/bc_coco_capetown",
   )
   
   # Step 3: Evaluate
   print("\n" + "="*60)
   print("Step 3: Evaluating BC Policy")
   print("="*60)
   
   policy = uv.navigation.il.load_bc_policy(
       checkpoint_path=checkpoint,
       robot_type=ROBOT_TYPE,
   )
   
   test_scenes = [
       f"{SCENE_ROOT}/Asia_Japan_Tokyo_{i:04d}/scene.usd"
       for i in range(1, 3)
   ]
   
   results = uv.navigation.il.evaluate(
       policy=policy,
       scene_paths=test_scenes,
       robot_type=ROBOT_TYPE,
       num_episodes=50,
   )
   
   # Step 4: Print summary
   print("\n" + "="*60)
   print("Final Results")
   print("="*60)
   print(f"Success Rate:      {results['SR']:.2%}")
   print(f"Route Completion:  {results['RC']:.2%}")
   print(f"Collision Times:   {results['CT']:.2f}")
   print(f"Distance-to-Goal:  {results['DTG']:.2f} m")
   print("="*60)

Running the Example
--------------------

Save the script above as ``train_bc_example.py`` and run:

.. code-block:: bash

   # Set environment variable
   export URBANVERSE_SCENE_ROOT=/path/to/UrbanVerse-160

   # Run the example
   python train_bc_example.py

The script will guide you through data collection (you'll need to teleoperate the robot), then automatically train and evaluate the policy.

Next Steps
----------

After training a BC policy, you can:

- **Fine-tune with RL**: Use the BC policy as initialization for reinforcement learning (see :doc:`../reinforcement_learning/index`)
- **Collect more data**: Expand your demonstration dataset to improve performance
- **Evaluate on CraftBench**: Test your policy on the artist-crafted test scenes
- **Deploy in simulation**: Use the policy for autonomous navigation tasks

The next section covers evaluation in more detail, including metrics interpretation and best practices for assessing BC policy performance.

