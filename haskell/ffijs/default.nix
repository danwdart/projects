let haskellNix = import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz") {};
    pkgs = import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs;
in pkgs.haskell-nix.project {
        src = pkgs.haskell-nix.haskellLib.cleanGit {
        name = "ffijs";
        src = ./.;
    };
    compiler-nix-name = "ghc8107";
}
