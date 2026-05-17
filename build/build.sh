#!/bin/bash
# common-logger/build/build.sh
# Usage:
#   ./build.sh Release          # default: RK3568 cross build
#   ./build.sh Debug            # default: RK3568 cross build
#   ./build.sh Release OFF      # host build
#   ./build.sh Release ON /path/to/toolchain.cmake
#   ./build.sh clean

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)
BUILD_DIR=${SCRIPT_DIR}/output
OUTPUT_DIR=${PROJECT_ROOT}/output

BUILD_TYPE=${1:-"Release"}
CROSS_COMPILE=${2:-"ON"}
TOOLCHAIN_FILE=${3:-"${SCRIPT_DIR}/rk3568.cmake"}

if [ "${BUILD_TYPE}" = "clean" ]; then
    echo -e "${YELLOW}=== Cleaning common-logger build/output ===${NC}"
    rm -rf "${BUILD_DIR}" "${OUTPUT_DIR}"
    echo -e "${GREEN}Clean finished${NC}"
    exit 0
fi

if [ "${BUILD_TYPE}" != "Debug" ] && [ "${BUILD_TYPE}" != "Release" ]; then
    echo -e "${RED}BUILD_TYPE must be Debug or Release${NC}"
    exit 1
fi

if [ ! -f "${PROJECT_ROOT}/CMakeLists.txt" ]; then
    echo -e "${RED}CMakeLists.txt not found in project root: ${PROJECT_ROOT}${NC}"
    echo -e "${RED}Please run this script from common-logger/build, or check the script location.${NC}"
    exit 1
fi

mkdir -p "${BUILD_DIR}" "${OUTPUT_DIR}"
cd "${BUILD_DIR}"

cmake_args=(
    "${PROJECT_ROOT}"
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"
    -DCMAKE_INSTALL_PREFIX="${OUTPUT_DIR}"
)

if [ "${CROSS_COMPILE}" = "ON" ]; then
    if [ ! -f "${TOOLCHAIN_FILE}" ]; then
        echo -e "${RED}Toolchain file not found: ${TOOLCHAIN_FILE}${NC}"
        exit 1
    fi
    cmake_args+=( -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" )
    echo -e "${YELLOW}Cross compile enabled: ${TOOLCHAIN_FILE}${NC}"
else
    echo -e "${YELLOW}Using host compiler${NC}"
fi

echo -e "${YELLOW}=== CMake configure: type=${BUILD_TYPE} ===${NC}"
echo "Source: ${PROJECT_ROOT}"
echo "Build:  ${BUILD_DIR}"
echo "Output: ${OUTPUT_DIR}"
cmake "${cmake_args[@]}"

echo -e "${YELLOW}=== Toolchain info ===${NC}"
echo "C compiler:   $(grep '^CMAKE_C_COMPILER:FILEPATH=' CMakeCache.txt | cut -d= -f2-)"
echo "CXX compiler: $(grep '^CMAKE_CXX_COMPILER:FILEPATH=' CMakeCache.txt | cut -d= -f2-)"
echo "Sysroot:      $(grep '^CMAKE_SYSROOT:PATH=' CMakeCache.txt | cut -d= -f2-)"
echo "System:       $(grep '^CMAKE_SYSTEM_NAME:INTERNAL=' CMakeCache.txt | cut -d= -f2-)"

echo -e "${YELLOW}=== Building common-logger ===${NC}"
cmake --build . -- -j"$(nproc)"

echo -e "${YELLOW}=== Installing to output ===${NC}"
cmake --build . --target install

echo -e "${GREEN}=== Build succeeded ===${NC}"
echo "Include: ${OUTPUT_DIR}/include"
echo "Library: ${OUTPUT_DIR}/lib"
ls -l "${OUTPUT_DIR}/include" "${OUTPUT_DIR}/lib"
