.. _urbanverse-robot-learning-il-guide-evaluation:

Evaluating BC Policies
=======================

Evaluation is crucial for understanding how well your behavior cloning policy performs and identifying areas for improvement. UrbanVerse provides comprehensive evaluation tools that compute standard navigation metrics consistent with CraftBench evaluation protocols.

Evaluation Metrics
-------------------

UrbanVerse's evaluation system computes four key metrics that capture different aspects of navigation performance:

Success Rate (SR)
~~~~~~~~~~~~~~~~~~

**Definition**: Fraction of episodes where the robot successfully reaches the goal within the distance threshold.

**Formula**: ``SR = (number of successful episodes) / (total episodes)``

**Interpretation**:
- **High SR (0.7-1.0)**: Policy reliably completes navigation tasks
- **Medium SR (0.4-0.7)**: Policy works but may struggle with some scenarios
- **Low SR (<0.4)**: Policy needs improvement or more training data

**Typical BC Performance**:
- Similar scenes (same city): 50-70% SR
- Different scenes (cross-city): 30-50% SR
- CraftBench (unseen artist scenes): 20-40% SR

Route Completion (RC)
~~~~~~~~~~~~~~~~~~~~~~

**Definition**: Average fraction of the planned route completed before episode termination.

**Formula**: ``RC = mean(completed_distance / total_route_distance)``

**Interpretation**:
- **High RC (0.8-1.0)**: Policy makes significant progress toward goals
- **Medium RC (0.5-0.8)**: Policy gets partway but may struggle with final approach
- **Low RC (<0.5)**: Policy has difficulty making progress

**Why RC Matters**:
RC provides insight into partial success. A policy might have low SR (doesn't reach goals) but high RC (gets close), indicating it needs improvement in final approach rather than overall navigation.

Collision Times (CT)
~~~~~~~~~~~~~~~~~~~~

**Definition**: Average number of collisions per episode.

**Formula**: ``CT = mean(collisions_per_episode)``

**Interpretation**:
- **Low CT (<1.0)**: Policy navigates safely with few collisions
- **Medium CT (1.0-3.0)**: Some collision issues, may need more safety-focused training
- **High CT (>3.0)**: Significant safety concerns

**Note**: CT counts all collisions, including minor contacts. Some policies may have occasional collisions but still achieve good navigation performance.

Distance-to-Goal (DTG)
~~~~~~~~~~~~~~~~~~~~~~~

**Definition**: Average final distance to goal for unsuccessful episodes (in meters).

**Formula**: ``DTG = mean(final_distance_to_goal | episode_not_successful)``

**Interpretation**:
- **Low DTG (<2.0 m)**: Policy gets very close to goals but doesn't quite reach them
- **Medium DTG (2.0-5.0 m)**: Policy makes progress but struggles with final approach
- **High DTG (>5.0 m)**: Policy has difficulty navigating toward goals

**Use Case**: DTG helps diagnose why episodes fail. Low DTG suggests the policy needs better precision, while high DTG indicates fundamental navigation issues.

Running Evaluation
-------------------

Use the ``evaluate`` API to compute all metrics:

.. code-block:: python

   import urbanverse as uv

   # Load your trained policy
   policy = uv.navigation.il.load_bc_policy(
       checkpoint_path="outputs/bc_coco_policy/checkpoints/best.pt",
       robot_type="coco_wheeled",
   )

   # Evaluate on test scenes
   results = uv.navigation.il.evaluate(
       policy=policy,
       scene_paths=[
           "/path/to/CraftBench/scene_001/scene.usd",
           "/path/to/CraftBench/scene_002/scene.usd",
       ],
       robot_type="coco_wheeled",
       num_episodes=100,  # More episodes = more reliable statistics
       max_episode_steps=300,
   )

   # Access individual metrics
   success_rate = results['SR']
   route_completion = results['RC']
   collision_times = results['CT']
   distance_to_goal = results['DTG']

   # Access detailed episode information
   episode_lengths = results['episode_lengths']  # List of episode lengths
   outcomes = results['outcomes']                # List of outcomes

Evaluation Scenarios
--------------------

**In-Distribution Evaluation**  
Evaluate on scenes similar to those used for training:
- Same city layouts (e.g., train on CapeTown, test on different CapeTown scenes)
- Expected: Higher success rates (50-70%)
- Use case: Validate that the policy learned from demonstrations

**Out-of-Distribution Evaluation**  
Evaluate on scenes different from training:
- Different cities (e.g., train on CapeTown, test on Tokyo)
- Expected: Lower success rates (30-50%)
- Use case: Test generalization capabilities

**CraftBench Evaluation**  
Evaluate on artist-crafted test scenes:
- High-fidelity, professionally designed scenes
- Expected: Lower success rates (20-40%) due to domain gap
- Use case: Final policy assessment and benchmarking

Interpreting Results
--------------------

**Good BC Policy Performance:**
- SR > 0.5 on similar scenes
- RC > 0.7 (policy makes good progress)
- CT < 2.0 (relatively safe navigation)
- DTG < 3.0 m for failed episodes (gets close to goals)

**Signs of Overfitting:**
- High SR on training scenes but low SR on test scenes
- Large performance gap between similar and different scenes
- **Solution**: Collect more diverse demonstrations, use data augmentation

**Signs of Underfitting:**
- Low SR across all scenes
- High DTG (policy doesn't make progress toward goals)
- **Solution**: Collect more demonstrations, train for more epochs, check data quality

**Common Issues and Solutions:**

.. list-table:: Common BC Training Issues and Solutions
   :header-rows: 1
   :widths: 25 30 45

   * - Issue
     - Symptom
     - Solution
   * - Insufficient data
     - Low SR, high variance
     - Collect more demonstrations (50+ episodes)
   * - Poor demonstrations
     - Low SR, high CT
     - Improve teleoperation quality, filter bad episodes
   * - Overfitting
     - Large train/test gap
     - Add data augmentation, collect diverse scenes
   * - Action mismatch
     - Policy outputs invalid actions
     - Verify action format matches robot type

Advanced Evaluation
--------------------

**Per-Scene Analysis:**

Evaluate on individual scenes to identify which scenarios are challenging:

.. code-block:: python

   scene_results = {}
   for scene_path in test_scenes:
       results = uv.navigation.il.evaluate(
           policy=policy,
           scene_paths=[scene_path],  # Single scene
           robot_type="coco_wheeled",
           num_episodes=20,
       )
       scene_results[scene_path] = results['SR']
       print(f"{scene_path}: SR = {results['SR']:.2%}")

**Failure Mode Analysis:**

Examine episode outcomes to understand failure patterns:

.. code-block:: python

   results = uv.navigation.il.evaluate(...)
   
   outcomes = results['outcomes']
   num_success = outcomes.count('success')
   num_collision = outcomes.count('collision')
   num_timeout = outcomes.count('timeout')
   
   print(f"Success: {num_success}, Collision: {num_collision}, Timeout: {num_timeout}")

**Comparison with Expert:**

Compare BC policy performance to expert demonstrations:

.. code-block:: python

   # Expert performance (from demonstrations)
   expert_sr = 0.95  # Expert typically succeeds
   
   # BC policy performance
   bc_results = uv.navigation.il.evaluate(...)
   bc_sr = bc_results['SR']
   
   print(f"Expert SR: {expert_sr:.2%}")
   print(f"BC Policy SR: {bc_sr:.2%}")
   print(f"Performance gap: {(expert_sr - bc_sr):.2%}")

A typical performance gap is 20-40%: BC policies learn from demonstrations but don't always match expert performance, especially in challenging scenarios.

The evaluation metrics provide comprehensive insight into policy performance, helping you identify strengths, weaknesses, and areas for improvement in your behavior cloning pipeline.

