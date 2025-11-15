.. _urbanverse-binaries-installation:

Installation using Binaries
=====================================

UrbanVerse requires Nvidia Isaac Sim simulation engine. This tutorial installs Isaac Sim first from binaries, then UrbanVerse from source code.

Installing Isaac Sim
--------------------

Downloading pre-built binaries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please follow the Isaac Sim documentation to install the latest Isaac Sim release. From Isaac Sim 4.5 release, Isaac Sim **binaries** can be downloaded from their official website directly as a zip file.

To check the minimum system requirements, refer to the official Isaac Sim system requirements documentation.

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. note::

         We have tested Isaac Lab with Isaac Sim 4.5.0 release on Ubuntu
         22.04 LTS and 24.04 LTS with NVIDIA driver 535.230 on NVIDIA 4080 Super, 4090 and L40S.

         From Isaac Sim 4.5.0 release, Isaac Sim binaries can be downloaded directly as a zip file.
         The below steps assume the Isaac Sim folder was unzipped to the ``${HOME}/isaacsim`` directory.

      On Linux systems, Isaac Sim directory will be named ``${HOME}/isaacsim``.

.. note::

   We recommend running the following and all subsequent commands in a **bash** terminal.  
   If you are currently using **zsh**, switch to bash (e.g., by running ``bash``) before executing them.


Verifying the Isaac Sim installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To avoid the overhead of finding and locating the Isaac Sim installation
directory every time, we recommend exporting the following environment
variables to your terminal for the remaining of the installation instructions:

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         # Isaac Sim root directory
         export ISAACSIM_PATH="${HOME}/isaacsim"
         # Isaac Sim python executable
         export ISAACSIM_PYTHON_EXE="${ISAACSIM_PATH}/python.sh"


For more information on common paths, please check the official Isaac Sim documentation.

-  Check that the Isaac Sim simulator runs as expected:

   .. tab-set::
      :sync-group: os

      .. tab-item:: :icon:`fa-brands fa-linux` Linux
         :sync: linux

         .. code:: bash

            # note: you can pass the argument "--help" to see all arguments possible.
            ${ISAACSIM_PATH}/isaac-sim.sh

-  Check that the simulator runs from a standalone python script:

   .. tab-set::
      :sync-group: os

      .. tab-item:: :icon:`fa-brands fa-linux` Linux
         :sync: linux

         .. code:: bash

            # checks that python path is set correctly
            ${ISAACSIM_PYTHON_EXE} -c "print('Isaac Sim configuration is now complete.')"
            # checks that Isaac Sim can be launched from python
            ${ISAACSIM_PYTHON_EXE} ${ISAACSIM_PATH}/standalone_examples/api/isaacsim.core.api/add_cubes.py

If the simulator does not run or crashes while following the above
instructions, it means that something is incorrectly configured. To
debug and troubleshoot, please check Isaac Sim
official documentation for FAQ and troubleshooting.
and the Isaac Sim discussion forums.

.. note:: 
    If you meet  the error ``ModuleNotFoundError: No module named 'xxx'``, ensure that the conda environment is activated and use
    ``source _isaac_sim/setup_conda_env.sh`` to set up the conda environment.


Installing UrbanVerse
--------------------

Cloning UrbanVerse
~~~~~~~~~~~~~~~~~~

Clone the UrbanVerse source code repository into your workspace:

.. tab-set::

   .. tab-item:: HTTPS

      .. code:: bash

         git clone -b main --depth 1 "<URL OMITTED for double-blind review policy>"

.. note::
   We provide a helper executable `urbanverse.sh` that provides
   utilities to manage extensions:

   .. tab-set::
      :sync-group: os

      .. tab-item:: :icon:`fa-brands fa-linux` Linux
         :sync: linux

         .. code:: text

            ./urbanverse.sh --help

            usage: urbanverse.sh [-h] [-i] [-v] [-c] [-a] -- Utility to manage UrbanVerse.

            optional arguments:
                -h, --help           Display the help content.
                -i, --install        Install the extensions inside UrbanVerse and learning frameworks as extra dependencies.
                -v, --vscode         Generate the VSCode settings file from template.
                -c, --conda [NAME]   Create the conda environment for UrbanVerse. Default name is 'urbanverse'.
                -a, --advanced       Run the advanced command.

Creating the Isaac Sim Symbolic Link
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Set up a symbolic link between the installed Isaac Sim root folder
and ``_isaac_sim`` in the Isaac Lab directory. This makes it convenient
to index the python modules and look for extensions shipped with Isaac Sim.

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         # enter the cloned repository
         cd UrbanVerse
         # create a symbolic link
         ln -s ${HOME}/isaacsim ./_isaac_sim
         # You can also use the absolute path instead of ${HOME}/isaacsim

Setting up the conda environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         bash urbanverse.sh -c [env_name]  # The default name is "urbanverse"

Once created, be sure to activate the environment before proceeding!

.. code:: bash

   conda activate urbanverse  # or "conda activate my_env"

Once you are in the virtual environment, you can use the default python executable in your environment
by running ``python`` or ``python3``.


Installation
~~~~~~~~~~~~

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. code:: bash

         ./urbanverse.sh --install  # or "./urbanverse.sh -i"
         ./urbanverse.sh --advanced # or "./urbanverse.sh -a"

.. note::

   By default, the basic above installation with `--install` will install the basic modules of UrbanVerse, including:

   - The UrbanVerse project dependencies

   - The UrbanVerse-Gen real-2-sim scene generation pipeline from casual city-tour or street RGB videos

   - The Robot Learning framework for training and evaluating robots in the UrbanVerse environments

   The advanced installation with `--advanced` will additionally install the full system with advanced features, including:

   - Populating dynamic pedestrians and vehicles in the UrbanVerse environments with ORCA algorithm

   - UrbanVerse's automatic 3D asset annotation tool for annotating new 3D objects with semantic, physical, and affordance attributes using GPT-4.1
   
   - VR interface for interacting with the UrbanVerse environments