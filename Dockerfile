# Dockerfile para mineração Bitcoin com cpuminer, com melhorias de I/O e desabilitação da durabilidade
# Uso:
#    docker run --rm \
#  --sysctl net.core.rmem_max=... \
#  --sysctl net.core.wmem_max=... \
#  --sysctl net.ipv4.tcp_rmem="..." \
#  --sysctl net.ipv4.tcp_wmem="..." \
#  --network host \
#  minerd --url <stratum_url> --user <username> --pass <password>

FROM alpine:edge

# Set a default value for CFLAGS, which can be overridden during build
ARG CFLAGS="-O3"

# Adicionar o repositório edge do Alpine
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update

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
    libeatmydata \
    libtool && \
    rm -rf /var/cache/apk/*

RUN git clone --depth=1 https://github.com/pooler/cpuminer.git /cpuminer
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
ENTRYPOINT ["ionice", "-c", "2", "-n", "0", "nice", "-n", "-20","eatmydata","./minerd"]