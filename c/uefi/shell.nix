with import <nixpkgs> {};
runCommand "uefi" {
    shellHook = ''
      [ -f OVMF_VARS.fd ] || cp ${OVMFFull.fd.outPath}/FV/OVMF_CODE.fd .
      [ -f OVMF_VARS.fd ] || cp ${OVMFFull.fd.outPath}/FV/OVMF_VARS.fd .
      chown $USER *.fd
      chmod +w *.fd
    '';
    buildInputs = [
      gcc
      OVMFFull.fd
      gnu-efi
      qemu
    ];
} ""
