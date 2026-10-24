FROM docker.io/library/rust:1.99.1-slim-trixie@sha256:aab42391a986424e22d6a3ec14f37bc6dd3dacff4d457ca7cccd781e02297cc6 AS build

RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake git libclang-dev perl && rm -rf /var/lib/apt/lists/*

ARG REDLIB_COMMIT=ba116c1186f6b0f9d45f0ae50c827e13eb2f5ea2
WORKDIR /redlib
ADD https://github.com/redlib-org/redlib.git#${REDLIB_COMMIT} .
RUN cargo build --release --locked --bin redlib

FROM cgr.dev/chainguard/glibc-dynamic:latest@sha256:2827063c9efb4ba971d8621eb75f4e61b8d19850a6293a797df37358cc6f687b
COPY --from=build /redlib/target/release/redlib /usr/local/bin/redlib
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/redlib"]
