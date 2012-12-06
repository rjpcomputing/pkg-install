#!/bin/sh
# ############################################################################
# Starter script to make sure that Lua is installed on your machine before
# 	starting the work script.
# Author:	Ryan Pusztai
# Date:		06/09/2009
# Notes:	Built against Ubuntu 9.04 (Jaunty).
#			Assumes root privileges.
# ############################################################################

# Install Lua first so we can run the install script.
sudo aptitude install lua5.1

# Run the install script.
sudo lua pkg-install.lua

