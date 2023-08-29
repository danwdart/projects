with import <nixpkgs> {};
runCommand "sls2" {
    buildInputs = [
        haskell.packages.ghc94.cabal-install
        # haskell.compiler.ghcjs
        nodejs_18
        gcc
        doctl
    ] ++ (if builtins.currentSystem == "aarch64-linux" then [
        # This is somehow wrong as it gives a `ghc` and not a cross platform ghc compiler.
        #(pkgsCross.gnu64.pkgsBuildHost.haskell.packages.ghc94.ghcWithPackages (ghc: with ghc; [
        #    aeson
        #]))
        # So is this, so it's probably a bug.
        #(pkgsCross.gnu64.pkgsBuildTarget.haskell.packages.ghc94.ghcWithPackages (ghc: with ghc; [
        #    aeson
        #]))
        # We're stuck with this which is somehow okay but doesn't touch the packages above
        # 9.6 dies at building p11kit because it's trying to run a test when it shouldn't be
        pkgsCross.gnu64.pkgsBuildHost.haskell.compiler.ghc94
        # Probably because this is what we actually want to be able to look at... but it's not cached right now so I can't work on it.
        pkgsCross.gnu64.pkgsHostHost.haskell.packages.ghc94.aeson
        pkgsCross.gnu64.pkgsBuildHost.gcc
        # pkgsCross.gnu64.pkgsHostHost.glibc
        pkgsCross.gnu64.pkgsHostHost.gmp
        pkgsCross.gnu64.pkgsHostHost.libffi
    ] else [
        (haskell.packages.ghc94.ghcWithPackages (ghc: with ghc; [
            aeson
            cabal-install
        ]))
    ]);
    # cp ${pkgsCross.gnu64.pkgsHostHost.libffi.outPath}/lib64/libffi.so.8.1.2 packages/sample/hello/libffi.so.8
    # cp ${pkgsCross.gnu64.pkgsHostHost.gmp.outPath}/lib64/libgmp.so.10.4.1 packages/sample/hello/libgmp.so.10
    # cp ${pkgsCross.gnu64.pkgsHostHost.glibc.outPath}/libc.so.6 packages/sample/hello/libc.so.6
    # cp ${pkgsCross.gnu64.pkgsHostHost.glibc.outPath}/libm.so.6 packages/sample/hello/libm.so.6
    # cp ${pkgsCross.gnu64.pkgsHostHost.glibc.outPath}/librt.so.1 packages/sample/hello/librt.so.1
    # cp ${pkgsCross.gnu64.pkgsHostHost.glibc.outPath}/libdl.so.2 packages/sample/hello/libdl.so.2
    # 
    shellHook = ''
        # x86_64-unknown-linux-gnu-ghc src/Main.hs -ilib -o packages/sample/hello/sls2
        # rm src/Main src/Main.{hi,o}

        #cabal new-build

        #cp $(cabal exec which sls2) packages/sample/hello/sls2
        #x86_64-unknown-linux-gnu-strip packages/sample/hello/sls2
        #patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 packages/sample/hello/sls2

        cp ${pkgsCross.gnu64.pkgsHostHost.libffi.outPath}/lib64/libffi.so.8.1.2 packages/sample/hello/libffi.so.8
        cp ${pkgsCross.gnu64.pkgsHostHost.gmp.outPath}/lib/libgmp.so.10.4.1 packages/sample/hello/libgmp.so.10
        cp /nix/store/flf14c3ibr83jsa070j25hg5gjapydhl-glibc-2.37-8/lib/{libc.so.6,libm.so.6,librt.so.1,libdl.so.2,ld-linux-x86-64.so.2} packages/sample/hello/
        patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 packages/sample/hello/libc.so.6

        # wget -c https://raw.githubusercontent.com/oufm/packelf/master/packelf.sh
        # chmod +x packelf.sh
        # export GHC=${if builtins.currentSystem == "aarch64-linux" then "x86_64-unknown-linux-ghc" else "ghc"}
    '';
} ""

