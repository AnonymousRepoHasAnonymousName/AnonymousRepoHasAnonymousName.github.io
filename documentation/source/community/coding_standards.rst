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

Code Formatting
---------------

UrbanVerse uses **Black** for automatic code formatting:

.. code-block:: bash

   black urbanverse/

**Key Black settings:**

- Line length: 88 characters

- String quote style: Double quotes (preferred)

- Trailing commas: Yes (for multi-line structures)

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

Linting
-------

UrbanVerse uses **ruff** for linting and code quality checks:

.. code-block:: bash

   ruff check urbanverse/
   ruff format urbanverse/

**Common checks:**

- Unused imports

- Undefined variables

- Code complexity

- PEP 8 compliance

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

Best Practices
--------------

- **Keep functions focused**: Each function should do one thing well

- **Avoid deep nesting**: Use early returns and guard clauses

- **Use meaningful names**: Variable and function names should be self-documenting

- **Comment why, not what**: Code should be readable without comments explaining what it does

- **Handle errors gracefully**: Use appropriate exception handling

- **Write docstrings**: Document public APIs and complex logic

For more details, refer to:

- `PEP 8 <https://peps.python.org/pep-0008/>`_

- `Black Documentation <https://black.readthedocs.io/>`_

- `Ruff Documentation <https://docs.astral.sh/ruff/>`_

