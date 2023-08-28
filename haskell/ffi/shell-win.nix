with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsCross.mingwW64.pkgsBuildHost.gcc
        pkgsCross.mingwW64.pkgsBuildHost.libffi
        pkgsCross.mingwW64.pkgsBuildHost.gmp
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildHost.haskell.compiler.ghc94
        pkgsCross.mingwW64.pkgsBuildHost.haskell.compiler.ghc94
        # (pkgsMusl.haskell.compiler.ghc94.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
    ];
} ""