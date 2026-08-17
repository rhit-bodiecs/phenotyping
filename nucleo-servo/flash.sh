#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build"
ELF_NAME="nucleo-servo.elf"

PROGRAMMER="/mnt/c/Program Files/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32_Programmer_CLI.exe"

cmake -S . -B "$BUILD_DIR" -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE=cmake/gcc-arm-none-eabi.cmake \
  -DCMAKE_BUILD_TYPE=Debug

cmake --build "$BUILD_DIR"

elf_path="$(find "$BUILD_DIR" -type f -name "$ELF_NAME" -print -quit)"

if [[ -z "$elf_path" ]]; then
    echo "Error: could not find $ELF_NAME under $BUILD_DIR" >&2
    exit 1
fi

windows_elf_path="$(wslpath -w "$(realpath "$elf_path")")"

"$PROGRAMMER" \
    -c port=SWD \
    -w "$windows_elf_path" \
    -v \
    -rst
