#!/usr/bin/env zsh

set -e
export WORKFLOW_ROOT=/Users/runner/work/iBoot64Patcher/iBoot64Patcher/.github/workflows
export DEP_ROOT=/Users/runner/work/iBoot64Patcher/iBoot64Patcher/dep_root
export BASE=/Users/runner/work/iBoot64Patcher/iBoot64Patcher/
export CC="$(xcrun --find clang)"
export CXX="$(xcrun --find clang++)"

cd /Users/runner/work/iBoot64Patcher/iBoot64Patcher/
rm -rf ${DEP_ROOT}/{lib,include}

# Build Release
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM="$(which make)" -DCMAKE_C_COMPILER="${CC}" -DCMAKE_CXX_COMPILER="${CXX}" -DCMAKE_MESSAGE_LOG_LEVEL="WARNING" -G "CodeBlocks - Unix Makefiles" -S ./ -B cmake-build-release -DARCH=x86_64,arm64 -DNO_PKGCFG=1
make -j4 -l4 -C cmake-build-release
llvm-strip -s cmake-build-release/iBoot64Patcher

# Build Debug
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MAKE_PROGRAM="$(which make)" -DCMAKE_C_COMPILER="${CC}" -DCMAKE_CXX_COMPILER="${CXX}" -DCMAKE_MESSAGE_LOG_LEVEL="WARNING" -G "CodeBlocks - Unix Makefiles" -S ./ -B cmake-build-debug -DARCH=x86_64,arm64 -DNO_PKGCFG=1
make -j4 -l4 -C cmake-build-debug
