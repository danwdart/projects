{ nixpkgs ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc921" }: # bmp requires old bytestring 
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      bmp = lib.doJailbreak super.bmp;
      carray = lib.doJailbreak super.carray;
      flow = lib.doJailbreak super.flow;
      OpenGLRaw = lib.doJailbreak super.OpenGLRaw;
      other901 = self.callCabal2nix "other901" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other901
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with myHaskellPackages; with nixpkgs; with haskellPackages; [
      apply-refact
      cabal-install
      ghcid
      haskell-language-server
      hasktags
      hlint
      implicit-hie
      krank
      stan
      stylish-haskell
      haskellPackages.weeder # not on ghc 9.2 because of generic-lens-core issues
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other901);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other901 = myHaskellPackages.other901;
}
