# TemplateOS

A starting point for OS development, written in C and C++. Uses the
[Limine bootloader](https://github.com/limine-bootloader/limine) and supports
x86_64, aarch64, riscv64, and loongarch64.

> **Note:** The build system hardcodes `clang`/`clang++` and `ld.lld`.
> GCC is not supported without modifying `CMakeLists.txt`.

## Prerequisites

- `clang`, `clang++`, `ld.lld`
- `cmake` 3.28+
- `xorriso`, `mtools`, `libisoburn` — ISO and HDD image generation
- `sgdisk` (from `gdisk`) — HDD image only
- `qemu-system-<arch>` — for running/debugging
- OVMF firmware files in `external/edk2-ovmf/` — UEFI boot only
- A cross-compiler if building for a non-host architecture

## Getting Started

Clone with submodules:

```bash
git clone --recursive https://github.com/your-username/TemplateOS.git
cd TemplateOS
```

Already cloned without `--recursive`?
```bash
git submodule update --init --recursive
```

Configure (defaults to x86_64):

```bash
mkdir build && cd build
cmake ..
```

To target a different architecture:
```bash
cmake -DARCH=aarch64 ..
```

Supported: `x86_64`, `aarch64`, `riscv64`, `loongarch64`.

## Build Targets

| Target | What it does |
|---|---|
| `make iso` | Compiles the kernel and produces `TemplateOS.iso` |
| `make hdd` | Produces a raw 64MB GPT HDD image (`TemplateOS.hdd`) |
| `make run` | Runs the ISO in QEMU (BIOS) |
| `make run-uefi` | Runs the ISO in QEMU (UEFI, requires OVMF) |
| `make debug` | Launches QEMU in GDB wait mode (BIOS) |
| `make debug-uefi` | Launches QEMU in GDB wait mode (UEFI) |
| `make gdb-connect` | Connects GDB, loads symbols, breaks at `kmain` |

`run`, `run-uefi`, `debug`, `debug-uefi` all depend on `iso` — they will build it first if needed.

QEMU serial output goes to stdio. Kernel `printf`/serial writes appear in your terminal.

To pass extra QEMU flags (e.g. `-enable-kvm`, `-smp 4`):
```bash
cmake -DQEMU_EXTRA_FLAGS="-enable-kvm -smp 4" ..
```

## Debugging

```bash
make debug        # launches QEMU, waits for GDB on :1234
make gdb-connect  # in a separate terminal — connects GDB and breaks at kmain
```

## Required Files

These must exist or `make iso`/`make hdd` will fail:

- `limine.conf` — Limine boot configuration (repo root)
- `kernel/data/zap-light16.psf` — PSF1 font used by the renderer

## Project Layout

- `kernel/src/boot/main.cpp` — Limine entry point
- `kernel/src/core/` — kernel initialization and main logic
- `kernel/src/render/BasicRenderer` — framebuffer renderer
- `external/` — submodules: `limine-protocol`, `cc-runtime`,
  `freestnd-c`, `freestnd-cxx`, `Limine`, `edk2-ovmf`
- `linker-scripts/` — per-architecture memory layout (`<arch>.lds`)
- `cmake/arch-flags.cmake` — per-arch compiler and linker flags
- `cmake/kernel-flags.cmake` — freestanding kernel compile options
- `cmake/image.cmake` — ISO and HDD image generation
- `cmake/qemu.cmake` — QEMU run, debug, and GDB targets

> The kernel builds with `-ffreestanding -nostdinc -nostdlib -fno-exceptions
> -fno-rtti`. Standard library APIs are not available.

## Acknowledgments

- Based on the [Limine C++ Template](https://github.com/Limine-Bootloader/limine-cxx-template)
- Built with reference to the [OSDev Wiki](https://wiki.osdev.org/)
- Uses the [Limine Protocol](https://github.com/limine-bootloader/limine-protocol)
