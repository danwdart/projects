{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc884",
  ghcjs ? "ghcjs86"}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
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