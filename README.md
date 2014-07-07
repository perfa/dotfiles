Dotfiles setup
==============

This repo has my dotfiles and settings, and also a puppet conf for basic setup of my regular environment. The file `setup` will install git and puppet, install the apt module for puppet (and implicitely the stdlib module) and then apply the laptop.pp puppet file. It installs git because when installing a new laptop I drop this whole repo folder on the USB stick I install from and nothing can be assumed to be installed.

The puppet install gets all my regular packages installed, clones _this_ repo and sets up all the dotfiles as symbolic links, and pokes some settings files and unity configs (for ubuntu)
