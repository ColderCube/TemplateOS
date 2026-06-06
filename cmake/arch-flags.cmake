if(ARCH STREQUAL "x86_64")
    set(ARCH_FLAGS
        -m64
        -march=x86-64
        -mno-80387
        -mno-mmx
        -mno-sse
        -mno-sse2
        -mno-red-zone
        -mcmodel=kernel
    )
    set(ARCH_LINKER_FLAGS
        -Wl,-m,elf_x86_64
    )
elseif(ARCH STREQUAL "aarch64")
    set(ARCH_FLAGS
        -march=armv8-a
        -mgeneral-regs-only
        -fno-pic
    )
    set(ARCH_LINKER_FLAGS
        -Wl,-m,aarch64elf
    )
elseif(ARCH STREQUAL "riscv64")
    set(ARCH_FLAGS
        -march=rv64gc
        -mabi=lp64d
        -mcmodel=medany
    )
    set(ARCH_LINKER_FLAGS
        -Wl,-m,elf64lriscv
    )
elseif(ARCH STREQUAL "loongarch64")
    set(ARCH_FLAGS
        -march=loongarch64
        -mabi=lp64d
        -mcmodel=extreme
    )
    set(ARCH_LINKER_FLAGS
        -Wl,-m,elf64loongarch
    )
endif()
