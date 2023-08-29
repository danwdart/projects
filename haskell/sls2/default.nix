{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc94"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgsCross.gnu64.haskell.lib;
  myHaskellPackages = nixpkgs.pkgsCross.gnu64.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      sls2 = lib.dontHaddock (self.callCabal2nix "sls2" (gitignore ./.) {});
      # Tests for aeson don't work because they should be run as host
      # "Couldn't find a target code interpreter. Try with -fexternal-interpreter"
      aeson = lib.dontCheck super.aeson;
    };
   };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.sls2
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done

      build() {
          nix-build -A sls2 -o build
          for PACKAGE in packages/*/*/
          do
              rm -rf $PACKAGE/sls2
              cp build/bin/sls2 $PACKAGE/sls2
              rm -rf $PACKAGE/*.so*
              cp ${nixpkgs.pkgsCross.gnu64.pkgsHostHost.libffi.outPath}/lib64/libffi.so.8.1.2 $PACKAGE/libffi.so.8
              cp ${nixpkgs.pkgsCross.gnu64.pkgsHostHost.gmp.outPath}/lib/libgmp.so.10.5.0 $PACKAGE/libgmp.so.10
              cp ${nixpkgs.pkgsCross.gnu64.glibc.outPath}/lib/{libc.so.6,libm.so.6,librt.so.1,libdl.so.2,ld-linux-x86-64.so.2} $PACKAGE/
              #x86_64-unknown-linux-gnu-strip $PACKAGE/sls2
              chmod +w $PACKAGE/*
              patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $PACKAGE/libc.so.6
          done
      }

      [[ -f packages/sls2/debug/libc.so.6 ]] || build

      # wget -c https://raw.githubusercontent.com/oufm/packelf/master/packelf.sh
      # chmod +x packelf.sh
      # export GHC=${if builtins.currentSystem == "aarch64-linux" then "x86_64-unknown-linux-ghc" else "ghc"}
    '';
    buildInputs = tools.defaultBuildTools ++ (with nixpkgs; [
        nodejs_20
        closurecompiler
        cabal-install
        pkgsCross.gnu64.pkgsBuildHost.gcc
        pkgsCross.gnu64.pkgsHostHost.gmp
        pkgsCross.gnu64.pkgsHostHost.libffi
        pkgsCross.gnu64.pkgsHostHost.glibc
    ]);
    nativeBuildInputs = tools.defaultBuildTools ++ (with nixpkgs; [
        nodejs_20
        closurecompiler
        cabal-install
        pkgsCross.gnu64.pkgsBuildHost.gcc
        pkgsCross.gnu64.pkgsHostHost.gmp
        pkgsCross.gnu64.pkgsHostHost.libffi
        pkgsCross.gnu64.pkgsHostHost.glibc
    ]);
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.sls2);
in
{
  inherit shell;
  sls2 = lib.justStaticExecutables (myHaskellPackages.sls2);
}
