#!/usr/bin/env bash
set -euo pipefail
# Show where we were when there was a problem.
# TODO
trap pwd ERR

nix-build -o result/jsaddle-stuff/ghc -A ghc.jsaddle-stuff
nix-build -o result/reflex-stuff/ghc -A ghc.reflex-stuff

nix-build -o result/ghcjs-stuff/ghcjs -A ghcjs.ghcjs-stuff
nix-build -o result/jsaddle-stuff/ghcjs -A ghcjs.jsaddle-stuff
nix-build -o result/reflex-stuff/ghcjs -A ghcjs.reflex-stuff # cache broken

nix-build -o result/reflex-stuff/android -A android.reflex-stuff

nix-store -qR --include-outputs $(nix-instantiate -A shells.ghc) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate -A shells.ghc) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate -A shells.ghcjs) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate -A shells.ghcjs) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate -A ghc.jsaddle-stuff) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate -A ghc.jsaddle-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate -A ghc.reflex-stuff) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate -A ghc.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.ghcjs-stuff) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.ghcjs-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.jsaddle-stuff) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.jsaddle-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.reflex-stuff) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
# nix-store -qR --include-outputs $(nix-instantiate -A android.reflex-stuff) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate -A android.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com

# TODO figure out how to make this not have to boot and take ages
#nix-build -o result/basestuff-wasm -A wasm.basestuff
#nix-build -o result/ghcjs-stuff-wasm -A wasm.ghcjs-stuff
#nix-build -o result/jsaddle-stuff-wasm -A wasm.jsaddle-stuff
#nix-build -o result/reflexstuff-wasm -A wasm.reflexstuff