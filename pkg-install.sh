#!/bin/sh
# ############################################################################
# Starter script to make sure that Lua is installed on your machine before
# 	starting the work script.
# Author:	Ryan Pusztai
# Date:		06/09/2009
# Notes:	Assumes root privileges.
#
# ############################################################################

# Install Lua first so we can run the install script.
apt-get install lua5.1 sudo

# Run the install script.
sudo lua pkg-install.lua "$@"

