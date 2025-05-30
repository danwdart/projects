with (import (builtins.fetchTarball {
  url = "https://github.com/dmjio/miso/archive/refs/tags/1.8.3.tar.gz";
  # url = "https://github.com/dmjio/miso/archive/refs/heads/master.tar.gz";
}) {});
pkgs.haskell.packages.ghcjs.callCabal2nix "misostuff" ./. {}