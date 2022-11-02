with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsStatic.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc942
        # pkgsCross.x86_64-embedded.pkgsBuildTarget.haskell.compiler.ghc942
        #pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc942
        (pkgsMusl.haskell.compiler.ghc942.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
        cabal-install
    ];
} ""