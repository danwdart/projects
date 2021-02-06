#!/usr/bin/env bash
nix-build -o result-ghcjs-stuff  -A ghcjs.ghcjs-stuff
nix-build -o result-jsaddle-stuff -A ghcjs.jsaddle-stuff
nix-build -o result-misostuff -A ghcjs.misostuff
nix-build -o result-reflexstuff -A ghcjs.reflexstuff

nix-bulid -o result-jsaddle-stuff-ghc -A ghc.jsaddle-stuff
nix-build -o result-reflexstuff-ghc -A ghc.reflexstuff

nix-build -o result-android -A android.reflexstuff