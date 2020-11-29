FROM typelead/eta
WORKDIR /app
COPY . .
RUN etlas build
CMD ["etlas", "run"]