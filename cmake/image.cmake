# Image generation logic

set(ISO_ROOT "${CMAKE_BINARY_DIR}/iso_root")

# Target for ISO generation
add_custom_target(iso
    COMMAND ${CMAKE_COMMAND} -E make_directory ${ISO_ROOT}/boot
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:kernel> ${ISO_ROOT}/boot/kernel
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/kernel/data/zap-light16.psf ${ISO_ROOT}/boot/zap-light16.psf
    COMMAND ${CMAKE_COMMAND} -E make_directory ${ISO_ROOT}/boot/limine
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/limine.conf ${ISO_ROOT}/boot/limine/limine.conf
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/external/Limine/limine-bios.sys ${ISO_ROOT}/boot/limine/
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/external/Limine/limine-bios-cd.bin ${ISO_ROOT}/boot/limine/
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/external/Limine/limine-uefi-cd.bin ${ISO_ROOT}/boot/limine/
    COMMAND ${CMAKE_COMMAND} -E make_directory ${ISO_ROOT}/EFI/BOOT
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/external/Limine/BOOTX64.EFI ${ISO_ROOT}/EFI/BOOT/
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/external/Limine/BOOTIA32.EFI ${ISO_ROOT}/EFI/BOOT/
    COMMAND xorriso -as mkisofs -b boot/limine/limine-bios-cd.bin 
        -no-emul-boot -boot-load-size 4 -boot-info-table 
        --efi-boot boot/limine/limine-uefi-cd.bin 
        -efi-boot-part --efi-boot-image --protective-msdos-label 
        ${ISO_ROOT} -o ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.iso
    COMMAND $<TARGET_FILE:limine-tool> bios-install ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.iso
    DEPENDS kernel limine-tool
    COMMENT "Generating ISO image"
)

# Target for HDD generation
add_custom_target(hdd
    COMMAND ${CMAKE_COMMAND} -E rm -f ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd
    COMMAND dd if=/dev/zero bs=1M count=0 seek=64 of=${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd
    COMMAND sgdisk ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd -n 1:2048 -t 1:ef00 -n 2:34:2047 -t 2:ef02
    COMMAND $<TARGET_FILE:limine-tool> bios-install ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd
    COMMAND mformat -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M
    COMMAND mmd -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine
    COMMAND mcopy -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M $<TARGET_FILE:kernel> ::/boot/kernel
    COMMAND mcopy -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M ${CMAKE_SOURCE_DIR}/kernel/data/zap-light16.psf ::/boot/zap-light16.psf
    COMMAND mcopy -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M ${CMAKE_SOURCE_DIR}/limine.conf ::/boot/limine/limine.conf
    COMMAND mcopy -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M ${CMAKE_SOURCE_DIR}/external/Limine/limine-bios.sys ::/boot/limine/
    COMMAND mcopy -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M ${CMAKE_SOURCE_DIR}/external/Limine/BOOTX64.EFI ::/EFI/BOOT/
    COMMAND mcopy -i ${CMAKE_BINARY_DIR}/${IMAGE_NAME}.hdd@@1M ${CMAKE_SOURCE_DIR}/external/Limine/BOOTIA32.EFI ::/EFI/BOOT/
    DEPENDS kernel limine-tool
    COMMENT "Generating HDD image"
)
