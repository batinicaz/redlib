FROM docker.io/library/rust:1.99.1-slim-trixie@sha256:b8e062b1c3a80183df83d9ba187cadd2b5ab84bc78d453dbfeb2fccd5f982247 AS build

RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake git libclang-dev perl && rm -rf /var/lib/apt/lists/*

ARG REDLIB_COMMIT=ba116c1186f6b0f9d45f0ae50c827e13eb2f5ea2
WORKDIR /redlib
ADD https://github.com/redlib-org/redlib.git#${REDLIB_COMMIT} .
RUN cargo build --release --locked --bin redlib

FROM cgr.dev/chainguard/glibc-dynamic:latest@sha256:c3cb7cff7e902f51f37ba2e8abafbadb810a6b49df06e0935d4630ffcc6aac74
COPY --from=build /redlib/target/release/redlib /usr/local/bin/redlib
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/redlib"]
