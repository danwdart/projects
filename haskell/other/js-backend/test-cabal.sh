#!/usr/bin/env bash

ENV="From env before cabal" cabal new-build

ENV="From env before node" node dist-newstyle/build/javascript-ghcjs/ghc-9.8.2/js-backend-0.1.0.0/x/for-node/build/for-node/for-node

xdg-open dist-newstyle/build/javascript-ghcjs/ghc-9.8.2/js-backend-0.1.0.0/x/for-browser/build/for-browser/for-browser.jsexe/index.html