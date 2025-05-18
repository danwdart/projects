with import <nixpkgs> {};
# needs mkShell in order to use headers/etc. from deps! how do we do that from nix-shell 
mkShell rec {
    packages = [
        pkgsCross.ghcjs.pkgsBuildHost.haskell.compiler.ghc912
        cabal-install
        pkg-config
        zlib.dev
        nodejs
        emscripten
    ];
    shellHook = ''
        rm -rf /tmp/.cache
        cp -rp ${emscripten}/share/emscripten/cache /tmp/.cache
        chmod -R 777 /tmp/.cache
    '';
    EM_CONFIG = pkgs.writeText ".emscripten" ''
        EMSCRIPTEN_ROOT = '${emscripten}/share/emscripten'
        LLVM_ROOT = '${emscripten.llvmEnv}/bin'
        BINARYEN_ROOT = '${binaryen}'
        NODE_JS = '${nodejs}/bin/node'
        CACHE = '/tmp/.cache';
    '';
    # maybe we can include the copy to store stuff in here? as mkShell is a custom stdenv.mkDerivation
    # shellHook = ''
    #     export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
    #     export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"
    # '';
}