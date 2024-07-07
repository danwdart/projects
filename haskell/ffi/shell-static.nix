with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsStatic.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildHost.haskell.compiler.ghc98
        # pkgsCross.x86_64-embedded.pkgsBuildHost.haskell.compiler.ghc98
        #pkgsStatic.pkgsBuildHost.haskell.compiler.ghc98
        (pkgsMusl.haskell.compiler.ghc98.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
        cabal-install
    ];
} ""