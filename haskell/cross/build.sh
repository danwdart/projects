#!/bin/sh
set -euo pipefail


# Not doing this within a nix shell because this is meant to have examples.
mkdir -p build

if [[ "$(uname -m)" != "x86_64" ]]
then
    echo "Linux x86_64"

    nix-shell -p \
        pkgsCross.gnu64.pkgsBuildHost.ghc \
        pkgsCross.gnu64.pkgsBuildHost.gcc \
        pkgsCross.gnu64.pkgsHostHost.gmp \
        --run "x86_64-unknown-linux-gnu-ghc src/Main.hs -o build/linux-x86_64-main"

    nix-shell -p qemu --run "qemu-x86_64 build/linux-x86_64-main"
fi

if [[ "$(uname -m)" != "aarch64" ]]
then
    echo "Linux aarch64"

    nix-shell -p \
        pkgsCross.aarch64-multiplatform.pkgsBuildHost.ghc \
        pkgsCross.aarch64-multiplatform.pkgsBuildHost.gcc \
        pkgsCross.aarch64-multiplatform.pkgsHostHost.gmp \
        --run "aarch64-unknown-linux-gnu-ghc src/Main.hs -o build/linux-aarch64-main"

    nix-shell -p qemu --run "qemu-aarch64 build/linux-aarch64-main"
fi

if [[ "$(uname -m)" != "riscv64" ]]
then
    echo "Linux riscv64"

    nix-shell -p \
        pkgsCross.riscv64.pkgsBuildHost.ghc \
        pkgsCross.riscv64.pkgsBuildHost.gcc \
        pkgsCross.riscv64.pkgsHostHost.gmp \
        --run "riscv64-unknown-linux-gnu-ghc src/Main.hs -o build/linux-riscv64-main"

    nix-shell -p qemu --run "qemu-riscv64 build/linux-riscv64-main"
fi