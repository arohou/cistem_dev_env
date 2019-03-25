# cistem_dev_env
A Docker container for cisTEM development


# Installation

## Install X server
MacOS: 
- install XQuartz
- Open it, goto preferences > Security and check the option to allow connections from network clients
- Reboot

## Install Docker
MacOS:
- `brew cask install docker`

## Increase memory limit for Docker VM
Docker > Preferences > Advanced
Increase memory limit to e.g. 8GB (default is 2GB)

# Running
`docker run arohou/cistem_dev_env`

