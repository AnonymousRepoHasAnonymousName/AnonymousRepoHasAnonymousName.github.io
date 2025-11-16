.. _urbanverse-robot-learning-rl-guide-curriculum:

Progressive Learning: Curriculum Strategies
============================================

Curriculum learning gradually increases task difficulty as your policy improves, accelerating training and often leading to better final performance. UrbanVerse provides built-in curriculum mechanisms that automatically scale navigation challenges, helping your policy learn basic behaviors before tackling complex scenarios.

Why Use Curriculum Learning?
-----------------------------

Training a navigation policy from scratch in complex urban environments can be challenging. Starting with nearby goals and simple scenarios, then progressively expanding to long-range navigation across diverse scenes, helps the policy:
- **Learn fundamental skills first** (basic obstacle avoidance, goal following)
- **Build confidence** before facing harder challenges
- **Converge faster** by focusing on achievable tasks early in training
- **Achieve better final performance** through structured skill development

Curriculum Configuration
-------------------------

Enable curriculum learning with simple boolean flags:

.. code-block:: python

   from urbanverse.navigation.config import EnvCfg, CurriculumCfg
   import urbanverse as uv

   cfg = EnvCfg(
       robot_type="coco_wheeled",
       curriculum=CurriculumCfg(
           enable_goal_distance_curriculum=True,  # Expand goal distances over time
           enable_cousin_jitter=True,             # Increase scene diversity gradually
       ),
       ...
   )

Built-in Curriculum Strategies
-------------------------------

UrbanVerse offers two primary curriculum mechanisms:

**Goal Distance Curriculum**  
Starts training with nearby goals (e.g., 5-10 meters away) and gradually expands the maximum goal distance as training progresses. Early episodes focus on short-range navigation where the policy can easily see and reach the goal. As the policy improves, goals become progressively more distant, requiring longer-range planning and navigation skills.

This curriculum helps the policy:
- Master basic obstacle avoidance and goal-following on short paths
- Develop path planning skills for medium-range navigation
- Learn to navigate efficiently over long distances

**Cousin Jitter Curriculum**  
Gradually increases the diversity of scene appearances (digital cousins) used during training. Early training might focus on a smaller set of cousin variants, providing visual consistency that helps the policy learn geometric navigation. As training progresses, more diverse cousins are introduced, improving the policy's robustness to visual variations.

This curriculum helps the policy:
- Learn navigation patterns that generalize across visual appearances
- Develop robustness to different asset placements and textures
- Adapt to varying lighting and scene conditions

How Curriculum Updates Work
----------------------------

Curriculum parameters are updated automatically during training:

1. **Periodic Evaluation**: Every N training iterations, the curriculum manager evaluates the current training progress

2. **Difficulty Adjustment**: Based on performance metrics (e.g., success rate, average episode length), curriculum parameters are adjusted:
   - Goal distances expand if the policy is succeeding consistently
   - Scene diversity increases if the policy is performing well

3. **Next Episode Application**: Changes take effect at the next episode reset, ensuring smooth transitions

4. **Automatic Scaling**: The curriculum automatically scales difficulty to match the policy's learning progress

Example: Goal Distance Progression
-----------------------------------

Here's how goal distance curriculum typically progresses:

- **Iterations 0-10K**: Goals within 5-15 meters (short-range navigation)
- **Iterations 10K-50K**: Goals within 15-30 meters (medium-range navigation)  
- **Iterations 50K+**: Goals within 30-50+ meters (long-range navigation)

The exact progression depends on your policy's learning speed and the curriculum schedule configuration.

Customizing Curriculum
-----------------------

While the built-in curricula work well for most cases, you can customize them:

**Adjust Curriculum Schedule**  
Modify how quickly difficulty increases (linear, exponential, or custom schedules)

**Add Custom Curriculum Terms**  
Implement your own curriculum strategies:
- Gradually increase obstacle density
- Progressively introduce more dynamic agents (pedestrians, vehicles)
- Vary lighting conditions over time
- Adjust terrain difficulty

**Disable Curriculum**  
For fixed-difficulty training, disable curriculum learning:

.. code-block:: python

   CurriculumCfg(
       enable_goal_distance_curriculum=False,  # Fixed goal distances
       enable_cousin_jitter=False,             # Fixed scene appearance
   )

Best Practices
--------------

- **Start with curriculum enabled**: It typically accelerates training and improves results
- **Monitor curriculum progression**: Ensure difficulty increases at an appropriate rate
- **Combine with other techniques**: Curriculum works well with domain randomization and reward shaping
- **Adjust based on performance**: If the policy struggles, slow down curriculum progression
- **Use for complex tasks**: Curriculum is especially valuable for long-range navigation and diverse scene training

Curriculum learning is optional but highly recommended, especially when training policies for challenging navigation tasks in diverse urban environments. It's one of the most effective techniques for improving both training efficiency and final policy performance.
