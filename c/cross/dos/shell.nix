with import <nixpkgs> {};
runCommand "cross-dos" {
    buildInputs = [
      open-watcom-v2
      djgpp_i686
    ];
} ""
