#!/usr/bin/env bash

declare -a SW_PACKS=("build-essential" "pkg-config" "automake" "autoconf" \
    "cmake" "cmake-qt-gui" "ggcov" "lcov" "curl" "unzip" "sloccount" "git" \
    "git-core" "doxygen" "ttf-dejavu" "dkms" "graphviz" "vim" "tmux" "ctags")

# enable thirdparty software repositories
sed -i 's/# deb http/deb http/g' /etc/apt/sources.list
sed -i 's/# deb-src http/deb-src http/g' /etc/apt/sources.list

read -p "==> Enable CMake 3.X ppa? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo add-apt-repository -y ppa:george-edison55/cmake-3.x
fi

read -p "==> Enable C/C++11 ppa? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    SW_PACKS+=("gcc-4.9" "g++-4.9")
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
fi

# install essential software packages
sudo apt-get update -qq
sudo apt-get --yes --force-yes --no-install-recommends `echo ${SW_PACKS[@]}`
