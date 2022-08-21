with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz"){};
runCommand "ffi" {
    buildInputs = [
        pkgsCross.mingwW64.pkgsBuildTarget.gcc
        pkgsCross.mingwW64.pkgsBuildTarget.libffi
        pkgsCross.mingwW64.pkgsBuildTarget.gmp
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc941
        pkgsCross.mingwW64.pkgsBuildTarget.haskell.compiler.ghc941
        # (pkgsMusl.haskell.compiler.ghc941.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
    ];
} ""