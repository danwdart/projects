with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
runCommand "ffi" {
    buildInputs = [
        pkgsStatic.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildHost.haskell.compiler.ghc914
        # pkgsCross.x86_64-embedded.pkgsBuildHost.haskell.compiler.ghc914
        #pkgsStatic.pkgsBuildHost.haskell.compiler.ghc914
        (pkgsMusl.haskell.compiler.ghc914.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
        cabal-install
    ];
} ""