#!/usr/bin/env bash

set -e

RIG_VERSION=${1:-${RIG_VERSION:-latest}}
R_VERSION=${2:-${R_VERSION:-latest}}

ARCH=$(dpkg --print-architecture)

export DEBIAN_FRONTEND=noninteractive

# Function to call apt-get if needed
apt_get_update_if_needed()
{
    if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update
    else
        echo "Skipping apt-get update."
    fi
}

apt_get_update_if_needed
apt-get install -y --no-install-recommends \
    ca-certificates \
    bash-completion \
    gzip \
    libxml2-dev \
    libfontconfig1-dev

if [ "$ARCH" = "amd64" ]; then
    curl -Ls "https://github.com/r-lib/rig/releases/download/${RIG_VERSION}/rig-linux-${RIG_VERSION#v}.tar.gz" |
        sudo tar xz -C /usr/local
else
    curl -Ls "https://github.com/r-lib/rig/releases/download/${RIG_VERSION}/rig-linux-${ARCH}-${RIG_VERSION#v}.tar.gz" |
        sudo tar xz -C /usr/local
fi

# rig system add-pak --all

# Clean up
# apt-get clean -y
# apt-get autoremove -y
# apt-get autoclean -y
# rm -rf /var/lib/apt/lists/*
