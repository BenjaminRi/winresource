FROM rust:1.87.0

RUN apt update && apt install -y mingw-w64 libimage-exiftool-perl icoutils \
    && rustup target add x86_64-pc-windows-gnu
