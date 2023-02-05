with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsCross.mingwW64.pkgsBuildTarget.gcc
        pkgsCross.mingwW64.pkgsBuildTarget.libffi
        pkgsCross.mingwW64.pkgsBuildTarget.gmp
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildTarget.haskell.compiler.ghc92
        pkgsCross.mingwW64.pkgsBuildTarget.haskell.compiler.ghc92
        # (pkgsMusl.haskell.compiler.ghc92.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
    ];
} ""