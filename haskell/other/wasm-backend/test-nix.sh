#!/usr/bin/env bash

ENV="From env var before nix build" nix-build --argstr ENV 'From nix argstr'

ENV="From env var calling node" node result-2/bin/for-node

# xdg-open index.html