{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc92"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgsCross.gnu64.haskell.lib;
  myHaskellPackages = nixpkgs.pkgsCross.gnu64.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      sls2 = lib.dontHaddock (self.callCabal2nix "sls2" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.sls2
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done

      # x86_64-unknown-linux-gnu-ghc src/Main.hs -ilib -o packages/sample/hello/sls2
      # rm src/Main src/Main.{hi,o}

      #cabal new-build

      #cp $(cabal exec which sls2) packages/sample/hello/sls2
      #x86_64-unknown-linux-gnu-strip packages/sample/hello/sls2
      #patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 packages/sample/hello/sls2

      cp ${nixpkgs.pkgsCross.gnu64.pkgsHostHost.libffi.outPath}/lib64/libffi.so.8.1.2 packages/sample/hello/libffi.so.8
      cp ${nixpkgs.pkgsCross.gnu64.pkgsHostHost.gmp.outPath}/lib/libgmp.so.10.4.1 packages/sample/hello/libgmp.so.10
      cp /nix/store/flf14c3ibr83jsa070j25hg5gjapydhl-glibc-2.37-8/lib/{libc.so.6,libm.so.6,librt.so.1,libdl.so.2,ld-linux-x86-64.so.2} packages/sample/hello/
      patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 packages/sample/hello/libc.so.6

      # wget -c https://raw.githubusercontent.com/oufm/packelf/master/packelf.sh
      # chmod +x packelf.sh
      # export GHC=${if builtins.currentSystem == "aarch64-linux" then "x86_64-unknown-linux-ghc" else "ghc"}

      # How do we do a command afterwards?
      # nix-build -A sls2 -o build
      # rm -rf packages/sample/hello/sls2
      # cp build/bin/sls2 packages/sample/hello/
    '';
    buildInputs = tools.defaultBuildTools ++ (with nixpkgs; [
        nodejs_20
        closurecompiler
        cabal-install
        pkgsCross.gnu64.pkgsBuildHost.gcc
        pkgsCross.gnu64.pkgsHostHost.gmp
        pkgsCross.gnu64.pkgsHostHost.libffi
    ]);
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.sls2);
in
{
  inherit shell;
  sls2 = lib.justStaticExecutables (myHaskellPackages.sls2);
}
