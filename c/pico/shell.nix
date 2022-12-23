with import <nixpkgs> {};
runCommand "pico" {
    # export PICO_SDK_PATH=${pico-sdk.outPath}/lib/pico-sdk # else pyw43 doesn't get inited - fix?
    shellHook = ''
      export PICO_SDK_FETCH_FROM_GIT=on
      export BOARD=pico-w
      export PICO_BOARD=pico_w
    '';
    buildInputs = [
      # binutils
      cmake
      gcc
      gcc-arm-embedded-10
      gnumake
      pico-sdk
      picotool
      python311
    ];
} ""
