with import <nixpkgs> {};
runCommand "uefi" {
    buildInputs = [
      gcc
      OVMFFull.fd
      qemu
    ];
} ""
