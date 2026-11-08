FROM docker.io/library/rust:1.99.1-slim-trixie@sha256:f6c4a35d21dbb3c89d7a8d056c193e94fc09037f2b58dd858b09c39a47dd02d7 AS build

RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake git libclang-dev perl && rm -rf /var/lib/apt/lists/*

ARG REDLIB_COMMIT=ba116c1186f6b0f9d45f0ae50c827e13eb2f5ea2
WORKDIR /redlib
ADD https://github.com/redlib-org/redlib.git#${REDLIB_COMMIT} .
RUN cargo build --release --locked --bin redlib

FROM cgr.dev/chainguard/glibc-dynamic:latest@sha256:aab5cd0b4cc5edd9c87b6e7aa9ddaa3fb6ffcec559b9e5473c55bbc937b65399
COPY --from=build /redlib/target/release/redlib /usr/local/bin/redlib
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/redlib"]
