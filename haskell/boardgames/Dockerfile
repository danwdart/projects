FROM nixos/nix
WORKDIR /app
COPY . .
RUN nix-env -iA cachix -f https://cachix.org/api/v1/install
RUN cachix use websites
RUN nix-env -i git
RUN nix-build
CMD ["nix-shell"]