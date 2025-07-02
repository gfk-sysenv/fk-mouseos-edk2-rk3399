sudo apt-get install build-essential acpica-tools nasm uuid-dev gcc-aarch64-linux-gnu
# If you want to use a different workspace, change the target directory below
export WORKSPACE=~/workspace
mkdir $WORKSPACE
cd $WORKSPACE
git clone https://github.com/tianocore/edk2.git
pushd edk2
git checkout 46f4c9677c615d862649459392f8f55b3e6567c2
popd
git clone https://github.com/tianocore/edk2-non-osi.git
pushd edk2-non-osi
git checkout 1e2ca640be54d7a4d5d804c4f33894d099432de3
popd
git clone https://github.com/tianocore/edk2-platforms.git
pushd edk2-platforms
git checkout 861c200cda1417539d46fe3b1eba2b582fa72cbb
popd
git clone https://github.com/andreiw/rk3399-edk2.git edk2-platforms/Platform/Rockchip
export GCC5_AARCH64_PREFIX=aarch64-linux-gnu-
export PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-platforms:$WORKSPACE/edk2-non-osi
. edk2/edksetup.sh

# err: py2> py3@ubt2204
# File "/home/runner/workspace/edk2/BaseTools/Source/Python/Common/Misc.py", line 29, in <module>: ModuleNotFoundError: No module named 'UserDict'
# make -C edk2/BaseTools
build -a AARCH64 -t GCC5 -p edk2-platforms/Platform/Rockchip/Rk3399Pkg/Rk3399-SDK.dsc -b DEBUG
# edk2-platforms/Platform/Rockchip/Rk3399Pkg/Tools/loaderimage --pack --uboot Build/Rk3399-SDK/DEBUG_GCC5/FV/RK3399_SDK_UEFI.fd RK3399_SDK_UEFI.img
