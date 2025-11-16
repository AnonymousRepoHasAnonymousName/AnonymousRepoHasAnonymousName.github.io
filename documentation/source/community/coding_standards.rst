.. _urbanverse-community-coding-standards:

Coding Standards
================

UrbanVerse follows Python coding standards to ensure code quality, readability, and maintainability. This document outlines the key coding conventions used in the UrbanVerse codebase.

Style Guide
-----------

UrbanVerse follows **PEP 8** (Python Enhancement Proposal 8), the official Python style guide. Key conventions include:

**Indentation and Spacing:**

- Use 4 spaces for indentation (no tabs)

- Maximum line length: 88 characters (Black formatter default)

- Use blank lines to separate functions and classes

- No trailing whitespace

**Naming Conventions:**

- **Functions and variables**: Use ``snake_case`` (e.g., ``get_observation()``, ``robot_type``)

- **Classes**: Use ``PascalCase`` (e.g., ``EnvCfg``, ``SceneCfg``)

- **Constants**: Use ``UPPER_SNAKE_CASE`` (e.g., ``MAX_EPISODE_STEPS``)

- **Private attributes/methods**: Prefix with single underscore ``_`` (e.g., ``_internal_method()``)

**Imports:**

- Group imports in the following order:

  1. Standard library imports

  2. Third-party imports

  3. Local application imports

- Use absolute imports when possible

- One import per line

**Example:**

.. code-block:: python

   # Standard library
   import os
   import sys
   from pathlib import Path

   # Third-party
   import numpy as np
   import torch

   # Local imports
   from urbanverse.navigation.config import EnvCfg
   from urbanverse.navigation.rl import create_env


Type Hints
----------

Use type hints for function signatures and class attributes:

.. code-block:: python

   def collect_data(
       scene_paths: list[str],
       robot_type: str,
       output_dir: str,
       max_episodes: int = 20,
   ) -> str:
       """Collect expert demonstrations."""
       pass

**Common type hints:**

- ``list[str]`` for lists of strings

- ``dict[str, int]`` for dictionaries

- ``tuple[int, int]`` for tuples

- ``Callable[[dict], np.ndarray]`` for callable types

- ``None`` for optional return values: ``str | None``

Docstrings
----------

Follow **Google-style docstrings** for documentation:

.. code-block:: python

   def train_policy(
       env: ManagerBasedRLEnv,
       training_cfg: dict,
       output_dir: str,
   ) -> str:
       """Train a reinforcement learning policy.

       Args:
           env: RL environment instance
           training_cfg: Training configuration dictionary
           output_dir: Directory where training outputs will be saved

       Returns:
           Path to the best model checkpoint

       Raises:
           ValueError: If training configuration is invalid
       """
       pass

**Docstring sections:**

- **Args**: Parameter descriptions

- **Returns**: Return value description

- **Raises**: Exceptions that may be raised

- **Example**: Usage examples (optional)


Testing
-------

- Write unit tests for all new functions and classes

- Use **pytest** for testing framework

- Test files should be named ``test_*.py``

- Aim for high code coverage (>80%)

**Example test structure:**

.. code-block:: python

   import pytest
   from urbanverse.navigation.config import EnvCfg

   def test_env_cfg_creation():
       """Test environment configuration creation."""
       cfg = EnvCfg(
           scenes=SceneCfg(scene_paths=["/path/to/scene.usd"]),
           robot_type="coco_wheeled",
       )
       assert cfg.robot_type == "coco_wheeled"
