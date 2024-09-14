#!/usr/bin/env bash
set -euo pipefail
# Show where we were when there was a problem.
# TODO
trap pwd ERR

# cabal new-update

mkdir -p result

mkdir -p result/ghcjs-stuff

nix-shell shell-ghcjs.nix --run 'ENV="Hi from Cabal" cabal new-build --ghcjs ./ghcjs-stuff/' 2>&1 | sed 's/^/cabal ghcjs.ghcjs-stuff: /'
nix-shell shell-ghc.nix --run 'ENV="Hi from Cabal" cabal new-build ./ghcjs-stuff/' 2>&1 | sed 's/^/cabal ghc.ghcjs-stuff: /'

# needs its own shell
# ENV="Hi from Cabal" cabal new-build ./ghcjs-stuff/ 2>&1 | sed 's/^/cabal ghc.ghcjs-stuff: /'
nix-shell shell-ghcjs.nix --run 'cabal new-build --ghcjs ./reflex-stuff/' 2>&1 | sed 's/^/cabal ghcjs.reflex-stuff: /'
nix-shell shell-ghc.nix --run 'cabal new-build ./reflex-stuff/' 2>&1 | sed 's/^/cabal ghc.reflex-stuff: /'

# ghcjs.ghcjs-stuff: haddock: Couldn't parse GHC options: -fbuilding-cabal-package -O -outputdir dist/build -odir dist/build/tmp-3815 -hidir dist/build/tmp-3815 -stubdir dist/build/tmp-3815 -i -idist/build -isrc -ilib -idist/build/autogen -idist/build/global-autogen -Idist/build/autogen -Idist/build/global-autogen -Idist/build -optP-DGHCJS_BROWSER -optP-D__HADDOCK_VERSION__=8107 -optP-include -optPdist/build/autogen/cabal_macros.h -this-unit-id ghcjs-stuff-0.1.0.0-LqHxdUDPYZJ8HBd0z7tPVJ -hide-all-packages -Wmissing-home-modules -no-user-package-db -package-db /build/tmp.5oUUl26cy8/package.conf.d -package-db dist/package.conf.inplace -package-id base-4.14.3.0-D0KSEBqJsPj2jV088Mzd5k -package-id ghcjs-base-0.2.0.3-7FzwNCL6iT1GrlwZ9umVZf -XHaskell2010 -XDerivingStrategies -XImportQualifiedPost -XUnicodeSyntax -Wall -Werror -haddock -threaded -rtsopts -with-rtsopts=-N -Weverything -Wno-unsafe -Wno-safe -Wno-missing-import-lists -Wno-missing-export-lists -Wno-implicit-prelude -dedupe
nix-build -o result/ghcjs-stuff/ghcjs --argstr ENV 'Set in nix-build' -A ghcjs.ghcjs-stuff 2>&1 | sed 's/^/ghcjs.ghcjs-stuff: /'

nix-build -o result/ghcjs-stuff/ghc --argstr ENV 'Set in nix-build' -A ghc.ghcjs-stuff 2>&1 | sed 's/^/ghc.ghcjs-stuff: /'

# not yet
# nix-build -o result/ghcjs-stuff/android --argstr ENV 'Set in nix-build' -A android.ghcjs-stuff 2>&1 | sed 's/^/android.ghcjs-stuff: /'

mkdir -p result/reflex-stuff

nix-build -o result/reflex-stuff/ghcjs -A ghcjs.reflex-stuff 2>&1 | sed 's/^/ghcjs.reflex-stuff: /'
nix-build -o result/reflex-stuff/ghc -A ghc.reflex-stuff 2>&1 | sed 's/^/ghc.reflex-stuff: /'

# Setup: can't find source for dom in .
# nix-build -o result/reflex-stuff/android -A android.reflex-stuff 2>&1 | sed 's/^/android.reflex-stuff: /'

nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/shell/ghc --indirect -A shells.ghc) | cachix push dandart 2>&1 | sed 's/^/push shells.ghc: /'
# nix-store -qR --include-outputs $(nix-instantiate -A shells.ghc) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/shell/ghcjs --indirect -A shells.ghcjs) | cachix push dandart 2>&1 | sed 's/^/push shells.ghcjs: /'
# nix-store -qR --include-outputs $(nix-instantiate -A shells.ghcjs) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
# can't have android shells (yet?)
# nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/shell/android --indirect -A shells.android) | cachix push dandart 2>&1 | sed 's/^/push shells.android: /'
# nix-store -qR --include-outputs $(nix-instantiate -A shells.android) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/ghcjs-stuff/ghcjs --indirect -A ghcjs.ghcjs-stuff) | cachix push dandart 2>&1 | sed 's/^/push ghcjs.ghcjs-stuff: /'
# nix-store -qR --include-outputs $(nix-instantiate -A ghcjs.ghcjs-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/ghcjs-stuff/ghc --indirect -A ghc.ghcjs-stuff) | cachix push dandart 2>&1 | sed 's/^/push ghc.ghcjs-stuff: /'
# nix-store -qR --include-outputs $(nix-instantiate -A ghc.ghcjs-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
# not yet
# nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/ghcjs-stuff/android --indirect -A android.ghcjs-stuff) | cachix push dandart 2>&1 | sed 's/^/push android.ghcjs-stuff: /'
# nix-store -qR --include-outputs $(nix-instantiate -A android.ghcjs-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/reflex-stuff/ghcjs --indirect -A ghcjs.reflex-stuff) | cachix push dandart 2>&1 | sed 's/^/push ghcjs.reflex-stuff: /'
# nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/reflex-stuff/ghcjs  -A ghcjs.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/reflex-stuff/ghc -A ghc.reflex-stuff) | cachix push dandart 2>&1 | sed 's/^/push ghc.reflex-stuff: /'
##nix-store -qR --include-outputs $(nix-instantiate -A ghc.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/reflex-stuff/android -A android.reflex-stuff) | cachix push dandart 2>&1 | sed 's/^/push android.reflex-stuff: /'
# nix-store -qR --include-outputs $(nix-instantiate --add-root result/gcroot/reflex-stuff/android -A android.reflex-stuff) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com

# TODO figure out how to make this not have to boot and take ages
# error: Unknown kernel: unknown
#nix-build -o result/basestuff-wasm -A wasm.basestuff
#nix-build -o result/ghcjs-stuff/wasm -A wasm.ghcjs-stuff
#nix-build -o result/jsaddle-stuff/wasm -A wasm.jsaddle-stuff
#nix-build -o result/reflexstuff-wasm -A wasm.reflexstuff