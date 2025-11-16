.. _urbanverse-community-bug-reports:

Bug Reports
===========

Found a bug? We want to hear about it! This guide will help you report bugs effectively so we can fix them quickly.

Before Reporting
----------------

Before creating a bug report, please:

1. **Search existing issues** to see if the bug has already been reported
2. **Check the documentation** to ensure you're using the API correctly
3. **Test with the latest version** to confirm the bug still exists
4. **Try to reproduce** the issue consistently

Creating a Bug Report
---------------------

When creating a bug report, please include the following information:

**1. Clear Title**

   - Summarize the issue in one line

   - Example: "Memory leak when loading multiple scenes in parallel"

**2. Description**

   - What happened vs. what you expected

   - Steps to reproduce the issue

   - Minimal code example that demonstrates the bug

**3. Environment Information**

   - UrbanVerse version

   - Python version

   - Operating system

   - Isaac Sim version (if applicable)

   - GPU/CPU information

**4. Error Messages**

   - Full error traceback (if applicable)

   - Log output

   - Screenshots (if visual issue)

**5. Additional Context**

   - When did the issue first occur?

   - Does it happen consistently or intermittently?

   - Any workarounds you've found?

Bug Report Template
-------------------

Use this template when creating a bug report:

.. code-block:: text

   **Description**
   [Clear description of the bug]

   **To Reproduce**
   Steps to reproduce the behavior:
   1. Run '...'
   2. Call '...'
   3. See error

   **Expected Behavior**
   [What you expected to happen]

   **Actual Behavior**
   [What actually happened]

   **Code Example**
   ```python
   # Minimal code that reproduces the issue
   ```

   **Environment**
   - UrbanVerse version: [e.g., 1.0.0]
   - Python version: [e.g., 3.10]
   - OS: [e.g., Ubuntu 22.04, macOS 13.0, Windows 11]
   - Isaac Sim version: [e.g., 4.5.0]
   - GPU: [e.g., NVIDIA RTX 3090]

   **Error Output**
   ```
   [Full error traceback or log output]
   ```

   **Additional Context**
   [Any other relevant information]

Example Bug Report
------------------

**Good bug report:**

.. code-block:: text

   **Description**
   Environment creation fails when using async_sim=False with more than 16 scenes.

   **To Reproduce**
   1. Create EnvCfg with 20 scene paths
   2. Set async_sim=False
   3. Call uv.navigation.rl.create_env(cfg)
   4. See IndexError

   **Expected Behavior**
   Environment should be created successfully, using different cousin variants.

   **Actual Behavior**
   IndexError: list index out of range at scene assignment.

   **Code Example**
   ```python
   from urbanverse.navigation.config import EnvCfg, SceneCfg
   
   scene_paths = [f"/path/to/scene_{i:04d}/scene.usd" for i in range(20)]
   cfg = EnvCfg(
       scenes=SceneCfg(scene_paths=scene_paths, async_sim=False),
       robot_type="coco_wheeled",
   )
   env = uv.navigation.rl.create_env(cfg)  # Fails here
   ```

   **Environment**
   - UrbanVerse version: 1.0.0
   - Python version: 3.10.8
   - OS: Ubuntu 22.04
   - Isaac Sim version: 4.5.0

   **Error Output**
   ```
   IndexError: list index out of range
     File "urbanverse/navigation/rl/env.py", line 123, in _assign_scenes
       scene = available_scenes[env_idx % len(available_scenes)]
   ```

Where to Report
---------------

Report bugs on GitHub Issues:

- **GitHub Issues**: `AnonymousForDoubleBlindReview`

For security-related issues, please email the maintainers directly rather than creating a public issue.

Feature Requests
----------------

Feature requests are also welcome! When requesting a feature:

- **Describe the use case**: Why is this feature needed?

- **Propose a solution**: How should it work?

- **Consider alternatives**: Are there existing ways to achieve this?

- **Check existing requests**: Has this been requested before?

Feature requests should be clearly labeled and include:

- Use case description

- Proposed API or interface

- Example usage

- Potential implementation considerations

Response Time
-------------

We aim to:

- Acknowledge new issues within 1-2 business days

- Triage and label issues within 1 week

- Provide updates on bug fixes and feature requests regularly

Thank you for helping improve UrbanVerse by reporting bugs! 🐛

