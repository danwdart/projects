{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc884",
  ghcjs ? "ghcjs86"}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${ghcjs}.override {
    overrides = self: super: rec {
      entropy = self.callCabal2nix "entropy" (builtins.fetchGit {
        url = "https://github.com/TomMD/entropy.git";
        rev = "a43996e285e5afdfe933f160d611439581a453a0";
      }) {};
      network = self.callCabal2nix "network" (builtins.fetchGit {
        url = "https://github.com/haskell/network.git";
        ref = "v2.8.0.0";
      }) {};
      foundation = self.callCabal2nix "foundation" (builtins.fetchGit {
        url = "https://github.com/haskell-foundation/foundation.git";
        rev = "58568e9f5368170d272000ecf16ef64fb91d0732";
      }) {};
      jsaddle-stuff = self.callCabal2nix "jsaddle-stuff" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.jsaddle-stuff
    ];
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.wget
      nixpkgs.haskellPackages.stack
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    # withHoogle = true;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.jsaddle-stuff);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  jsaddle-stuff = myHaskellPackages.jsaddle-stuff;
}