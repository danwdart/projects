with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {};
runCommand "static" {
    buildInputs = [
        pkgsMusl.gcc # or gcc
        musl
    ];
} ""