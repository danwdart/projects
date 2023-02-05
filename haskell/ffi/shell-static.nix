with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsStatic.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc92
        # pkgsCross.x86_64-embedded.pkgsBuildTarget.haskell.compiler.ghc92
        #pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc92
        (pkgsMusl.haskell.compiler.ghc92.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
        cabal-install
    ];
} ""