sudo apt-get install build-essential acpica-tools nasm uuid-dev gcc-aarch64-linux-gnu
# If you want to use a different workspace, change the target directory below
export WORKSPACE=~/workspace
mkdir $WORKSPACE
cd $WORKSPACE
git clone --recursive https://github.com/tianocore/edk2.git --depth 1
git clone --recursive https://github.com/tianocore/edk2-non-osi.git --depth 1
git clone --recursive https://github.com/tianocore/edk2-platforms.git --depth 1
git clone https://github.com/andreiw/rk3399-edk2.git edk2-platforms/Platform/Rockchip
export GCC5_AARCH64_PREFIX=aarch64-linux-gnu-
export PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-platforms:$WORKSPACE/edk2-non-osi
sed -i -e s/"-Werror"/""/g edk2/Conf/tools_def.txt
. edk2/edksetup.sh
make -C edk2/BaseTools
build -a AARCH64 -t GCC5 -p edk2-platforms/Platform/Rockchip/Rk3399Pkg/Rk3399-SDK.dsc -b DEBUG
edk2-platforms/Platform/Rockchip/Rk3399Pkg/Tools/loaderimage --pack --uboot Build/Rk3399-SDK/DEBUG_GCC5/FV/RK3399_SDK_UEFI.fd RK3399_SDK_UEFI.img
