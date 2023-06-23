#!/usr/bin/env bash

set -e

PANDOC_VERSION=${1:-${PANDOC_VERSION:-latest}}
ARCH=$(dpkg --print-architecture)

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

if [ ! -x "$(command -v wget)" ]; then
    apt_get_update_if_needed
    apt-get install -y --no-install-recommends wget ca-certificates
fi

if [ "$PANDOC_VERSION" = "latest" ]; then
    PANDOC_DL_URL=$(wget -qO- https://api.github.com/repos/jgm/pandoc/releases/latest | grep -oP "(?<=\"browser_download_url\":\s\")https.*${ARCH}\.deb")
else
    PANDOC_DL_URL=https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-${ARCH}.deb
fi
wget ${PANDOC_DL_URL} -O pandoc.deb
dpkg -i pandoc.deb
rm pandoc.deb

## Symlink pandoc & standard pandoc templates for use system-wide
PANDOC_TEMPLATES_VERSION=$(pandoc -v | grep -oP "(?<=pandoc\s)[0-9\.]+$")
wget https://github.com/jgm/pandoc-templates/archive/${PANDOC_TEMPLATES_VERSION}.tar.gz -O pandoc-templates.tar.gz
rm -fr /opt/pandoc/templates
mkdir -p /opt/pandoc/templates
tar xvf pandoc-templates.tar.gz
cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates*
rm -fr /root/.pandoc
mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates

# Clean up
# apt-get clean -y
# apt-get autoremove -y
# apt-get autoclean -y
# rm -rf /var/lib/apt/lists/*
