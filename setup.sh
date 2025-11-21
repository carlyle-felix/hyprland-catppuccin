#!/bin/bash

# Copy directories
cp -r .config /home/${USER}/
sudo cp -r Pictures /home/${USER}/
sudo cp -r usr /

# Make executable
sudo chmod +x /usr/local/bin/start-hyprland
sudo chmod +x /usr/local/bin/wofi-wrapper
