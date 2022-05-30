# with import <unstable> {};
with import <unstable> {};
runCommand "ffi" {
    buildInputs = [
        pkgsStatic.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc923
        # pkgsCross.x86_64-embedded.pkgsBuildTarget.haskell.compiler.ghc923
        #pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc923
        (pkgsMusl.haskell.compiler.ghc923.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
        cabal-install
    ];
} ""