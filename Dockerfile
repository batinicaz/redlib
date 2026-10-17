FROM docker.io/library/rust:1.99.1-slim-trixie@sha256:4df2ae8cfdfebdfc13a65da7f253b73d68983dc0339f2719bc17a279c913b13d AS build

RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake git libclang-dev perl && rm -rf /var/lib/apt/lists/*

ARG REDLIB_COMMIT=a4d36e954cf1bd64f209cd8868c5a29edc81b374
WORKDIR /redlib
ADD https://github.com/redlib-org/redlib.git#${REDLIB_COMMIT} .
RUN cargo build --release --locked --bin redlib

FROM cgr.dev/chainguard/glibc-dynamic:latest@sha256:2a3f1ec8a825dfbb1211b5835a9b8b3fb8d76c7bd22a189b1f84157ed2028293
COPY --from=build /redlib/target/release/redlib /usr/local/bin/redlib
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/redlib"]
