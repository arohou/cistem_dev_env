# cistem\_dev_env
A Docker container for cisTEM development


# Installation

## Install X server
MacOS: 

- Install XQuartz
- Open it, go to preferences > Security and check the option to allow connections from network clients
- Reboot

## Install Docker
MacOS:

- Install homebrew if you don't have it already
- `brew cask install docker`

## Increase memory limit for Docker VM
- Create an account on docker hub if you don't have one already
- Launch Docker and go to Docker > Preferences > Advanced
- Increase memory limit to e.g. 8GB (default is 2GB)

# Running the Docker

Note: this is not necessary if you are going to use Visual Studio Code. In that case, just skip ahead.

- In the directory with this README file, run `sh ./run.sh`

This lands you in a terminal running in the containerized instance of Linux, where you are a user named `developer` and your password is `developer`. Thanks to one of the `-v` options to the `docker run` command, your home directory is mounted in the dockerized Linux at `/mnt/ext_home/` - assuming your git repository is somewhere under your home, this will make it easy to work on cisTEM within the Docker.

# Getting started with cisTEM development

## Setup your local git repository

- Pick a location somewhere in your home directory  (I use `$HOME/work/git`)
- Navigate there
- `git clone https://github.com/ngrigorieff/cisTEM.git` 
- You now have a local cisTEM repository (for me, `$HOME/work/git/cisTEM`)

## Install Visual Studio Code & extensions
Visual Studio Code is an open-source, cross-platform code editor. Install it from https://code.visualstudio.com/.

Open VSCode and install the following extensions (View > Extensions):

- C/C++
- CMake Tools
- Remote Development

## Install cisTEM dependencies on your system
MacOS:

- `brew install cmake pkg-config fftw wxWidgets`


## Local (native) cisTEM development 
Let's make sure everything works locally first:

- Start VSCode
- File > Open...
- Browse to the `cisTEM` directory that you created earlier (your local repo)
- Open it
- If you have `cmake` installed and working, the cisTEM project should automatically configure. 

You should see the following in the Output tab at the bottom of VSCode:

```
[cmake] -- Configuring done
[cmake] -- Generating done
[cmake] -- Build files have been written to: <...>/cisTEM/build/Clang 11.0.0/Debug
```

You should be able to open a source code file and see everything highlighted nicely, no parser errors, etc. 

Now check that cisTEM can build successfully:

 - Click "Build" (with a gear icon) near the bottom of the window (you can choose whether to build all programs or just one or more target)

 
## Remote (dev container) cisTEM development

Unfortunately, cisTEM does not work on MacOS (yet), and it has not been tested on Windows. The target platform is Linux. If your personal laptop/workstation is not running Linux, you can use the `arohou/cistem_dev_env` Docker, which is pre-loaded with the necessary dependencies to compile and debug cisTEM. 

VSCode has a nice feature whereby it can run the Docker image for you, connect to it, and let you build, debug, and run cisTEM within the Docker, but using the native Visual Code Studio application. More detailed instructions are available [on the vscode website](https://code.visualstudio.com/docs/remote/containers#_attaching-to-running-containers), but in brief:

- Make sure you have the latest version of the image: `docker pull arohou/cistem_dev_env`
- If you don't have vscode running yet:
	- Open vscode
	- "Open folder...", select your cisTEM directory
	- If you see a popup suggesting to "Reopen in container", go for it
		- If not, reopen the project in the container by selecting the "Remote-Containers: Reopen in Container..." command from the Command Palette (F1)
- If you already have vscode running natively:
	- Open your cisTEM folder
	- Reopen the project in the container by selecting the "Remote-Containers: Reopen in Container..." command from the Command Palette (F1)
- Open the Extensions sidebar (by clicking on the Extensions icon, left pane, looks like squares)
- Install the following extensions in the Dev Container:
	- C/C++
	- CMake Tools
- Reload the Dev Container

Once the Dev Container has reloaded, you will be prompted to select a Kit (toolchain)

- Select "GCC 9.3.0"



You should now be able to configure and build cisTEM in the Linux environment from the comfort of your native vscode.

To run the cisTEM GUI, make sure that XQuartz is running, and, in your native MacOS terminal:

- `xhost + 127.0.0.1`


# [Deprecated] Using eclipse
##Eclipse configuration
- Clone the cisTEM git sources if you don't have them yet
- Import the project 
	- File > Import ...
	- Git > Projects from Git
	- Existing local repository
	- Add...
	- Navigate to your cisTEM git repository (presumably somewhere in /mnt/ext_home/
	- Select the git repository
	- Import existing Eclipse project
	- Select the "cisTEM" project
	- If Eclipse gets screwed up at a later point in time, do a git checkout on the .project file to reset
- To get all the symbols resolved by the Eclipse CDT indexer, select the project in the Project Explorer and then go to Project > Properties > C/C++ General > Paths & Symbols and add the following include directories:
    - /usr/include
    - /usr/include/x86_64-linux-gnu
    - /usr/local/include
    - /usr/lib/gcc/x86_64-linux-gnu/7/include
    - /usr/lib/gcc/x86_64-linux-gnu/7/include-fixed
    - /usr/local/lib/wx/include/gtk2-unicode-static-3.0
    - /usr/local/include/wx-3.0
- Character encoding: In the main window, go to Window > Preferences and under General > Workspace change the text file encoding to UTF-8
- Make comments in src/core/defines.h and src/gui/ProjectX_gui.h and save these files
- Select Project > C/C++ Index > Update with modified files and let the indexer work (time for coffee)
- Remove the comments. You're good to go!
