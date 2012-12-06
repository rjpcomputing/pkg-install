#!/bin/sh
# ############################################################################
# Starter script to make sure that Lua is installed on your machine before
# 	starting the work script.
# Author:	Ryan Pusztai
# Date:		11/06/2012
# Notes:	Assumes root privileges.
#
# ############################################################################

# Install Lua first so we can run the install script.
sudo apt-get -y install lua5.1

# Run the install script.
sudo lua pkg-install-srv.lua $@

