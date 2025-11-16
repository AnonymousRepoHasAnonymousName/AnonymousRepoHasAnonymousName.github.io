.. _urbanverse-robot-learning-root:

Robot Learning with UrbanVerse
===============================

This section provides comprehensive documentation for training navigation policies in UrbanVerse's urban simulation environments. UrbanVerse supports both reinforcement learning and imitation learning paradigms, enabling you to train robots ranging from wheeled delivery platforms to humanoid robots in diverse, photorealistic city scenes.

The robot learning documentation covers:

- **Simulation Paradigms**: Understanding synchronous vs. asynchronous multi-environment simulation and how scene layouts and digital cousin variants are distributed across parallel training environments
- **Robot Configuration**: Configuring different robot embodiments (wheeled, legged, humanoid) and their action spaces, including COCO, Unitree Go2, Unitree G1, and more
- **General Configurations**: Understanding the `EnvCfg` configuration system that defines scenes, observations, actions, rewards, terminations, curriculum, and events
- **Reinforcement Learning**: Complete guide to training RL policies with UrbanVerse, including environment configuration, reward design, curriculum learning, and training workflows
- **Imitation Learning**: Complete guide to training Behavior Cloning policies, including data collection, dataset formats, training configuration, and evaluation

.. note::

    We recommend system requirements with at least 32GB RAM and 16GB VRAM for UrbanVerse.
    For workflows with rendering enabled, additional VRAM may be required.
    For the full list of system requirements for Isaac Sim, please refer to the
    Isaac Sim system requirements.
    
    Before training policies, ensure you have completed the :doc:`../installation/index` process and are familiar with :doc:`../quickstart/index` workflows.


.. toctree::
    :maxdepth: 3

    Simulation Paradigms <simulation_paradigms>
    Robot Configuration <robot_configuration>
    General Configurations <configuration>
    Reinforcement Learning in UrbanVerse <reinforcement_learning/index>
    Imitation Learning in UrbanVerse <imitation_learning/index>


