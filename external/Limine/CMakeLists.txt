# Build Limine host tool
add_executable(limine-tool limine.c)
set_target_properties(limine-tool PROPERTIES OUTPUT_NAME limine)

# Use host compiler settings
set_target_properties(limine-tool PROPERTIES
    COMPILE_FLAGS "${HOST_CFLAGS}"
)
# We might need to ensure it uses the host compiler if we are cross-compiling, 
# but for now let's keep it simple as the root CMakeLists.txt sets clang.
