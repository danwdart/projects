with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
runCommand "ffi" {
    buildInputs = [
        pkgsCross.mingwW64.pkgsBuildHost.gcc
        pkgsCross.mingwW64.pkgsBuildHost.libffi
        pkgsCross.mingwW64.pkgsBuildHost.gmp
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildHost.haskell.compiler.ghc914
        pkgsCross.mingwW64.pkgsBuildHost.haskell.compiler.ghc914
        # (pkgsMusl.haskell.compiler.ghc914.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
    ];
} ""