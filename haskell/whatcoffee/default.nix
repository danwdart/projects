{ nixpkgs ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc901" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      whatcoffee = self.callCabal2nix "whatcoffee" (gitignore ./.) {};
      # for stan
      cabal-doctest = lib.doJailbreak (self.callCabal2nix "cabal-doctest" (builtins.fetchGit {
        url = "https://github.com/haskellari/cabal-doctest.git";
        rev = "2338f86cbba06366fca42f7c9640bc408c940e0b";
      }) {});
      text-short = self.callHackage "text-short" "0.1.4" {};
      colourista = lib.doJailbreak super.colourista;
      # for ghc 9.2.1
      # https://github.com/vincenthz/hs-memory/pull/87
      #memory = lib.doJailbreak (self.callCabal2nix "memory" (builtins.fetchGit {
      # url = "https://github.com/tfausak/hs-memory.git";
      #  ref = "3cf661a8a9a8ac028df77daa88e8d65c55a3347a";
      #}) {});
      # https://github.com/haskell-crypto/cryptonite/pull/354
      #cryptonite = lib.doJailbreak (self.callCabal2nix "cryptonite" (builtins.fetchGit {
      #  url = "https://github.com/josephcsible/cryptonite.git";
      #  ref = "3b081e3ad027b0550fc87f171dffecbb20dedafe";
      #}) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.whatcoffee
    ];
    buildInputs = with myHaskellPackages; with nixpkgs; with haskellPackages; [
      apply-refact
      cabal-install
      ghcid
      haskell-language-server
      hasktags
      hlint
      implicit-hie
      krank
      haskellPackages.stan # issue with 9.0.1
      stylish-haskell
      weeder
    ];
    # withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.whatcoffee);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  whatcoffee = myHaskellPackages.whatcoffee;
}
