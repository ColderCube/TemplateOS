# Common kernel flags
set(KERNEL_COMPILE_OPTIONS
    -g
    -gdwarf-4
    -Wall
    -Wextra
    -nostdinc
    -ffreestanding
    -fno-stack-protector
    -fno-stack-check
    -fno-lto
    -fno-pic
    -fno-pie
    -fno-omit-frame-pointer
    -ffunction-sections
    -fdata-sections
)

# C++ specific flags
set(KERNEL_CXX_COMPILE_OPTIONS
    -fno-rtti
    -fno-exceptions
    -fno-use-cxa-atexit
    -fno-threadsafe-statics
)

# Linker flags
set(KERNEL_LINK_OPTIONS
    -nostdlib
    -static
    -Wl,-z,max-page-size=0x1000
    -Wl,--gc-sections
)
