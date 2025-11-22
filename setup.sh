#!/bin/bash

# Copy directories
cp -r .config /home/${USER}/
#sudo cp -r Pictures /home/${USER}/
#sudo cp -r usr /

# Make executable
#sudo chmod +x /usr/local/bin/start-hyprland
#sudo chmod +x /usr/local/bin/wofi-wrapper

# Create user dirs and bookmarks
#pushd /home/${USER}
#xdg-user-dirs-update 
#xdg-user-dirs-gtk-update
#popd

# Catppuccin papirus icon theme (https://github.com/catppuccin/papirus-folders)
#git clone https://github.com/catppuccin/papirus-folders.git
#pushd papirus-folders
#sudo cp -r src/* /usr/share/icons/Papirus  
#curl -LO https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders && chmod +x ./papirus-folders
#./papirus-folders -C cat-mocha-blue --theme Papirus-Dark
# Cleanup
#popd && rm -rf papirus-folders

