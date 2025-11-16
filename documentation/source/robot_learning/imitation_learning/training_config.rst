.. _urbanverse-robot-learning-il-guide-training-config:

BC Training Configuration
==========================

Behavior cloning training involves configuring the neural network architecture, training hyperparameters, and loss functions. UrbanVerse provides sensible defaults aligned with best practices, while allowing full customization for specialized use cases.

Model Architecture
-------------------

UrbanVerse's BC policy network is designed specifically for goal-directed navigation, combining visual perception with spatial awareness.

Architecture Overview
~~~~~~~~~~~~~~~~~~~~~~

The BC policy network consists of three main components:

**1. Visual Encoder (CNN)**  
Processes RGB camera images to extract visual features:
- Convolutional layers for spatial feature extraction
- Batch normalization and ReLU activations
- Output: Compact visual feature vector

**2. Goal Vector Processor (MLP)**  
Processes the goal-relative position vector:
- Small fully-connected network
- Output: Processed goal representation

**3. Policy Head (MLP)**  
Combines visual and goal features to predict actions:
- Concatenates visual features + goal features + optional robot state
- 2-layer MLP with ReLU activations
- Output: Action predictions (deterministic or Gaussian)

**Architecture Diagram:**

.. code-block:: text

   RGB Image (135×240×3)
        ↓
   [CNN Encoder]
        ↓
   Visual Features (256-dim)
        ↓
   ┌─────────────────┐
   │  Concatenate    │
   └─────────────────┘
        ↓
   [MLP Policy Head]
        ↓
   Actions (action_dim)

   Goal Vector (2-dim)
        ↓
   [MLP Processor]
        ↓
   Goal Features (64-dim)

Default Architecture Specifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Visual Encoder:**
- Input: RGB image (135×240×3)
- Architecture: ResNet-style CNN with 4-5 convolutional blocks
- Output dimension: 256 features

**Goal Processor:**
- Input: Goal vector (2-dim)
- Architecture: 2-layer MLP (64 hidden units)
- Output dimension: 64 features

**Policy Head:**
- Input: Concatenated features (256 + 64 + robot_state_dim)
- Architecture: 2-layer MLP (256 hidden units, ReLU)
- Output: Action predictions (deterministic or Gaussian)

**Action Output:**
- **Deterministic**: Direct action predictions (default for most robots)
- **Gaussian**: Mean and variance predictions (useful for uncertainty estimation)

Training Hyperparameters
-------------------------

UrbanVerse provides default hyperparameters that work well for most navigation tasks:

Default Configuration
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   train_cfg = {
       "learning_rate": 1e-4,           # Adam optimizer learning rate
       "batch_size": 256,               # Training batch size
       "train_epochs": 50,              # Number of training epochs
       "weight_decay": 1e-5,            # L2 regularization
       "action_smoothing": False,       # Optional action smoothing
       "dropout": 0.1,                  # Dropout rate (if enabled)
       "validation_split": 0.1,         # Fraction of data for validation
       "early_stopping": True,          # Stop if validation loss plateaus
       "data_augmentation": {
           "random_crop": False,
           "color_jitter": True,
           "horizontal_flip": False,
       },
   }

Hyperparameter Descriptions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Learning Rate** (``learning_rate=1e-4``)  
Controls how quickly the model updates during training. Lower values (1e-5) provide more stable training but slower convergence. Higher values (1e-3) can speed up training but risk instability.

**Batch Size** (``batch_size=256``)  
Number of (observation, action) pairs processed together. Larger batches provide more stable gradients but require more memory. Smaller batches (128) can improve generalization but slow training.

**Training Epochs** (``train_epochs=50-100``)  
Number of complete passes through the dataset. More epochs can improve performance but risk overfitting. Monitor validation loss to determine optimal stopping point.

**Weight Decay** (``weight_decay=1e-5``)  
L2 regularization to prevent overfitting. Higher values (1e-4) provide stronger regularization but may underfit. Lower values (1e-6) allow more model flexibility.

**Action Smoothing** (``action_smoothing=False``)  
Optional temporal smoothing of expert actions to reduce noise and create smoother policies. Useful when demonstrations are noisy.

**Dropout** (``dropout=0.1``)  
Randomly zeroes a fraction of activations during training to prevent overfitting. Typically applied to fully-connected layers.

Loss Function
--------------

UrbanVerse uses Mean Squared Error (MSE) loss for continuous action spaces:

**MSE Loss (Default):**

.. code-block:: python

   loss = MSE(predicted_actions, expert_actions)
   
   # For each timestep:
   loss_t = mean((predicted_action - expert_action)²)

This loss function works well for deterministic action prediction and is the standard choice for behavior cloning.

**Gaussian Policy Loss (Optional):**

For uncertainty-aware policies, you can use a Gaussian policy that predicts both mean and variance:

.. code-block:: python

   # Policy outputs: (mean, log_std)
   loss = -log_prob(expert_action | mean, std)
   
   # Negative log-likelihood of expert action under predicted distribution

This approach provides uncertainty estimates and can improve robustness, especially when demonstrations have natural variability.

Data Augmentation
------------------

Data augmentation can improve generalization by creating variations of training data:

**Supported Augmentations:**

- **Color Jitter**: Random brightness, contrast, saturation adjustments
- **Random Crop**: Crop and resize images (use with caution for navigation)
- **Horizontal Flip**: Mirror images (not recommended for goal navigation due to goal vector asymmetry)

**Example Configuration:**

.. code-block:: python

   train_cfg = {
       "data_augmentation": {
           "color_jitter": {
               "brightness": 0.2,
               "contrast": 0.2,
               "saturation": 0.2,
           },
           "random_crop": False,  # Usually disabled for navigation
           "horizontal_flip": False,  # Disabled (goal vector not symmetric)
       },
   }

Training Process
----------------

The BC training process follows a standard supervised learning workflow:

1. **Data Loading**: Load demonstration episodes, split into train/validation sets
2. **Batch Sampling**: Sample random batches of (observation, action) pairs
3. **Forward Pass**: Predict actions from observations
4. **Loss Computation**: Compare predictions to expert actions
5. **Backward Pass**: Update network weights via gradient descent
6. **Validation**: Evaluate on held-out validation set
7. **Checkpointing**: Save model checkpoints periodically

Training typically runs for 50-100 epochs, with early stopping if validation loss plateaus.

Customizing Training Configuration
-----------------------------------

You can customize any aspect of the training configuration:

.. code-block:: python

   custom_train_cfg = {
       "learning_rate": 5e-5,      # Slower learning
       "batch_size": 128,          # Smaller batches
       "train_epochs": 100,        # More epochs
       "weight_decay": 1e-4,       # Stronger regularization
       "action_smoothing": True,   # Enable smoothing
       "dropout": 0.2,             # Higher dropout
   }

   checkpoint = uv.navigation.il.train_bc(
       demo_dir="demos/my_demos",
       robot_type="coco_wheeled",
       output_dir="outputs/bc_custom",
       train_cfg=custom_train_cfg,
   )

The training configuration system is flexible, allowing you to experiment with different architectures, hyperparameters, and training strategies to optimize performance for your specific use case.

