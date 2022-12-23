#!/usr/bin/env bash
if [[ "$(uname -s)" == "Linux" ]]; then
  if ! type -P cmake &>/dev/null; then
    echo "[!] cmake not installed or not found, refusing to build!"
    exit 1
  fi
  if ! type -P make &>/dev/null; then
    echo "[!] make not installed or not found, refusing to build!"
    exit 1
  fi
  export CC="$(which clang)"
  export CXX="$(which clang++)"
elif [[ "$(uname -s)" == "Darwin" ]]; then
  if ! type -P cmake &>/dev/null; then
    echo "[!] cmake not installed or not found, refusing to build!"
    exit 1
  fi
  if ! type -P make &>/dev/null; then
    echo "[!] make not installed or not found, refusing to build!"
    exit 1
  fi
  if type -P xcrun &>/dev/null; then
    export CC="$(xcrun --find clang)"
    export CXX="$(xcrun --find clang++)"
  else
    echo "[!] xcrun not installed or not found, refusing to build!"
    exit 1
  fi
else
  echo "[!] Unknown operating system, refusing to build!"
  exit 1
fi
echo "[*] Building iBoot64Patcher"
export FR_INSTALL_DIR="/usr/local/bin"
if [[ -z "$NO_CLEAN" ]]; then
  rm -rf cmake-build-release cmake-build-debug
fi
if [[ "$RELEASE" == "1" ]]; then
  if [[ ! "$NO_CLEAN" == "1" ]]; then 
    cmake -DCMAKE_INSTALL_PREFIX="${FR_INSTALL_DIR}" -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM="$(which make)" -DCMAKE_C_COMPILER="${CC}" -DCMAKE_CXX_COMPILER="${CXX}" -DCMAKE_MESSAGE_LOG_LEVEL="WARNING" -G "CodeBlocks - Unix Makefiles" -S ./ -B cmake-build-release $@
  fi
  make -s -C cmake-build-release clean
  make -s -C cmake-build-release
  if [[ "$?" -gt 0 ]]; then
    echo "[!] Failed to build iBoot64Patcher!"
    exit 1
  fi
  if type -P llvm-strip &>/dev/null; then
    llvm-strip -s cmake-build-release/src/iBoot64Patcher
  else
    echo "[!] llvm-strip not installed or not found, not stripping release binary."
  fi
  echo "[*] Run make -C cmake-build-release install, to install iBoot64Patcher or obtain the binary at cmake-build-release/src/iBoot64Patcher"
  echo "[*] Successfully built iBoot64Patcher."
else
  if [[ ! "$NO_CLEAN" == "1" ]]; then 
    cmake -DCMAKE_INSTALL_PREFIX="${FR_INSTALL_DIR}" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MAKE_PROGRAM="$(which make)" -DCMAKE_C_COMPILER="${CC}" -DCMAKE_CXX_COMPILER="${CXX}" -G "CodeBlocks - Unix Makefiles" -S ./ -B cmake-build-debug $@
  fi
  make -s -C cmake-build-debug clean
  make -s -C cmake-build-debug
  if [[ "$?" -gt 0 ]]; then
    echo "[!] Failed to build iBoot64Patcher!"
    exit 1
  fi
  echo "[*] Run make -C cmake-build-debug install, to install iBoot64Patcher or obtain the binary at cmake-build-debug/src/iBoot64Patcher"
  echo "[*] Successfully built iBoot64Patcher."
fi
