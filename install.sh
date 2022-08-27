#!/bin/bash
INSTALL_DIR="/opt/codetimer"
BINARY_INSTALL_DIR="/usr/local/bin"
CURRENT_DIR="$(pwd)"

if [ -d "$INSTALL_DIR" ];
then 
    rm -r $INSTALL_DIR
fi
sudo mkdir $INSTALL_DIR

sudo cp "$CURRENT_DIR/timer.sh" $INSTALL_DIR/
sudo chmod +x "$INSTALL_DIR/timer.sh" 

sudo cp -R "$CURRENT_DIR/visuals/" "$INSTALL_DIR/"
sudo cat > /usr/share/applications/codetimer.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Code Timer
Comment=VS Code time tracker.
Exec=bash $INSTALL_DIR/timer.sh
Icon=$INSTALL_DIR/visuals/icon.png
Terminal=true
StartupNotify=false
EOF

sudo chmod u+x /usr/share/applications/codetimer.desktop

sudo cp "$CURRENT_DIR/binaries/codetimer" $BINARY_INSTALL_DIR/
sudo chmod +x "$BINARY_INSTALL_DIR/codetimer" 