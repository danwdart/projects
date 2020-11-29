FROM terrorjack/asterius
WORKDIR /app
COPY . .
RUN ahc-cabal build
CMD ["ahc-cabal", "run"]