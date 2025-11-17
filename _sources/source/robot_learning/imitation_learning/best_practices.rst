.. _urbanverse-robot-learning-il-guide-best-practices:

Best Practices and Tips
========================

This section provides practical guidance for achieving the best results with behavior cloning in UrbanVerse, based on common patterns and lessons learned from training navigation policies.

Data Collection Best Practices
-------------------------------

**Collect Diverse Scenes**  
Avoid overfitting to specific scene layouts by collecting demonstrations across multiple UrbanVerse scenes:

.. code-block:: python

   # Good: Diverse scene collection
   scene_paths = [
       "/path/to/CapeTown_0001/scene.usd",
       "/path/to/Tokyo_0002/scene.usd",
       "/path/to/Beijing_0003/scene.usd",
   ]

   # Avoid: Only one scene type
   scene_paths = ["/path/to/CapeTown_0001/scene.usd"] * 20

**Include Varied Navigation Scenarios**  
Collect demonstrations covering different situations:
- Short-range navigation (5-10 meters)
- Medium-range navigation (10-20 meters)
- Long-range navigation (20+ meters)
- Navigation around obstacles
- Recovery from near-collisions
- Navigation in different lighting conditions (if using multiple scene variants)

**Maintain Consistent Quality**  
While some variation is natural, try to demonstrate:
- Smooth, efficient paths (avoid excessive zigzagging)
- Appropriate speeds for the situation
- Safe navigation behaviors (avoid unnecessary risks)
- Successful goal reaching (aim for 80%+ success in your demonstrations)

**Record Sufficient Data**  
More demonstrations generally lead to better policies:
- **Minimum**: 20 episodes for basic functionality
- **Recommended**: 50-100 episodes for robust performance
- **Optimal**: 100+ episodes for production-quality policies

Training Best Practices
------------------------

**Use Data Augmentation**  
Enable color jitter to improve generalization:

.. code-block:: python

   train_cfg = {
       "data_augmentation": {
           "color_jitter": {
               "brightness": 0.2,
               "contrast": 0.2,
               "saturation": 0.2,
           },
       },
   }

This helps the policy generalize to different lighting conditions and scene appearances.

**Monitor Validation Loss**  
Watch for overfitting by tracking validation loss:

- **Good**: Training and validation loss decrease together
- **Warning**: Training loss decreases but validation loss plateaus or increases
- **Solution**: Reduce model capacity, increase regularization, or collect more data

**Use Early Stopping**  
Enable early stopping to prevent overfitting:

.. code-block:: python

   train_cfg = {
       "early_stopping": True,
       "patience": 10,  # Stop if no improvement for 10 epochs
   }

**Action Smoothing (Optional)**  
If your demonstrations are noisy, enable action smoothing:

.. code-block:: python

   train_cfg = {
       "action_smoothing": True,
       "smoothing_window": 3,  # Smooth over 3 timesteps
   }

This creates smoother policies but may reduce responsiveness.

Robot-Specific Considerations
------------------------------

**COCO Wheeled Robot**

- **Easiest to clone**: Simple 2D action space, stable dynamics
- **Recommended for beginners**: Start with COCO to learn the BC workflow
- **Typical performance**: 60-80% SR on similar scenes

**Unitree Go2 (Quadruped)**

- **Moderate difficulty**: More complex action space, but stable locomotion
- **Considerations**: Joint velocity commands require more precise demonstrations
- **Typical performance**: 50-70% SR on similar scenes

**Unitree G1 / Booster T1 (Humanoid)**

- **Most challenging**: Complex high-dimensional action space, delicate balance
- **Recommendations**:

  - Collect more demonstrations (100+ episodes)
  - Use longer training (100+ epochs)
  - Consider using Gaussian policy for uncertainty

- **Typical performance**: 30-50% SR on similar scenes

**General Rule**: Simpler robots (wheeled) are easier to clone than complex robots (humanoids). Start with simpler robots to build intuition, then progress to more complex platforms.

Combining BC with RL
---------------------

**BC as Warm Start for RL**  
One of the most effective strategies is to use BC for initialization, then fine-tune with RL:

1. **Train BC policy** on expert demonstrations
2. **Initialize RL policy** with BC weights
3. **Fine-tune with RL** to improve beyond expert performance

This hybrid approach combines the efficiency of imitation learning with the robustness of reinforcement learning.

**Example Workflow:**

.. code-block:: python

   # Step 1: Train BC
   bc_checkpoint = uv.navigation.il.train_bc(...)
   
   # Step 2: Initialize RL from BC
   rl_cfg = EnvCfg(...)
   rl_cfg.policy.init_from_bc = bc_checkpoint  # Initialize from BC
   
   # Step 3: Fine-tune with RL
   uv.navigation.rl.train(env=env, training_cfg=rl_cfg, ...)

**Benefits:**

- Faster RL convergence (starts from good policy)
- Better final performance (combines expert knowledge with exploration)
- More sample-efficient (less RL training needed)

Debugging Tips
--------------

**Check Data Quality**  
Visualize your demonstrations to ensure they're reasonable:

.. code-block:: python

   import numpy as np
   import matplotlib.pyplot as plt

   obs = np.load("demos/episode_000/obs.npy")
   act = np.load("demos/episode_000/act.npy")
   
   # Plot action distribution
   plt.hist(act[:, 0], bins=50, alpha=0.5, label='Linear velocity')
   plt.hist(act[:, 1], bins=50, alpha=0.5, label='Angular velocity')
   plt.legend()
   plt.show()

**Monitor Training Progress**  
Use TensorBoard to track training:

.. code-block:: bash

   tensorboard --logdir outputs/bc_policy/logs/tensorboard

Watch for:
- Decreasing training loss
- Stable or decreasing validation loss
- No signs of overfitting

**Test on Simple Scenes First**  
Start evaluation on simpler scenes to verify basic functionality before testing on complex scenarios.

**Compare to Random Policy**  
Ensure your BC policy performs better than random actions:

.. code-block:: python

   # Random policy baseline
   random_sr = 0.05  # ~5% success rate for random
   bc_sr = results['SR']
   
   if bc_sr < random_sr * 2:
       print("Warning: BC policy not significantly better than random!")

