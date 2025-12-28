Aside from static-haskell-nix, what have we got?

In nix, ghc 9.4.
In docker/alpine, ghc 9.8.

Using shell-musl and shell-static which are cached at 9.4, use --enable-executable-static.

With pkgsStatic, you may have to additionally pass --with-compiler=x86_64-unknown-linux-musl-ghc --with-hc-pkg=x86_64-unknown-linux-musl-ghc-pkg or use a project file.

But technically it's doable if required, up to base 4.17.2 and ghc 9.4. Not sure about further options or libraries.

The other option for distribution on old glibc distros like old lambda land is to include all the dyn sos and have a wrapper script to call the newer ld.so which can also work if you're out of date.