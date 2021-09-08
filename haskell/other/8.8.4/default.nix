{ nixpkgs ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc884" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      inline-asm = self.callHackage "inline-asm" "0.4.0.2" {};
      # https://github.com/brendanhay/gogol/issues/148
      gogol-core = self.callCabal2nixWithOptions "gogol-core" (builtins.fetchGit { # not yet released
        url = "https://github.com/brendanhay/gogol";
        rev = "d7c7d71fc985cd96fb5f05173da6c607da362b74";
      }) "--subpath core" {};
      other884 = self.callCabal2nix "other884" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other884
    ];
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.wget
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = true;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.other884);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other884 = myHaskellPackages.other884;
}