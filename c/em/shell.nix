with import <nixpkgs> {};
runCommand "em" {
    buildInputs = [
      emscripten
    ];
} ""
