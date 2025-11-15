.. _urbanverse-installation-binaries:

Installation via Pre-Built Binaries
===================================

UrbanVerse runs on top of the NVIDIA Isaac Sim simulation engine.  
This guide first installs Isaac Sim from its binary distribution, then sets up the UrbanVerse source code.

.. image:: https://img.shields.io/badge/IsaacSim-4.5.0-silver.svg
   :target: .
   :alt: Isaac Sim 4.5.0

.. image:: https://img.shields.io/badge/IsaacLab-2.0.1-silver.svg
   :target: .
   :alt: Isaac Lab 2.0.1

.. image:: https://img.shields.io/badge/python-3.10-blue.svg
   :target: .
   :alt: Python 3.10

.. image:: https://img.shields.io/badge/platform-linux--64-orange.svg
   :target: .
   :alt: Linux (64-bit)

.. note::

   We recommend running UrbanVerse on systems with **at least 32 GB RAM** and **16 GB GPU VRAM**.  
   Workflows involving high-fidelity rendering of complex 3D assets may require even more GPU memory.  
   For detailed and up-to-date hardware requirements, refer to the  
   Isaac Sim system requirements.


Installing Isaac Sim
--------------------

Obtaining the Isaac Sim Binary Package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please refer to the official Isaac Sim documentation to download the most recent binary release.  
Starting from Isaac Sim 4.5, pre-built binaries are distributed directly as a `.zip` archive from NVIDIA’s website.

Before installation, ensure that your system meets the minimum hardware and software requirements listed in the official documentation.

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. note::

         We have validated Isaac Lab and UrbanVerse using Isaac Sim 4.5.0 on Ubuntu 22.04 LTS and 24.04 LTS  
         with NVIDIA driver 535.230 on RTX 4080, RTX 4080 Super, RTX 4090, RTX 5090, RTX 6000, RTX 6000 Pro, and L40S GPUs.

         Isaac Sim 4.5.0 and later can be installed by simply extracting the `.zip` archive.  
         The following instructions assume the folder was unpacked to ``${HOME}/isaacsim``.

      On Linux systems, the installation directory is typically located at ``${HOME}/isaacsim``.

.. note::

   For consistency, run all commands in a **bash** terminal.  
   If your shell defaults to **zsh**, switch temporarily by running ``bash`` before proceeding.

Verifying Your Isaac Sim Setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To simplify the upcoming steps, we recommend exporting two environment variables that point to the Isaac Sim installation:

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         # Path to the Isaac Sim installation
         export ISAACSIM_PATH="${HOME}/isaacsim"

         # Isaac Sim Python helper launcher
         export ISAACSIM_PYTHON_EXE="${ISAACSIM_PATH}/python.sh"

You can consult the Isaac Sim documentation for more details about standard install paths.

-  **Test launching the simulator GUI:**

   .. tab-set::
      :sync-group: os

      .. tab-item:: :icon:`fa-brands fa-linux` Linux
         :sync: linux

         .. code:: bash

            ${ISAACSIM_PATH}/isaac-sim.sh

-  **Test launching Isaac Sim through Python:**

   .. tab-set::
      :sync-group: os

      .. tab-item:: :icon:`fa-brands fa-linux` Linux
         :sync: linux

         .. code:: bash

            # Confirm python path is configured correctly
            ${ISAACSIM_PYTHON_EXE} -c "print('Isaac Sim environment detected.')"

            # Confirm Isaac Sim can be launched from python
            ${ISAACSIM_PYTHON_EXE} ${ISAACSIM_PATH}/standalone_examples/api/isaacsim.core.api/add_cubes.py

If you encounter crashes or import errors, verify that Isaac Sim is installed correctly and consult the FAQs and troubleshooting pages in the Isaac Sim documentation and user forums.

.. note::

   If you encounter ``ModuleNotFoundError: No module named 'xxx'``, ensure your conda environment is activated and run:

   ``source _isaac_sim/setup_conda_env.sh``

Installing UrbanVerse
---------------------

Cloning the UrbanVerse Repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Clone the UrbanVerse codebase into your working directory:

.. tab-set::

   .. tab-item:: HTTPS

      .. code:: bash

         git clone -b main --depth 1 "<URL OMITTED FOR DOUBLE-BLIND REVIEW>"

.. note::

   The ``urbanverse.sh`` helper script simplifies common setup tasks such as installing extensions, creating conda environments, and generating VSCode settings.

   .. tab-set::
      :sync-group: os

      .. tab-item:: :icon:`fa-brands fa-linux` Linux
         :sync: linux

         .. code:: text

            ./urbanverse.sh --help

            usage: urbanverse.sh [-h] [-i] [-v] [-c] [-a]
                Utility to manage UrbanVerse.

            optional arguments:
                -h, --help           Show this help message.
                -i, --install        Install UrbanVerse extensions and dependencies.
                -v, --vscode         Generate VSCode settings.
                -c, --conda [NAME]   Create a conda environment (default: "urbanverse").
                -a, --advanced       Install advanced components.

Linking Isaac Sim into UrbanVerse
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

UrbanVerse expects a symbolic link to the Isaac Sim installation under the ``_isaac_sim`` directory.  
This gives UrbanVerse direct access to Isaac Sim’s modules and extensions.

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         cd UrbanVerse
         ln -s ${HOME}/isaacsim ./_isaac_sim
         # Alternatively, use an absolute path to the Isaac Sim installation.

Creating the Conda Environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         bash urbanverse.sh -c [env_name]   # Default environment name: "urbanverse"

Activate the environment before continuing:

.. code:: bash

   conda activate urbanverse

Once activated, the standard python executable in this environment (``python`` or ``python3``) will be used for UrbanVerse.

Installing UrbanVerse
~~~~~~~~~~~~~~~~~~~~~
We provide an automatic installation script ``urbanverse.sh`` that simplifies the installation process:

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         ./urbanverse.sh --install
         ./urbanverse.sh --advanced    # Optional: install advanced features

.. note::

   **Basic installation** (``--install``) includes:

   - Core UrbanVerse dependencies
   - UrbanVerse-100K APIs
   - Core 3rd-party modules and their model weights (e.g., MASt3R, CLIP, SAM-2, DINOv2, Mask2Former, Faiss)
   - The full UrbanVerse-Gen real-to-sim pipeline (3D semantic layout parsing and extraction → asset retrieval → USD scene generation)  
   - Robot learning modules for training and evaluating agents in UrbanVerse environments  

   **Advanced installation** (``--advanced``) additionally includes:

   - Dynamic agents (pedestrians, riders and vehicles) populated using ORCA algorithm
   - UrbanVerse’s automatic asset annotation toolkit (semantic / physical / affordance attributes via GPT-4.1)  
   - VR interaction tools for exploring UrbanVerse environments

