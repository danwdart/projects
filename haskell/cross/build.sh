#!/bin/sh
# Not doing this within a nix shell because this is meant to have examples.
mkdir -p build

echo "Linux aarch64"

nix-shell -p \
    pkgsCross.aarch64-multiplatform.pkgsBuildHost.ghc \
    pkgsCross.aarch64-multiplatform.pkgsBuildHost.gcc \
    pkgsCross.aarch64-multiplatform.pkgsHostHost.gmp \
    --run "aarch64-unknown-linux-gnu-ghc src/Main.hs -o build/linux-aarch64-main"

nix-shell -p qemu --run "qemu-aarch64 build/linux-aarch64-main"

echo "Linux riscv64"

nix-shell -p \
    pkgsCross.riscv64.pkgsBuildHost.ghc \
    pkgsCross.riscv64.pkgsBuildHost.gcc \
    pkgsCross.riscv64.pkgsHostHost.gmp \
    --run "riscv64-unknown-linux-gnu-ghc src/Main.hs -o build/linux-riscv64-main"

nix-shell -p qemu --run "qemu-riscv64 build/linux-riscv64-main"