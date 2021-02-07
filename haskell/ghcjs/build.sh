#!/usr/bin/env bash
set -x
set +e

nix-build -o result-base-stuff-ghc -A ghc.base-stuff | cachix push websites
nix-build -o result-jsaddle-stuff-ghc -A ghc.jsaddle-stuff | cachix push websites
nix-build -o result-reflexstuff-ghc -A ghc.reflexstuff | cachix push websites

nix-build -o result-base-stuff-ghcjs -A ghcjs.base-stuff | cachix push websites
nix-build -o result-ghcjs-stuff-ghcjs  -A ghcjs.ghcjs-stuff | cachix push websites
nix-build -o result-jsaddle-stuff-ghcjs -A ghcjs.jsaddle-stuff | cachix push websites
nix-build -o result-reflexstuff-ghcjs -A ghcjs.reflexstuff | cachix push websites # cache broken

nix-build -o result-reflexstuff-android -A android.reflexstuff | cachix push websites

# TODO figure out how to make this not have to boot and take ages
#nix-build -o result-basestuff-wasm -A wasm.basestuff
#nix-build -o result-ghcjs-stuff-wasm -A wasm.ghcjs-stuff
#nix-build -o result-jsaddle-stuff-wasm -A wasm.jsaddle-stuff
#nix-build -o result-reflexstuff-wasm -A wasm.reflexstuff