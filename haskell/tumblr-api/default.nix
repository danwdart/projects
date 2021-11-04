{ nixpkgs ? import(builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc901" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      humblr = self.callCabal2nix "humblr" (builtins.fetchGit {
        url = "https://github.com/danwdart/humblr.git";
        rev = "22b065ead87cb1c3c19545c54f8ff90fb1e314e9";
      }) {};
      tumblr-api = self.callCabal2nix "tumblr-api" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.tumblr-api
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with nixpkgs; with haskellPackages; [
      apply-refact
      cabal-install
      ghcid
      hlint
      implicit-hie
      krank
      stan
      stylish-haskell
      weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.tumblr-api);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  tumblr-api = myHaskellPackages.tumblr-api;
}
