#!/bin/bash

# Author: Kevin Wilkins
# Date: 04/22/2023
# Description:
# This script runs fetches new release upgrades for Ubuntu systems.

set -e
apt update
apt upgrade -y
apt install -y update-manager-core

cat <<EOF >/etc/apt/apt.conf.d/90keep-old
DPkg::Options {
    "--force-confdef";
    "--force-confold";
};
EOF

DEBIAN_FRONTEND=noninteractive do-release-upgrade -d
