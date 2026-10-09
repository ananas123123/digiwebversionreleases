# Digi Web Version Releases

This repository publishes stable Digi application releases and provides the public metadata used by the application's updater.

## Update endpoint

The updater should read [`latest.json`](./latest.json) from the `main` branch using HTTPS:

`https://raw.githubusercontent.com/ananas123123/digiwebversionreleases/main/latest.json`

The manifest uses `schema_version` to identify its format. A `release_status` of `unpublished` means there is no downloadable stable release; the updater must not download or install anything in that state.

## Publishing a release

1. Build and test the application from the intended stable source revision.
2. Package the actual distributable installer or update package.
3. Upload the package to a versioned GitHub Release or versioned release path. Do not commit large binaries to this repository's Git history.
4. Calculate the package's SHA-256 checksum and record its exact byte size.
5. Validate the download URL, checksum, size, version, and release notes.
6. Update `latest.json` only after the package is uploaded and verified. Keep the previous published release available for recovery.

`release-template.json` documents the package metadata expected for a published release. Never publish placeholder URLs, checksums, or sizes as if they were real.

## Security requirements

- Use HTTPS for metadata and package downloads.
- The updater must validate the manifest schema and version before acting.
- Verify the downloaded package's SHA-256 checksum before installation.
- A checksum detects corruption but does not prove who published a file; production releases should also be protected by a trusted signing process.
- Failed updates must leave the installed application recoverable and must preserve user data.

## Current status

No application package has been published. `latest.json` intentionally reports `release_status: unpublished` until a real, tested build is available.
