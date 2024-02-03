#!/usr/bin/env bash
set -euo pipefail
# Show where we were when there was a problem.
# TODO
trap pwd ERR

# nix-build -o result/ghcjs-stuff/ghc -A ghc.ghcjs-stuff 2>&1 | sed 's/^/ghc.ghcjs-stuff: /'
# nix-build -o result/reflex-stuff/ghc -A ghc.reflex-stuff 2>&1 | sed 's/^/ghc.reflex-stuff: /'

nix-build -o result/ghcjs-stuff/ghcjs -A ghcjs.ghcjs-stuff 2>&1 | sed 's/^/ghcjs.ghcjs-stuff: /'
nix-build -o result/reflex-stuff/ghcjs -A ghcjs.reflex-stuff 2>&1 | sed 's/^/ghcjs.reflex-stuff: /' # cache broken

# nix-build -o result/reflex-stuff/android -A android.reflex-stuff 2>&1 | sed 's/^/android.reflex-stuff: /'

# nix-store -qR --include-outputs $(nix-instantiate -A shells.ghc) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate -A shells.ghc) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/shell --indirect -A shells.ghcjs) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate -A shells.ghcjs) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
# nix-store -qR --include-outputs $(nix-instantiate -A ghc.reflex-stuff) | cachix push dandart
##nix-store -qR --include-outputs $(nix-instantiate -A ghc.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/ghcjs-stuff --indirect -A ghcjs.ghcjs-stuff) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.ghcjs-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/reflex-stuff --indirect -A ghcjs.reflex-stuff) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
# nix-store -qR --include-outputs $(nix-instantiate -A android.reflex-stuff) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate -A android.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com

# TODO figure out how to make this not have to boot and take ages
#nix-build -o result/basestuff-wasm -A wasm.basestuff
#nix-build -o result/ghcjs-stuff-wasm -A wasm.ghcjs-stuff
#nix-build -o result/jsaddle-stuff-wasm -A wasm.jsaddle-stuff
#nix-build -o result/reflexstuff-wasm -A wasm.reflexstuff