#!/usr/bin/env bash

set -e

USER_LANG=${1:-${USER_LANG:-en_GB.UTF-8}}

export DEBIAN_FRONTEND=noninteractive

if ! grep -o -E "^\s*${USER_LANG}\s+UTF-8" /etc/locale.gen > /dev/null; then
    echo "${USER_LANG} UTF-8" >> /etc/locale.gen 
    locale-gen
fi

# Ensure at least the en_US.UTF-8 and en_GB.UTF-8 UTF-8 locale are available.
if ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen 
    locale-gen
fi

if ! grep -o -E '^\s*en_GB.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen 
    locale-gen
fi

# Clean up
# apt-get autoremove -y
# apt-get autoclean -y
# rm -rf /var/lib/apt/lists/*
# rm -rf /tmp/*
