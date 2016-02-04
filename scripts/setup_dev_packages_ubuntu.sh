#!/usr/bin/env bash

# enable thirdparty software repositories
sed -i 's/# deb http/deb http/g' /etc/apt/sources.list
sed -i 's/# deb-src http/deb-src http/g' /etc/apt/sources.list

# set local timezone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

sudo apt-get update && sudo apt-get upgrade
sudo apt-get --yes --force-yes --no-install-recommends install build-essential \
    pkg-config automake autoconf cmake cmake-qt-gui ggcov lcov curl unzip \
    sloccount git git-core doxygen ttf-dejavu dkms graphviz vim tmux ctags
