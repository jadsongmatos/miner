# Dockerfile for Bitcoin mining with cpuminer
# Usage: docker run --rm --network host minerd --url <stratum_url> --user <username> --pass <password>
# Example: docker run -d --network host minerd --url stratum+tcp://btc.pool.com:3333 --user user.worker --pass password

FROM alpine:latest

# Set a default value for CFLAGS, which can be overridden during build
ARG CFLAGS="-O3"

# Install necessary dependencies
RUN apk add --no-cache \
    automake \
    libcurl \
    curl-dev \
    git \
    make \
    gcc \
    musl-dev \
    jansson \
    autoconf \
    libtool && \
    rm -rf /var/cache/apk/*

# Clone cpuminer repository
RUN git clone --depth=1 https://github.com/pooler/cpuminer.git /cpuminer

# Build cpuminer
WORKDIR /cpuminer
RUN ./autogen.sh && \
    ./configure CFLAGS="$CFLAGS" && \
    make && \
    make install

# Clean up unnecessary files to reduce image size
RUN apk del git autoconf libtool && \
    rm -rf /cpuminer/.git

# Set working directory
WORKDIR /cpuminer

# Set user to root to allow process priority adjustment
USER root

# Default command for the container
ENTRYPOINT ["nice", "-n", "-20", "./minerd"]