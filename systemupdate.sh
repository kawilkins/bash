#!/bin/bash

# Author: Kevin Wilkins
# Date: 04/22/2023
# Description:
# This script runs updates on packages in Linux. It checks what package manager
# exists on the system, then runs the appropriate commands to update the
# repository cache, upgrade available packages, then clean up unnecessary
# files.

for pkg in apt dnf pacman rpm yum; do
    if command -v $pkg >/dev/null; then {
        pkgmgr=$pkg
    } fi
    done

apt_update(){
    apt update
    apt -y upgrade
    apt -y autoremove
}

dnf_update(){
    sudo dnf check-update
    sudo dnf update
    sudo dnf autoremove
    sudo dnf clean all
}

if command -v snap >/dev/null; then {
    snap refresh
} fi

if [ $pkgmgr = apt ]; then {
    apt_update
} elif [ $pkgmgr = dnf ]; then {
    dnf_update
} fi

echo ". . . Complete!"
