# QEMU configuration and targets

set(QEMU_ARCH "x86_64")
if(ARCH STREQUAL "aarch64")
    set(QEMU_ARCH "aarch64")
elseif(ARCH STREQUAL "riscv64")
    set(QEMU_ARCH "riscv64")
elseif(ARCH STREQUAL "loongarch64")
    set(QEMU_ARCH "loongarch64")
endif()

set(QEMU_BINARY "qemu-system-${QEMU_ARCH}")

# Default QEMU flags
set(QEMU_FLAGS 
    -m 2G 
    -serial stdio 
    -boot d
)

if(ARCH STREQUAL "x86_64")
    list(APPEND QEMU_FLAGS -M q35)
endif()

# UEFI paths (can be customized)
set(OVMF_CODE "${CMAKE_SOURCE_DIR}/external/edk2-ovmf/ovmf-code-${ARCH}.fd")
set(OVMF_VARS "${CMAKE_SOURCE_DIR}/external/edk2-ovmf/ovmf-vars-${ARCH}.fd")

# Custom QEMU options from user
set(QEMU_EXTRA_FLAGS "" CACHE STRING "Extra flags for QEMU")

# Run target (BIOS)
add_custom_target(run
    COMMAND ${QEMU_BINARY} ${QEMU_FLAGS} -cdrom ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.iso ${QEMU_EXTRA_FLAGS}
    DEPENDS iso
    USES_TERMINAL
    COMMENT "Running LuminaOS in QEMU (BIOS)"
)

# Run target (UEFI)
add_custom_target(run-uefi
    COMMAND ${QEMU_BINARY} ${QEMU_FLAGS} 
        -drive if=pflash,unit=0,format=raw,file=${OVMF_CODE},readonly=on 
        -drive if=pflash,unit=1,format=raw,file=${OVMF_VARS} 
        -cdrom ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.iso 
        ${QEMU_EXTRA_FLAGS}
    DEPENDS iso
    USES_TERMINAL
    COMMENT "Running LuminaOS in QEMU (UEFI)"
)

# Debug target (BIOS)
add_custom_target(debug
    COMMAND ${QEMU_BINARY} ${QEMU_FLAGS} -S -s -cdrom ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.iso ${QEMU_EXTRA_FLAGS}
    DEPENDS iso
    USES_TERMINAL
    COMMENT "Debugging LuminaOS in QEMU (BIOS)"
)

# Debug target (UEFI)
add_custom_target(debug-uefi
    COMMAND ${QEMU_BINARY} ${QEMU_FLAGS} 
        -S -s
        -drive if=pflash,unit=0,format=raw,file=${OVMF_CODE},readonly=on 
        -drive if=pflash,unit=1,format=raw,file=${OVMF_VARS} 
        -cdrom ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.iso 
        ${QEMU_EXTRA_FLAGS}
    DEPENDS iso
    USES_TERMINAL
    COMMENT "Debugging LuminaOS in QEMU (UEFI)"
)

# GDB helper target
add_custom_target(gdb-connect
    COMMAND gdb -ex "set auto-load safe-path /" 
                -ex "file '$<TARGET_FILE:kernel>'" 
                -ex "directory '${CMAKE_SOURCE_DIR}/kernel/src'"
                -ex "target remote localhost:1234"
                -ex "break kmain"
    DEPENDS kernel
    USES_TERMINAL
    COMMENT "Connecting GDB to QEMU"
)
