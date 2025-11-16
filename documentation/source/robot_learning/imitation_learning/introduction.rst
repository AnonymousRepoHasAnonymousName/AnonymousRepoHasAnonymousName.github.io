.. _urbanverse-robot-learning-il-guide-introduction:

Introduction to Imitation Learning
===================================

Imitation learning is a powerful paradigm for training navigation policies by learning directly from expert demonstrations, rather than through trial-and-error reinforcement learning. In UrbanVerse, imitation learning enables you to bootstrap navigation policies quickly, incorporate real-world teleoperation data, and create effective warm starts for RL fine-tuning.

What is Imitation Learning?
----------------------------

Imitation learning trains a policy to mimic expert behavior by learning a mapping from observations to actions. Given a dataset of expert demonstrations—sequences of (observation, action) pairs showing how an expert navigates to goals—the policy learns to predict the expert's actions in similar situations.

For goal-directed navigation in UrbanVerse, this means:
- **Input**: Current observation (RGB camera image + goal vector) + robot state
- **Output**: Action prediction (velocity commands, joint controls, etc.)
- **Learning objective**: Minimize the difference between predicted actions and expert actions

Behavior Cloning (BC) in UrbanVerse
------------------------------------

UrbanVerse implements **Behavior Cloning**, a straightforward form of imitation learning that treats the problem as supervised learning:

1. **Collect demonstrations**: Record expert trajectories showing successful navigation to goals
2. **Train a policy**: Use supervised learning to predict expert actions from observations
3. **Deploy the policy**: Use the trained policy for autonomous navigation

The key advantage of BC is its simplicity: it's essentially a regression problem where the policy learns to map observations to actions by minimizing prediction error on the demonstration dataset.

Benefits of Imitation Learning in UrbanVerse
---------------------------------------------

**Low-Cost Bootstrapping**  
Unlike RL, which requires extensive exploration and reward engineering, BC can quickly learn basic navigation behaviors from a relatively small number of expert demonstrations. This makes it ideal for getting started with navigation tasks or prototyping new robot platforms.

**Learning from Teleoperation**  
UrbanVerse supports collecting demonstrations through various teleoperation interfaces (keyboard, joystick, gamepad, VR). This allows you to leverage human expertise and intuition, capturing navigation strategies that might be difficult to encode in reward functions.

**Fast Warm-Start for RL Fine-Tuning**  
BC policies trained on expert demonstrations provide excellent initialization for reinforcement learning. Starting RL training from a BC policy (rather than random initialization) can dramatically accelerate convergence and improve final performance. This hybrid approach combines the efficiency of imitation learning with the robustness of reinforcement learning.

**Real-World Data Integration**  
You can import demonstrations collected from real-world robot deployments and convert them into UrbanVerse's format. This enables training policies that incorporate real-world navigation behaviors, sensor characteristics, and environmental conditions.

Supported Robot Types
---------------------

UrbanVerse's imitation learning framework supports all robot embodiments available in the platform:

**Wheeled Robots:**
- **COCO Wheeled** (``coco_wheeled``): 2D velocity commands (linear, angular)
- **NVIDIA Carter** (``nvidia_carter``): 3D velocity commands (vx, vy, yaw-rate)
- **TurtleBot3** (``turtlebot3``): Differential drive velocity commands

**Legged Robots:**
- **Unitree Go2** (``unitree_go2``): Joint velocity commands or high-level velocity
- **ANYmal** (``anymal``): Joint-based controls

**Humanoid Robots:**
- **Unitree G1** (``unitree_g1``): Joint-angle or torque-based controls
- **Booster T1** (``booster_t1``): Advanced joint-level controls

The BC training pipeline automatically adapts to each robot's action space, ensuring that the learned policy outputs actions in the correct format for the target robot.

When to Use Imitation Learning vs. Reinforcement Learning
----------------------------------------------------------

**Choose Imitation Learning when:**
- You have access to expert demonstrations (teleoperation, scripted controllers, or pre-trained policies)
- You need to quickly bootstrap a working policy
- You want to incorporate real-world navigation data
- You're prototyping or exploring new navigation scenarios

**Choose Reinforcement Learning when:**
- You need policies that exceed expert performance
- You want to learn robust behaviors through extensive exploration
- You're working on long-horizon tasks requiring complex planning
- You need policies that generalize to scenarios not seen in demonstrations

**Best of Both Worlds:**
Many successful navigation systems combine both approaches: use BC for initial policy learning, then fine-tune with RL to improve robustness and performance beyond the expert demonstrations.

The following sections guide you through the complete imitation learning workflow in UrbanVerse, from data collection to policy deployment.

