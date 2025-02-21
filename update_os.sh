#!/bin/bash

# Author: Kevin Wilkins
# Date: 04/22/2023
# Description:
# This script runs fetches new release upgrades for Ubuntu systems.

sudo apt update
sudo apt upgrade -y
sudo apt install update-core-manager
sudo apt install update-manager-core
do-release-upgrade -d
