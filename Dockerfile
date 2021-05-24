FROM rust:1.45-slim-buster as builder
ARG user=indy
ENV HOME="/home/$user"
WORKDIR $HOME
RUN mkdir -p .local/lib

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    automake \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    libbz2-dev \
    libffi-dev \
    libgmp-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libsecp256k1-dev \
    libsodium-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libzmq3-dev \
    pkg-config \
    python3 \
    python3-pip \
    python3-setuptools \
    zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="$HOME/.local/bin:$PATH"
ENV LIBRARY_PATH="$HOME/.local/lib:$LIBRARY_PATH"

#to ensure docker doen't cache the result of git clone
ADD https://api.github.com/repos/Nova-Scotia-Digital-Service/indy-sdk/git/refs/heads/master version.json
RUN git clone https://github.com/Nova-Scotia-Digital-Service/indy-sdk.git

WORKDIR $HOME/indy-sdk/libindy
RUN cargo build --release && cp target/*/libindy.so "$HOME/.local/lib"

WORKDIR $HOME/indy-sdk/experimental/plugins/postgres_storage/
RUN cargo build --release && cp target/*/libindystrgpostgres.so "$HOME/.local/lib"


FROM bcgovimages/aries-cloudagent:py36-1.15-1_0.6.0
COPY --from=builder --chown=indy:indy /home/indy/.local/lib/libindystrgpostgres.so /home/indy/.local/lib
