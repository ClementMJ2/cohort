#!/usr/bin/env bash

set -e

# Ensure main is used as default branch when 'git init'
git config --system init.defaultBranch main
# Set VScode as default editor for git
git config --system core.editor "code"
# Set colours for UI
git config --system color.ui auto
