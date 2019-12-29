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

# Running
- In the directory with this README file, run `sh run.sh`

This launches 4 windows using your X server:

- an xterm terminal running `top`
- an xterm terminal for your use
- Eclipse
- wxformbuilder

Note that the Docker container will terminate if you close/terminate `top`.

# Eclipse configuration
- Clone the cisTEM git sources if you don't have them yet
- Import the project as a local git repository using the Import Existing Eclipse Project option
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
