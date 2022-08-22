#!/bin/bash
install_dir="/opt/codetimer"
binary_install_dir="/usr/local/bin"
current_dir="$(pwd)"
if [ ! -d "$install_dir" ];
then 
    sudo mkdir $install_dir
fi
if [ ! -d "$install_dir/visuals" ];
then 
    sudo mkdir "$install_dir/visuals"
fi
sudo cp "$current_dir/timer.sh" $install_dir/
sudo cp -R "$current_dir/visuals/" "$install_dir/visuals/"
sudo cat > /usr/share/applications/codetimer.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Code Timer
Comment=VS Code time tracker.
Exec=bash $install_dir/timer.sh
Icon=$install_dir/visuals/icon.png
Terminal=true
StartupNotify=false
EOF
chmod u+x /usr/share/applications/codetimer.desktop
sudo cp "$current_dir/binaries/codetimer" $binary_install_dir/