FROM docker.io/library/rust:1.99.1-slim-trixie@sha256:d5928c68f8909c141df1bef47ac2c99c025fc9480d09870e08c3783b270eedec AS build

RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake git libclang-dev perl && rm -rf /var/lib/apt/lists/*

ARG REDLIB_COMMIT=a4d36e954cf1bd64f209cd8868c5a29edc81b374
WORKDIR /redlib
ADD https://github.com/redlib-org/redlib.git#${REDLIB_COMMIT} .
RUN cargo build --release --locked --bin redlib

FROM cgr.dev/chainguard/glibc-dynamic:latest@sha256:00696e56634cf72d966ee0e0f26224c83a192569035caf1e31297f77b0e85212
COPY --from=build /redlib/target/release/redlib /usr/local/bin/redlib
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/redlib"]
