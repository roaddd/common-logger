# build/rk3568.cmake
# RK3568 cross compile toolchain.
set(TOOLCHAIN_PATH "/home/topeet/source_code/linux/rk356x_linux/rk356x_linux/prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin" CACHE PATH "RK3568 cross compiler bin path")
set(CROSS_COMPILE_PREFIX "aarch64-linux-gnu-" CACHE STRING "RK3568 cross compiler prefix")
set(RK3568_SYSROOT "/home/topeet/source_code/linux/rk356x_linux/rk356x_linux/buildroot/output/rockchip_rk3568/host/aarch64-buildroot-linux-gnu/sysroot" CACHE PATH "RK3568 target sysroot path")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER "${TOOLCHAIN_PATH}/${CROSS_COMPILE_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PATH}/${CROSS_COMPILE_PREFIX}g++")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_PATH}/${CROSS_COMPILE_PREFIX}as")
set(CMAKE_LINKER "${TOOLCHAIN_PATH}/${CROSS_COMPILE_PREFIX}ld")
set(CMAKE_SYSROOT "${RK3568_SYSROOT}")

set(CMAKE_C_FLAGS "-O2 -Wall -fPIC ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "-O2 -Wall -fPIC ${CMAKE_CXX_FLAGS}")

set(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
