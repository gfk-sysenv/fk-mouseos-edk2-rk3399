# use docker: need py2@ubt2004 (py2.deprecated @ubt2204)
ARG VER=20.04
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:library--ubuntu---${VER}
ARG TARGETPLATFORM
ENV \
  DEBIAN_FRONTEND=noninteractive \
  WORKSPACE=/workspace
RUN \
  # sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources; \
  # apt update; apt remove git; apt autoremove; \
  # apt install -y git iasl python3-distutils build-essential nasm uuid-dev gcc-aarch64-linux-gnu
  apt update; apt install -y git vim-tiny tree python2 python3 python-is-python3; \
  apt install -y build-essential acpica-tools nasm uuid-dev gcc-aarch64-linux-gnu

RUN \
  mkdir -p $WORKSPACE; cd $WORKSPACE; \
  git clone https://github.com/tianocore/edk2.git; \
  pushd edk2; git checkout 46f4c9677c615d862649459392f8f55b3e6567c2; \
  popd; git clone https://github.com/tianocore/edk2-non-osi.git; \
  pushd edk2-non-osi; git checkout 1e2ca640be54d7a4d5d804c4f33894d099432de3; \
  popd; git clone https://github.com/tianocore/edk2-platforms.git; \
  pushd edk2-platforms; git checkout 861c200cda1417539d46fe3b1eba2b582fa72cbb; \
  popd; git clone https://github.com/andreiw/rk3399-edk2.git edk2-platforms/Platform/Rockchip;

# secrets 模块是从 Python 3.6 开始引入的。请确保你的 Python 版本至少是 3.6 或更高
# File "/workspace/edk2/BaseTools/BinWrappers/PosixLike/../../Source/Python/build/build.py", line 32, in <module> | ImportError: No module named secrets
RUN \
  # ln -s /usr/bin/python2 /usr/bin/python; \
  cd $WORKSPACE; \
  export GCC5_AARCH64_PREFIX=aarch64-linux-gnu-; \
  export PACKAGES_PATH=$WORKSPACE/edk2:$WORKSPACE/edk2-platforms:$WORKSPACE/edk2-non-osi; \
  . edk2/edksetup.sh; \
  \
  make -C edk2/BaseTools; \
  build -a AARCH64 -t GCC5 -p edk2-platforms/Platform/Rockchip/Rk3399Pkg/Rk3399-SDK.dsc -b DEBUG; \
  edk2-platforms/Platform/Rockchip/Rk3399Pkg/Tools/loaderimage --pack --uboot Build/Rk3399-SDK/DEBUG_GCC5/FV/RK3399_SDK_UEFI.fd RK3399_SDK_UEFI.img; \
  # view
  ls -lh Build/Rk3399-SDK/DEBUG_GCC5/FV/RK3399_SDK_UEFI.fd RK3399_SDK_UEFI.img;
    