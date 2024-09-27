#!/bin/bash

# Path to your local Git repository
REPO_PATH="/data/data/com.termux/files/home/termux_config"

# Move to the repository directory
cd $REPO_PATH

# Copy the updated .zshrc file to the repository
cp ~/.zshrc $REPO_PATH

# Check if there are changes
if [[ `git status --porcelain` ]]; then
    git add .zshrc
    git commit -m "Auto-update .zshrc"
    git push origin
else
    echo "No changes detected in .zshrc"
f
