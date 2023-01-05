#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo reboot

sudo apt install ubuntu-gnome-desktop -y
sudo reboot

sudo apt-get install git wget curl
curl -s https://deb.nodesource.com/setup_16.x | sudo bash
sudo apt-get install nodejs -y
sudo snap install code --classic
sudo snap install spotify

sudo apt-get install chrome-gnome-shell
sudo apt install gnome-shell-extension-manager

array=( https://extensions.gnome.org/extension/3433/fly-pie/
https://extensions.gnome.org/extension/1160/dash-to-panel/
)

for i in "${array[@]}"
do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
done