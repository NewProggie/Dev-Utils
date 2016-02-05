#!/usr/bin/env bash

declare -a SW_PACKS=("build-essential" "pkg-config" "automake" "autoconf" \
    "cmake" "cmake-qt-gui" "ggcov" "lcov" "curl" "unzip" "sloccount" "git" \
    "git-core" "doxygen" "ttf-dejavu" "dkms" "graphviz" "vim" "tmux" "ctags" \
    "clang-3.6" "clang-format-3.6")

# enable thirdparty software repositories
sed -i 's/# deb http/deb http/g' /etc/apt/sources.list
sed -i 's/# deb-src http/deb-src http/g' /etc/apt/sources.list

read -p "==> Enable CMake 3.X ppa? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo add-apt-repository -y ppa:george-edison55/cmake-3.x
fi

use_c11=false
read -p "==> Enable C/C++11 ppa? " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    SW_PACKS+=("gcc-5" "g++-5")
    use_c11=true
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
fi

# install essential software packages
sudo apt-get update -qq
sudo apt-get --yes --force-yes --no-install-recommends `echo ${SW_PACKS[@]}`

# update alternatives to use the latest and greatest
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 90
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 90
sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-3.6 90

if [ "${use_c11}" = true ] ; then
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 90
    sudo update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-4.9 90
fi






