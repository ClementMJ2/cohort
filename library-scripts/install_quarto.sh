#!/usr/bin/env bash

set -e

QUARTO_VERSION=${1:-${QUARTO_VERSION:-"latest"}}

# Only amd64 build can be installed now
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

if [ "$ARCH" = "amd64" ]; then
    if [ ! -x "$(command -v wget)" ]; then
        apt_get_update_if_needed
        apt-get install -y --no-install-recommends wget ca-certificates
    fi

    if [ "$QUARTO_VERSION" = "latest" ]; then
        QUARTO_DL_URL=$(wget -qO- https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep -oP "(?<=\"browser_download_url\":\s\")https.*${ARCH}\.deb")
    else
        QUARTO_DL_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb"
    fi
    wget "$QUARTO_DL_URL" -O quarto.deb
    dpkg -i quarto.deb
    rm quarto.deb

    quarto check install
fi

# Clean up
# apt-get clean -y
# apt-get autoremove -y
# apt-get autoclean -y
# rm -rf /var/lib/apt/lists/*
