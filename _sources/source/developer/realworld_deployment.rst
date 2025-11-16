.. _urbanverse-developer-realworld-deployment:

Real-world Deployment: Unitree Go2 Quadruped Example
====================================================

This guide explains how to deploy trained UrbanVerse navigation policies to real-world robots. We use Unitree Go2 as a concrete example, demonstrating the deployment pipeline where policy inference runs on a laptop with GPU and communicates with the robot over WiFi or Ethernet using the Unitree Go2 SDK.

Overview
---------

Deploying UrbanVerse policies to real robots involves a distributed architecture where:

1. **Policy Inference**: Runs on a laptop/desktop with GPU for efficient neural network inference
2. **Robot Communication**: Laptop communicates with the robot via WiFi or Ethernet connection
3. **Sensor Data Streaming**: Robot streams sensor data (camera, IMU, joint states) to the laptop
4. **Command Transmission**: Laptop sends control commands back to the robot
5. **Low-Level Control**: Robot executes commands using onboard PD controllers

This architecture separates computationally intensive policy inference (on GPU-equipped laptop) from real-time robot control (on robot hardware), enabling efficient deployment while maintaining low-latency communication.

Deployment Architecture
------------------------

The deployment follows a client-server model:

.. code-block:: text

   Laptop (GPU)                    Go2 Robot
   ┌─────────────┐                ┌─────────────┐
   │             │                │             │
   │ Policy      │  WiFi/Ethernet │ Sensors     │
   │ Inference   │◄───────────────┤ (Camera,    │
   │ (GPU)       │                │  IMU, etc.) │
   │             │                │             │
   │ PD          │  WiFi/Ethernet │ Actuators   │
   │ Controller  │───────────────►│ (Motors)    │
   │             │                │             │
   └─────────────┘                └─────────────┘

The laptop handles:
- Policy inference (neural network forward pass)
- High-level navigation decisions
- PD controller computation
- Sensor data processing

The robot handles:
- Sensor data acquisition and streaming
- Low-level motor control
- Safety monitoring

Prerequisites
-------------

Before deploying to real robots, ensure you have:

**Laptop/Desktop Requirements:**
- GPU (NVIDIA GPU recommended for efficient inference)
- Python 3.8+ with UrbanVerse installed
- Unitree Go2 SDK Python package (``unitree_go2_sdk``)
- Network interface (WiFi or Ethernet) for robot communication

**Robot Requirements:**
- Unitree Go2 robot powered on and ready
- Network connectivity (WiFi or Ethernet) to laptop
- Robot IP address (default: 192.168.123.15)

**Network Setup:**
- Laptop and robot on the same network (WiFi or Ethernet)
- Network latency < 50ms for real-time control
- Sufficient bandwidth for sensor data streaming (camera images, IMU, joint states)

Unitree Go2 Deployment Example
-------------------------------

This section provides a complete example for deploying UrbanVerse policies to Unitree Go2 quadruped robots.

Policy Export
~~~~~~~~~~~~~~

Export the trained policy for deployment:

.. code-block:: python

   import urbanverse as uv
   import torch

   # Load trained policy
   policy = uv.navigation.rl.load_policy(
       checkpoint_path="outputs/my_policy/checkpoints/best.pt",
       robot_type="unitree_go2",
   )

   # Export for deployment
   uv.deployment.export_policy(
       policy=policy,
       output_path="deployment/go2_policy.pt",
       format="torchscript",  # or "onnx" for ONNX format
       optimize=True,
   )

Unitree Go2 SDK Integration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Unitree Go2 SDK provides direct access to robot sensors and actuators. This section demonstrates how to integrate the SDK with UrbanVerse policies.

Network Connection Setup
~~~~~~~~~~~~~~~~~~~~~~~~~

Before connecting to the robot, ensure network connectivity:

**WiFi Connection:**
- Connect laptop to Go2's WiFi network (or connect both to the same WiFi network)
- Verify robot IP address (default: 192.168.123.15)
- Test connectivity: ``ping 192.168.123.15``

**Ethernet Connection:**
- Connect laptop to Go2 via Ethernet cable
- Configure laptop network interface (may need static IP configuration)
- Verify connectivity: ``ping 192.168.123.15``

Initializing Go2 SDK Connection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Connect to the Go2 robot over the network using the SDK:

.. code-block:: python

   # deployment/go2_sdk_setup.py
   from unitree_go2_sdk import Go2SDK
   import numpy as np
   import socket

   class Go2RobotInterface:
       """Interface for Unitree Go2 robot using SDK over network."""
       
       def __init__(self, robot_ip: str = "192.168.123.15"):
           """Initialize network connection to Go2 robot.
           
           Args:
               robot_ip: IP address of the Go2 robot (default: 192.168.123.15)
           """
           self.robot_ip = robot_ip
           
           # Verify network connectivity
           if not self._check_connectivity(robot_ip):
               raise ConnectionError(f"Cannot reach Go2 robot at {robot_ip}. Check network connection.")
           
           # Initialize SDK connection over network
           self.sdk = Go2SDK(robot_ip)
           
           # Connect to robot (establishes network connection)
           self.sdk.connect()
           
           # Robot state variables
           self.imu_data = None
           self.joint_states = None
           self.camera_image = None
           self.odometry = None
           
           print(f"Connected to Go2 at {robot_ip} over network")
       
       def _check_connectivity(self, ip: str, port: int = 8080, timeout: float = 2.0) -> bool:
           """Check if robot is reachable over network.
           
           Args:
               ip: Robot IP address
               port: Robot communication port
               timeout: Connection timeout in seconds
           
           Returns:
               True if robot is reachable, False otherwise
           """
           try:
               sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
               sock.settimeout(timeout)
               result = sock.connect_ex((ip, port))
               sock.close()
               return result == 0
           except Exception:
               return False
       
       def get_sensor_data(self):
           """Get current sensor data from robot over network.
           
           Sensor data is streamed from the robot to the laptop in real-time.
           
           Returns:
               Dictionary containing all sensor data
           """
           # Get IMU data (streamed from robot)
           # Network latency: typically < 10ms
           self.imu_data = self.sdk.get_imu_data()
           
           # Get joint states (streamed from robot)
           # Network latency: typically < 10ms
           self.joint_states = self.sdk.get_joint_states()
           
           # Get camera image (streamed from robot)
           # Network latency: typically 20-50ms depending on image size
           self.camera_image = self.sdk.get_camera_image()
           
           # Get odometry (streamed from robot)
           # Network latency: typically < 10ms
           self.odometry = self.sdk.get_odometry()
           
           return {
               "imu": self.imu_data,
               "joints": self.joint_states,
               "camera": self.camera_image,
               "odometry": self.odometry,
           }
       
       def send_locomotion_command(self, linear_vel: float, angular_vel: float):
           """Send high-level locomotion command to robot over network.
           
           Commands are transmitted from laptop to robot via WiFi/Ethernet.
           
           Args:
               linear_vel: Linear velocity command (m/s)
               angular_vel: Angular velocity command (rad/s)
           """
           # Send command to robot over network
           # Network latency: typically < 10ms
           self.sdk.set_locomotion_velocity(linear_vel, angular_vel)
       
       def send_joint_torques(self, torques: np.ndarray):
           """Send joint torques to robot over network.
           
           Args:
               torques: Joint torques array (12,) in Nm
           """
           # Send torques to robot over network
           # Network latency: typically < 10ms
           self.sdk.set_joint_torques(torques)
       
       def disconnect(self):
           """Disconnect from robot."""
           self.sdk.disconnect()
           print("Disconnected from Go2")

Getting Sensor Input
~~~~~~~~~~~~~~~~~~~~~

The Go2 SDK provides access to various sensors. Here's how to retrieve sensor data:

.. code-block:: python

   # Get IMU data
   imu_data = robot_interface.sdk.get_imu_data()
   # Returns: {
   #     "quaternion": [w, x, y, z],  # Orientation quaternion
   #     "angular_velocity": [wx, wy, wz],  # Angular velocity (rad/s)
   #     "linear_acceleration": [ax, ay, az],  # Linear acceleration (m/s²)
   # }

   # Get joint states
   joint_states = robot_interface.sdk.get_joint_states()
   # Returns: {
   #     "position": [q0, q1, ..., q11],  # Joint positions (rad)
   #     "velocity": [dq0, dq1, ..., dq11],  # Joint velocities (rad/s)
   #     "torque": [tau0, tau1, ..., tau11],  # Joint torques (Nm)
   # }

   # Get camera image
   camera_image = robot_interface.sdk.get_camera_image()
   # Returns: numpy array of shape (H, W, 3) - RGB image

   # Get odometry
   odometry = robot_interface.sdk.get_odometry()
   # Returns: {
   #     "position": [x, y, z],  # Position in world frame (m)
   #     "orientation": [w, x, y, z],  # Orientation quaternion
   #     "linear_velocity": [vx, vy, vz],  # Linear velocity (m/s)
   #     "angular_velocity": [wx, wy, wz],  # Angular velocity (rad/s)
   # }

PD Controller Implementation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A PD (Proportional-Derivative) controller is used for low-level joint control, converting high-level velocity commands into joint torques:

.. code-block:: python

   class PDController:
       """PD controller for Go2 joint-level control."""
       
       def __init__(self, kp: float = 40.0, kd: float = 0.5):
           """Initialize PD controller.
           
           Args:
               kp: Proportional gain
               kd: Derivative gain
           """
           self.kp = kp
           self.kd = kd
           
           # Target joint positions (from inverse kinematics or gait generator)
           self.target_positions = np.zeros(12)
           self.target_velocities = np.zeros(12)
           
           # Previous joint positions for derivative term
           self.prev_positions = np.zeros(12)
       
       def compute_torques(
           self,
           current_positions: np.ndarray,
           current_velocities: np.ndarray,
           target_positions: np.ndarray,
           target_velocities: np.ndarray = None,
       ) -> np.ndarray:
           """Compute joint torques using PD control.
           
           Args:
               current_positions: Current joint positions (12,)
               current_velocities: Current joint velocities (12,)
               target_positions: Target joint positions (12,)
               target_velocities: Target joint velocities (12,), optional
           
           Returns:
               Joint torques (12,)
           """
           if target_velocities is None:
               target_velocities = np.zeros(12)
           
           # Position error
           position_error = target_positions - current_positions
           
           # Velocity error
           velocity_error = target_velocities - current_velocities
           
           # PD control law: tau = Kp * e_pos + Kd * e_vel
           torques = self.kp * position_error + self.kd * velocity_error
           
           return torques
       
       def set_targets(self, positions: np.ndarray, velocities: np.ndarray = None):
           """Set target joint positions and velocities."""
           self.target_positions = positions
           if velocities is not None:
               self.target_velocities = velocities
           else:
               self.target_velocities = np.zeros(12)

Velocity to Joint Target Conversion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Convert high-level velocity commands to joint targets using inverse kinematics or a gait generator:

.. code-block:: python

   class VelocityToJointConverter:
       """Convert velocity commands to joint targets for Go2."""
       
       def __init__(self):
           """Initialize converter with gait parameters."""
           # Gait parameters (trot gait for Go2)
           self.stance_duration = 0.3  # seconds
           self.swing_duration = 0.2  # seconds
           self.step_height = 0.08  # meters
           
           # Default joint positions (standing pose)
           self.default_positions = np.array([
               0.1, 0.8, -1.5,  # Front left: hip, thigh, calf
               -0.1, 0.8, -1.5,  # Front right
               0.1, 0.8, -1.5,  # Rear left
               -0.1, 0.8, -1.5,  # Rear right
           ])
       
       def velocity_to_joint_targets(
           self,
           linear_vel: float,
           angular_vel: float,
           current_time: float,
       ) -> tuple[np.ndarray, np.ndarray]:
           """Convert velocity command to joint targets.
           
           Args:
               linear_vel: Linear velocity (m/s)
               angular_vel: Angular velocity (rad/s)
               current_time: Current time for gait phase
           
           Returns:
               Tuple of (target_positions, target_velocities)
           """
           # Simplified: Use default positions with velocity-based adjustments
           # In practice, use proper inverse kinematics or gait generator
           
           target_positions = self.default_positions.copy()
           target_velocities = np.zeros(12)
           
           # Adjust based on velocity commands
           # Forward velocity: adjust leg extension
           if linear_vel > 0:
               target_positions[2::3] -= 0.1 * linear_vel  # Calf joints
           
           # Angular velocity: adjust leg positions for turning
           if angular_vel != 0:
               target_positions[0::3] += 0.05 * angular_vel  # Hip joints
           
           return target_positions, target_velocities

Complete Deployment Node
~~~~~~~~~~~~~~~~~~~~~~~~~

Complete deployment node integrating policy, PD controller, and Go2 SDK:

.. code-block:: python

   # deployment/go2_deployment_node.py
   import urbanverse as uv
   import numpy as np
   import time
   import cv2
   from unitree_go2_sdk import Go2SDK
   
   # Import PD controller and converter (defined in separate files or above)
   from go2_sdk_setup import Go2RobotInterface, PDController, VelocityToJointConverter

   class Go2DeploymentNode:
       """Complete deployment node for UrbanVerse policy on Go2.
       
       This node runs on a laptop with GPU and communicates with the Go2 robot
       over WiFi or Ethernet. Policy inference happens on the laptop GPU, while
       sensor data is streamed from the robot and control commands are sent back.
       """
       
       def __init__(
           self,
           policy_path: str,
           robot_ip: str = "192.168.123.15",
           control_freq: float = 50.0,  # Hz
           use_gpu: bool = True,
       ):
           """Initialize deployment node.
           
           Args:
               policy_path: Path to trained policy checkpoint
               robot_ip: Go2 robot IP address (connect via WiFi/Ethernet)
               control_freq: Control frequency (Hz)
               use_gpu: Whether to use GPU for policy inference (recommended)
           """
           # Load UrbanVerse policy (runs on laptop GPU)
           print("Loading UrbanVerse policy...")
           device = "cuda" if use_gpu else "cpu"
           print(f"Using device: {device}")
           
           self.policy = uv.navigation.rl.load_policy(
               checkpoint_path=policy_path,
               robot_type="unitree_go2",
               device=device,  # Use GPU on laptop
           )
           
           # Initialize Go2 SDK interface (network connection to robot)
           print(f"Connecting to Go2 at {robot_ip} over network...")
           self.robot = Go2RobotInterface(robot_ip)
           
           # Initialize PD controller
           self.pd_controller = PDController(kp=40.0, kd=0.5)
           
           # Initialize velocity-to-joint converter
           self.velocity_converter = VelocityToJointConverter()
           
           # Control parameters
           self.control_freq = control_freq
           self.control_dt = 1.0 / control_freq
           
           # State variables
           self.current_goal = None
           self.robot_pose = None
           self.start_time = time.time()
           
           print("Deployment node initialized")
       
       def get_observation(self) -> dict:
           """Get observation from robot sensors over network.
           
           Sensor data is streamed from the Go2 robot to the laptop, then
           processed and formatted for the UrbanVerse policy.
           
           Returns:
               Observation dictionary compatible with UrbanVerse policy
           """
           # Get sensor data from robot (streamed over network)
           sensor_data = self.robot.get_sensor_data()
           
           # Extract camera image
           camera_image = sensor_data["camera"]
           
           # Resize to policy input size
           image_resized = cv2.resize(camera_image, (240, 135))
           
           # Normalize to [0, 1]
           image_normalized = image_resized.astype(np.float32) / 255.0
           
           # Get odometry for goal vector computation
           odometry = sensor_data["odometry"]
           self.robot_pose = odometry["position"][:2]  # (x, y)
           
           # Compute goal vector
           goal_vector = self.compute_goal_vector()
           
           # Create observation
           obs = {
               "rgb": image_normalized,
               "goal_vector": goal_vector,
           }
           
           return obs
       
       def compute_goal_vector(self) -> np.ndarray:
           """Compute goal vector relative to robot.
           
           Returns:
               Goal vector (dx, dy) in robot frame
           """
           if self.current_goal is None or self.robot_pose is None:
               return np.array([0.0, 0.0])
           
           # Compute relative goal position
           dx = self.current_goal[0] - self.robot_pose[0]
           dy = self.current_goal[1] - self.robot_pose[1]
           
           # Transform to robot frame (simplified - use proper transform in practice)
           return np.array([dx, dy])
       
       def set_goal(self, goal_x: float, goal_y: float):
           """Set navigation goal.
           
           Args:
               goal_x: Goal X position (meters)
               goal_y: Goal Y position (meters)
           """
           self.current_goal = np.array([goal_x, goal_y])
       
       def run_policy_step(self) -> np.ndarray:
           """Run one policy inference step.
           
           Returns:
               High-level action (linear_vel, angular_vel)
           """
           # Get observation
           obs = self.get_observation()
           
           # Run policy
           action = self.policy(obs)
           
           return action
       
       def apply_action(self, action: np.ndarray):
           """Apply action to robot using PD controller.
           
           PD controller computation happens on the laptop, then torques are
           sent to the robot over the network.
           
           Args:
               action: High-level action [linear_vel, angular_vel]
           """
           # Get current joint states from robot (streamed over network)
           sensor_data = self.robot.get_sensor_data()
           joint_states = sensor_data["joints"]
           current_positions = joint_states["position"]
           current_velocities = joint_states["velocity"]
           
           # Convert velocity command to joint targets (computed on laptop)
           current_time = time.time() - self.start_time
           target_positions, target_velocities = self.velocity_converter.velocity_to_joint_targets(
               linear_vel=float(action[0]),
               angular_vel=float(action[1]),
               current_time=current_time,
           )
           
           # Compute joint torques using PD controller (computed on laptop)
           torques = self.pd_controller.compute_torques(
               current_positions=current_positions,
               current_velocities=current_velocities,
               target_positions=target_positions,
               target_velocities=target_velocities,
           )
           
           # Send torques to robot over network
           self.robot.send_joint_torques(torques)
       
       def run(self, duration: float = None):
           """Run deployment loop.
           
           Args:
               duration: Run duration in seconds (None for infinite)
           """
           print("Starting deployment loop...")
           
           start_time = time.time()
           
           try:
               while True:
                   loop_start = time.time()
                   
                   # Run policy
                   action = self.run_policy_step()
                   
                   # Apply action
                   self.apply_action(action)
                   
                   # Check duration
                   if duration is not None:
                       if time.time() - start_time > duration:
                           break
                   
                   # Control loop timing
                   elapsed = time.time() - loop_start
                   sleep_time = max(0, self.control_dt - elapsed)
                   time.sleep(sleep_time)
           
           except KeyboardInterrupt:
               print("Stopping deployment...")
           
           finally:
               # Stop robot
               self.robot.send_locomotion_command(0.0, 0.0)
               self.robot.disconnect()
               print("Deployment stopped")

   def main():
       """Main deployment function."""
       # Configuration
       policy_path = "deployment/go2_policy.pt"
       robot_ip = "192.168.123.15"
       
       # Create deployment node
       node = Go2DeploymentNode(
           policy_path=policy_path,
           robot_ip=robot_ip,
           control_freq=50.0,  # 50 Hz control
       )
       
       # Set navigation goal
       node.set_goal(goal_x=5.0, goal_y=3.0)
       
       # Run deployment
       node.run(duration=300.0)  # Run for 5 minutes

   if __name__ == "__main__":
       main()

PD Controller Tuning
~~~~~~~~~~~~~~~~~~~~~

Tune PD controller gains for stable locomotion:

.. code-block:: python

   # Tuning PD controller gains
   pd_controller = PDController(
       kp=40.0,  # Proportional gain - higher = stiffer, faster response
       kd=0.5,   # Derivative gain - higher = more damping, smoother
   )

   # Test different gains
   # For stiffer control (faster response, less compliant):
   pd_controller_stiff = PDController(kp=60.0, kd=0.8)
   
   # For softer control (more compliant, smoother):
   pd_controller_soft = PDController(kp=30.0, kd=0.3)

**Tuning Guidelines:**

- **Kp (Proportional Gain)**: Controls response speed and stiffness
  - Too high: Oscillations, instability
  - Too low: Slow response, poor tracking
  - Typical range: 20-60 for Go2

- **Kd (Derivative Gain)**: Controls damping and smoothness
  - Too high: Over-damped, sluggish response
  - Too low: Under-damped, oscillations
  - Typical range: 0.3-1.0 for Go2

Integration Architecture
~~~~~~~~~~~~~~~~~~~~~~~~~

The deployment architecture follows a hierarchical control structure:

.. code-block:: text

   UrbanVerse Policy (High-Level)
           ↓
   [linear_vel, angular_vel] commands
           ↓
   Velocity-to-Joint Converter
           ↓
   Target joint positions/velocities
           ↓
   PD Controller (Low-Level)
           ↓
   Joint torques
           ↓
   Go2 SDK → Robot Actuators

This architecture separates high-level navigation decisions (policy) from low-level locomotion control (PD controller), enabling stable and responsive robot control.

Docker Deployment (Optional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For containerized deployment on the laptop, create a Dockerfile:

.. code-block:: dockerfile

   # deployment/Dockerfile
   FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

   # Install system dependencies
   RUN apt-get update && apt-get install -y \
       python3-pip \
       python3-numpy \
       python3-opencv \
       libopencv-dev \
       net-tools \
       iputils-ping

   # Install UrbanVerse and dependencies
   COPY requirements.txt /tmp/
   RUN pip3 install -r /tmp/requirements.txt

   # Install Unitree Go2 SDK
   RUN pip3 install unitree_go2_sdk

   # Copy deployment files
   COPY go2_policy.pt /deployment/
   COPY go2_deployment_node.py /deployment/
   COPY go2_sdk_setup.py /deployment/

   # Set working directory
   WORKDIR /deployment

   # Run deployment node
   CMD ["python3", "go2_deployment_node.py"]

Build and run the Docker container on the laptop:

.. code-block:: bash

   # Build Docker image (on laptop)
   docker build -t urbanverse-go2-deployment .

   # Run container with GPU access and network access for Go2 connection
   docker run -it --rm \
       --gpus all \
       --network host \
       -e ROBOT_IP=192.168.123.15 \
       urbanverse-go2-deployment

**Note**: The container runs on the laptop and communicates with the Go2 robot over the network. Ensure the laptop has network connectivity to the robot before running the container.

Complete Deployment Script
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create a deployment script that orchestrates the entire process:

.. code-block:: python

   # deployment/deploy_to_go2.py
   import urbanverse as uv
   import subprocess
   import os

   def deploy_policy(
       checkpoint_path: str,
       robot_ip: str = "192.168.123.15",
       docker_image: str = "urbanverse-go2-deployment",
   ):
       """Deploy UrbanVerse policy to Go2 robot."""
       
       # 1. Export policy
       print("Exporting policy...")
       policy = uv.navigation.rl.load_policy(checkpoint_path, robot_type="unitree_go2")
       uv.deployment.export_policy(
           policy=policy,
           output_path="deployment/go2_policy.pt",
           format="torchscript",
       )
       
       # 2. Build Docker image
       print("Building Docker image...")
       subprocess.run([
           "docker", "build",
           "-t", docker_image,
           "deployment/",
       ])
       
       # 3. Deploy to robot
       print(f"Deploying to Go2 at {robot_ip}...")
       subprocess.run([
           "docker", "run", "-d",
           "--name", "urbanverse-policy",
           "--network", "host",
           "-e", f"ROBOT_IP={robot_ip}",
           docker_image,
       ])
       
       print("Deployment complete!")

   if __name__ == "__main__":
       deploy_policy(
           checkpoint_path="outputs/my_policy/checkpoints/best.pt",
           robot_ip="192.168.123.15",  # Go2 default IP
       )

Coordinate Frame Transformation
--------------------------------

Handle coordinate frame transformations between simulation and real robot:

.. code-block:: python

   import numpy as np
   from scipy.spatial.transform import Rotation

   def transform_goal_to_robot_frame(
       goal_world: np.ndarray,
       robot_position: np.ndarray,
       robot_orientation: np.ndarray,
   ) -> np.ndarray:
       """Transform goal from world frame to robot frame.
       
       Args:
           goal_world: Goal position in world frame [x, y]
           robot_position: Robot position in world frame [x, y]
           robot_orientation: Robot orientation quaternion [w, x, y, z]
       
       Returns:
           Goal vector in robot frame [dx, dy]
       """
       # Compute relative position in world frame
       relative_world = goal_world - robot_position
       
       # Extract yaw angle from quaternion
       rot = Rotation.from_quat([robot_orientation[1], robot_orientation[2], 
                                  robot_orientation[3], robot_orientation[0]])
       yaw = rot.as_euler('zyx')[0]
       
       # Rotate to robot frame
       cos_yaw = np.cos(-yaw)  # Negative for inverse rotation
       sin_yaw = np.sin(-yaw)
       
       dx = cos_yaw * relative_world[0] - sin_yaw * relative_world[1]
       dy = sin_yaw * relative_world[0] + cos_yaw * relative_world[1]
       
       return np.array([dx, dy])

Sensor Calibration
-------------------

Calibrate sensors to match simulation:

.. code-block:: python

   import cv2
   import numpy as np

   # Camera calibration parameters (obtain from camera calibration)
   camera_calibration = {
       "fx": 320.0,  # Focal length X (pixels)
       "fy": 320.0,  # Focal length Y (pixels)
       "cx": 320.0,  # Principal point X (pixels)
       "cy": 240.0,  # Principal point Y (pixels)
       "distortion": np.array([0.0, 0.0, 0.0, 0.0]),  # Distortion coefficients
   }

   def calibrate_image(image: np.ndarray, calibration: dict) -> np.ndarray:
       """Apply camera calibration and resize to policy input size.
       
       Args:
           image: Raw camera image (H, W, 3)
           calibration: Camera calibration parameters
       
       Returns:
           Calibrated and resized image (135, 240, 3)
       """
       # Undistort image
       camera_matrix = np.array([
           [calibration["fx"], 0, calibration["cx"]],
           [0, calibration["fy"], calibration["cy"]],
           [0, 0, 1],
       ])
       undistorted = cv2.undistort(
           image,
           camera_matrix,
           calibration["distortion"],
       )
       
       # Resize to policy input size
       resized = cv2.resize(undistorted, (240, 135))
       
       # Normalize to [0, 1]
       normalized = resized.astype(np.float32) / 255.0
       
       return normalized

Testing and Validation
----------------------

Test the deployed policy in a controlled environment:

.. code-block:: python

   # Test deployment node
   def test_deployment(policy_path: str, robot_ip: str):
       """Test deployment on robot with safety checks."""
       
       # Create deployment node
       node = Go2DeploymentNode(
           policy_path=policy_path,
           robot_ip=robot_ip,
           control_freq=50.0,
       )
       
       # Set a nearby test goal
       node.set_goal(goal_x=2.0, goal_y=1.0)
       
       # Run for short test duration
       print("Starting test deployment (30 seconds)...")
       node.run(duration=30.0)
       
       print("Test complete")

Safety Considerations
----------------------

Implement safety mechanisms for real-world deployment:

.. code-block:: python

   class SafeDeploymentNode(Go2DeploymentNode):
       """Deployment node with safety checks."""
       
       def __init__(self, *args, **kwargs):
           super().__init__(*args, **kwargs)
           
           # Safety limits
           self.max_linear_vel = 1.5  # m/s
           self.max_angular_vel = 1.0  # rad/s
           self.max_torque = 50.0  # Nm
           
           # Emergency stop flag
           self.emergency_stop = False
       
       def apply_action(self, action: np.ndarray):
           """Apply action with safety checks."""
           # Clip velocities to safe limits
           linear_vel = np.clip(action[0], -self.max_linear_vel, self.max_linear_vel)
           angular_vel = np.clip(action[1], -self.max_angular_vel, self.max_angular_vel)
           
           # Check emergency stop
           if self.emergency_stop:
               linear_vel = 0.0
               angular_vel = 0.0
           
           # Apply action
           action_safe = np.array([linear_vel, angular_vel])
           super().apply_action(action_safe)
       
       def check_safety(self, sensor_data: dict) -> bool:
           """Check safety conditions.
           
           Returns:
               True if safe, False if unsafe
           """
           # Check joint torques
           joint_states = sensor_data["joints"]
           max_torque = np.max(np.abs(joint_states["torque"]))
           
           if max_torque > self.max_torque:
               print(f"Warning: High torque detected: {max_torque:.2f} Nm")
               return False
           
           # Check IMU for excessive tilt
           imu = sensor_data["imu"]
           quaternion = imu["quaternion"]
           # Convert quaternion to roll/pitch (simplified)
           # In practice, use proper quaternion to Euler conversion
           
           return True

Deployment Workflow Summary
----------------------------

The complete deployment workflow for UrbanVerse policies on Unitree Go2 follows these steps:

**Setup Phase:**
1. **Network Configuration**: Connect laptop and Go2 robot to the same network (WiFi or Ethernet)
2. **Policy Export**: Export trained policy in TorchScript or ONNX format for efficient GPU inference
3. **SDK Connection**: Initialize Go2 SDK connection over network to establish communication with the robot

**Runtime Phase (on Laptop with GPU):**
4. **Sensor Data Reception**: Receive sensor data streamed from robot (camera, IMU, joint states, odometry)
5. **Policy Inference**: Run UrbanVerse policy on laptop GPU to get high-level velocity commands
6. **PD Controller Computation**: Compute joint torques using PD controller (on laptop)
7. **Command Transmission**: Send control commands to robot over network
8. **Safety Monitoring**: Continuously monitor robot state and enforce safety limits

**Network Communication:**
- **Sensor Data**: Robot → Laptop (streaming, ~20-50ms latency for camera, <10ms for other sensors)
- **Control Commands**: Laptop → Robot (transmission, <10ms latency)
- **Total Loop Latency**: Target < 50ms for 20 Hz control, < 20ms for 50 Hz control

The hierarchical control architecture (policy on laptop GPU → velocity converter → PD controller → network transmission → robot actuators) ensures stable and responsive robot control while leveraging GPU acceleration for policy inference and maintaining the same observation and action interfaces used during training in UrbanVerse simulation.

