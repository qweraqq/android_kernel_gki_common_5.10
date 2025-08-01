#!/bin/bash

# Linux version 5.10.209-android12-9-00019-g4ea09a298bb4-ab12292661 (build-user@build-host) (Android (7284624, based on r416183b) clang version 12.0.5 (https://android.googlesource.com/toolchain/llvm-project c935d99d7cf2016289302412d708641d52d2f7ee), LLD 12.0.5 (/buildbot/src/android/llvm-toolchain/out/llvm-project/lld c935d99d7cf2016289302412d708641d52d2f7ee)) #1 SMP PREEMPT Wed Aug 28 22:16:09 UTC 2024

# apt-get update
# apt-get build-dep linux
# apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev p7zip-full p7zip-rar libwxgtk3.0-gtk3-dev dwarves cmake libdwarf-dev libdw-dev pkgconf linux-tools-generic linux-tools-common bpfcc-tools libbpfcc libbpfcc-dev linux-generic libbpf-dev 

# git clone https://github.com/acmel/dwarves.git --branch=v1.24
# cd dwarves/
# git checkout v1.24
# mkdir build
# cd build
# cmake -D__LIB=lib ..
# px cmake -D__LIB=lib ..
# make install

# git clone --depth 1 https://github.com/LineageOS/android_prebuilts_clang_kernel_linux-x86_clang-r416183b ~/clang-r416183b

export CLANG_PATH=~/clang-r416183b/bin/
export PATH=${CLANG_PATH}:${PATH}
export LD_LIBRARY_PATH=/opt/clang-r416183b/lib64:/usr/local/lib:$LD_LIBRARY_PATH


export ARCH=arm64
export SUBARCH=$ARCH
export KBUILD_BUILD_USER=build-user
export KBUILD_BUILD_HOST=build-host
export KBUILD_BUILD_TIMESTAMP="Wed Aug 28 22:16:09 UTC 2024"
KBUILD_BUILD_TIMESTAMP="Wed Aug 28 22:16:09 UTC 2024"

THREAD="-j$(nproc --all)"

# Basic Information
DEFCONFIG="gki_defconfig"

rm -rf out
mkdir -p out

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1 O=out $DEFCONFIG
make CC=clang LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- O=out $THREAD \
    LOCALVERSION=-android12-9-00019-g4ea09a298bb4-ab12292661 \
    CONFIG_LOCALVERSION_AUTO=n \
    CONFIG_MEDIATEK_CPUFREQ_DEBUG=m CONFIG_MTK_IPI=m CONFIG_MTK_TINYSYS_MCUPM_SUPPORT=m \
    CONFIG_MTK_MBOX=m CONFIG_RPMSG_MTK=m CONFIG_LTO_CLANG=y CONFIG_LTO_NONE=n \
    CONFIG_LTO_CLANG_THIN=y CONFIG_LTO_CLANG_FULL=n 2>&1  | tee kernel.log
