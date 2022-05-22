with import <unstable> {};
# with import <unstable> {};
runCommand "ffi" {
    buildInputs = [
        pkgsCross.mingwW64.pkgsBuildTarget.gcc
        pkgsCross.mingwW64.pkgsBuildTarget.libffi
        pkgsCross.mingwW64.pkgsBuildTarget.gmp
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc922
        pkgsCross.mingwW64.pkgsBuildTarget.haskell.compiler.ghc922
        # (pkgsMusl.haskell.compiler.ghc922.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
    ];
} ""