cmake_minimum_required(VERSION 3.28)


set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_ASM_COMPILER clang)
set(CMAKE_LINKER ld.lld)

# Set project name and languages
project(MyOS LANGUAGES C CXX ASM)

# Add cmake directory to module path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

# Export compile commands for tooling (clangd, etc.)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(SUPPORTED_ARCHES x86_64 aarch64 riscv64 loongarch64)

set(ARCH "x86_64" CACHE STRING "Target architecture")
set_property(CACHE ARCH PROPERTY STRINGS ${SUPPORTED_ARCHES})

if(NOT ARCH IN_LIST SUPPORTED_ARCHES)
  message(FATAL_ERROR "Unsupported ARCH: ${ARCH}")
endif()

set(IMAGE_NAME "TemplateOS")

# Include architecture and kernel flags
include(arch-flags)
include(kernel-flags)

set(HOST_CC "cc" CACHE STRING "Host C compiler for building Limine")
set(HOST_CFLAGS "-g -O2 -pipe" CACHE STRING "Host C compiler flags")

# Set linker script path
set(LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/linker-scripts/${ARCH}.lds")

add_subdirectory(linker-scripts)

add_subdirectory(external)

add_subdirectory(kernel)

# Include image and QEMU targets
include(image)
include(qemu)
