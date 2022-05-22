# with import <unstable> {};
with import <unstable> {};
runCommand "ffi" {
    buildInputs = [
        pkgsStatic.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc922
        # pkgsCross.x86_64-embedded.pkgsBuildTarget.haskell.compiler.ghc922
        #pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc922
        (pkgsMusl.haskell.compiler.ghc922.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
        cabal-install
    ];
} ""