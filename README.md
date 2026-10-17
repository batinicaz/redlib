# redlib

Builds [redlib-org/redlib](https://github.com/redlib-org/redlib) at the commit pinned in the [Dockerfile](./Dockerfile), because upstream publishes no image containing current `main`.

Renovate proposes new upstream commits. Images are pushed to `ghcr.io/batinicaz/redlib` on merge to `main` and scanned with [Grype](https://github.com/anchore/grype).
