# External dependencies

# Freestanding C headers
add_library(freestnd-c INTERFACE)
target_include_directories(freestnd-c SYSTEM INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/freestnd-c-hdrs/${ARCH}/include")

# Freestanding C++ headers
add_library(freestnd-cxx INTERFACE)
target_include_directories(freestnd-cxx SYSTEM INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/freestnd-cxx-hdrs/${ARCH}/include")

# Limine protocol
add_library(limine-protocol INTERFACE)
target_include_directories(limine-protocol INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/limine-protocol/include")

# CC-runtime
add_library(cc-runtime STATIC "${CMAKE_CURRENT_SOURCE_DIR}/cc-runtime/src/cc-runtime.c")
target_link_libraries(cc-runtime PUBLIC freestnd-c)
target_compile_options(cc-runtime PRIVATE ${ARCH_FLAGS} ${KERNEL_COMPILE_OPTIONS})

# Limine host tool (if needed for ISO creation)
add_subdirectory(Limine)
