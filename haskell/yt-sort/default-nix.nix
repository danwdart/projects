{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    inherit nixpkgs;
    inherit compiler;
  },
  compiler ? "ghc912"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  inherit (nixpkgs.pkgs.haskell) lib;
  tools = haskell-tools compiler;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      yt-sort = lib.dontHaddock (self.callCabal2nix "yt-sort" (gitignore ./.) {});
      
      gogol = lib.doJailbreak (self.callCabal2nixWithOptions "gogol" (builtins.fetchGit {
        url = "https://github.com/brendanhay/gogol.git";
        rev = "4c1e9b5c7281266b246a8630c9cd714474189283";
      }) "--subpath lib/gogol" {});

      gogol-core = lib.doJailbreak (self.callCabal2nixWithOptions "gogol-core" (builtins.fetchGit {
        url = "https://github.com/brendanhay/gogol.git";
        rev = "4c1e9b5c7281266b246a8630c9cd714474189283";
      }) "--subpath lib/gogol-core" {});

      gogol-youtube = lib.doJailbreak (self.callCabal2nixWithOptions "gogol-youtube" (builtins.fetchGit {
        url = "https://github.com/brendanhay/gogol.git";
        rev = "4c1e9b5c7281266b246a8630c9cd714474189283";
      }) "--subpath lib/services/gogol-youtube" {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.yt-sort
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables myHaskellPackages.yt-sort;
in
{
  inherit shell;
  yt-sort = lib.justStaticExecutables myHaskellPackages.yt-sort;
}