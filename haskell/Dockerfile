FROM haskell:latest

RUN apt update && \
    apt -y install libgd-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*