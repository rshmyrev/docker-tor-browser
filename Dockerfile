FROM debian:bookworm-slim AS builder
ARG VERSION=12.5.6
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      gnupg \
      wget \
      xz-utils \
 && update-ca-certificates \
 && gpg \
    --auto-key-locate nodefault,wkd \
    --locate-keys torbrowser@torproject.org \
 && gpg \
    --output ./tor.keyring \
    --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290 \
 && wget https://www.torproject.org/dist/torbrowser/"${VERSION}"/tor-browser-linux64-"${VERSION}"_ALL.tar.xz \
 && wget https://www.torproject.org/dist/torbrowser/"${VERSION}"/tor-browser-linux64-"${VERSION}"_ALL.tar.xz.asc \
 && gpgv \
    --keyring ./tor.keyring \
    tor-browser-linux64-"${VERSION}"_ALL.tar.xz.asc \
    tor-browser-linux64-"${VERSION}"_ALL.tar.xz \
 && tar xvfJ tor-browser-linux64-"${VERSION}"_ALL.tar.xz

FROM debian:bookworm-slim
LABEL maintainer="rshmyrev <rshmyrev@gmail.com>"

# Copy Tor Browser
COPY --from=builder /tor-browser/Browser /Browser

# Install required deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      file \
      libasound2 \
      libdbus-glib-1-2 \
      libpulse0 \
      tor \
      zenity \
 && rm -rf /var/lib/apt/lists/*

# Create a user and directories
RUN adduser user \
 && chown -R user:user /Browser

VOLUME ["/Browser/Downloads"]
WORKDIR /home/user
USER user
ENTRYPOINT ["/Browser/start-tor-browser"]
