FROM haskell:latest

RUN apt update && \
    apt -y install libgd-dev libpq-dev default-libmysqlclient-dev libsqlite3-dev libmongo-client-dev libssl-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*