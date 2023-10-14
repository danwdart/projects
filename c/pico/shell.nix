with import <nixpkgs> {};
runCommand "pico" {
     # else pyw43 doesn't get inited - fix?
    shellHook = ''
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
    BOARD = "pico-w";
    PICO_BOARD = "pico_w";
    PICO_SDK_PATH = "${pico-sdk.outPath}/lib/pico-sdk";
} ""
