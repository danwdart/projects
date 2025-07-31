with import <nixpkgs> {};
runCommand "cross-dos" {
    buildInputs = [
      dev86
      djgpp_i686
      open-watcom-v2
    ];
} ""
