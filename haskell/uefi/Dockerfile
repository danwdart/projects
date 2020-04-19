FROM alpine
RUN apk add gcc g++ make ncurses gnu-efi-dev libffi-dev gmp-dev
RUN wget https://downloads.haskell.org/~ghc/8.10.1/ghc-8.10.1-x86_64-alpine3.10-linux-integer-simple.tar.xz
RUN wget https://downloads.haskell.org/~ghc/8.10.1/ghc-8.10.1-src.tar.xz
RUN wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0.tar.gz
RUN tar xvf ghc-8.10.1-x86_64-alpine3.10-linux-integer-simple.tar.xz
RUN tar xvf ghc-8.10.1-src.tar.xz
RUN tar xvf cabal-install-3.2.0.0.tar.gz
ENV EXTRA_BUILD_OPTIONS "--enable-executable-dynamic --enable-shared --ghc-options='-fPIC --dynamic-too'"