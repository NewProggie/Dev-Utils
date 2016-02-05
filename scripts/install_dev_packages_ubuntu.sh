#!/usr/bin/env bash

declare -a SW_PACKS=("build-essential" "pkg-config" "automake" "autoconf" \
    "cmake" "cmake-qt-gui" "ggcov" "lcov" "curl" "unzip" "sloccount" "git" \
    "git-core" "doxygen" "ttf-dejavu" "dkms" "graphviz" "vim" "tmux" "ctags" \
    "clang-3.6" "clang-format-3.6" "gcc-5" "g++-5")

# enable thirdparty software repositories
sed -i 's/# deb http/deb http/g' /etc/apt/sources.list
sed -i 's/# deb-src http/deb-src http/g' /etc/apt/sources.list

sudo add-apt-repository -y ppa:george-edison55/cmake-3.x
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test

# install essential software packages
sudo apt-get update -qq
sudo apt-get --yes --force-yes --no-install-recommends `echo ${SW_PACKS[@]}`

# update alternatives to use the latest and greatest
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 90
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 90
sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-3.6 90
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 90
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 90
sudo update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-5 90
