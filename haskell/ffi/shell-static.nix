with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsStatic.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildHost.haskell.compiler.ghc96
        # pkgsCross.x86_64-embedded.pkgsBuildHost.haskell.compiler.ghc96
        #pkgsStatic.pkgsBuildHost.haskell.compiler.ghc96
        (pkgsMusl.haskell.compiler.ghc96.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
        cabal-install
    ];
} ""