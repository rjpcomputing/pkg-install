#!/bin/sh
# ############################################################################
# Starter script to make sure that Lua is installed on your machine before
# 	starting the work script.
# Author:	Ryan Pusztai
# Date:		05/17/2012
# Notes:	Assumes root privileges.
#			
# ############################################################################

# Install Lua first so we can run the install script.
sudo apt-get install lua5.1 python-software-properties

# Run the install script.
sudo lua pkg-install-srv.lua $@

