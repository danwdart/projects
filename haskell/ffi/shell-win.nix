with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsCross.mingwW64.pkgsBuildHost.gcc
        pkgsCross.mingwW64.pkgsBuildHost.libffi
        pkgsCross.mingwW64.pkgsBuildHost.gmp
        # pkgsStatic.haskell.compiler.ghc9
        # unstable.pkgsStatic.pkgsBuildHost.haskell.compiler.ghc98
        pkgsCross.mingwW64.pkgsBuildHost.haskell.compiler.ghc98
        # (pkgsMusl.haskell.compiler.ghc98.overrideDerivation (f: { enableRelocatedStaticLibs = true; }))
    ];
} ""