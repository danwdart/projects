with import (builtins.fetchTarball {
  url = https://github.com/WebGHC/nixpkgs/archive/1ab030ae80d1383fba4850668ea899daf226adf6.tar.gz;
  sha256 = "1nvpxj6x78il35aj68111rfy5rxx77fz7ykg90ql7qnjf9h0fsym";
}) {};
runCommand "wasm" {
    buildInputs = [
        haskell.compiler.ghc881 # or ghcjs86
        cabal-install
        binaryen
        wabt
        wasm-strip
        # wasmer # not in webghc
        wasmtime
        webassemblyjs-cli
        webassemblyjs-repl
        ocamlPackages.wasm
        emscripten
        # wasilibc # unsupported system
        # llvm_13 # not in webghc
        # clang_12 # not in webghc
    ];
} ""