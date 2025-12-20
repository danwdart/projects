with import <nixpkgs> {};
# needs mkShell in order to use headers/etc. from deps! how do we do that from nix-shell
mkShell rec {
    packages = [
        (builtins.getFlake "gitlab:haskell-wasm/ghc-wasm-meta?host=gitlab.haskell.org").packages.x86_64-linux.all_9_14
        # pkg-config
        # zlib.dev
    ];
}