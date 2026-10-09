# Digi Web Version Releases

This repository publishes stable Digi application releases and provides the public metadata used by the application's updater.

## Update endpoint

The updater should read [`latest.json`](./latest.json) from the `main` branch using HTTPS:

`https://raw.githubusercontent.com/ananas123123/digiwebversionreleases/main/latest.json`

The manifest uses `schema_version` to identify its format. A `release_status` of `unpublished` means there is no downloadable stable release; the updater must not download or install anything in that state.

## Versioned layout

Metadata templates have been prepared for versions `1.0.0.0.0`, `1.0.0.0.1`, and `1.0.0.0.2` under [`releases/`](./releases/). Each version contains a `release.json`. Version `1.0.0.0.0` expects a full package; `1.0.0.0.1` and `1.0.0.0.2` expect both full and incremental packages.

These are planned version slots, not published application releases. The ZIP files are not present yet because no real packages have been uploaded. The updater must treat these entries as unavailable until genuine packages are built, tested, uploaded, and verified.

## Publishing a release

1. Build and test the application from the intended stable source revision.
2. Create the full package and, where supported, an incremental package from the exact prior version.
3. Upload the real package files to GitHub Release assets or another stable HTTPS artifact location. Do not commit large binaries to Git history.
4. Calculate each package's SHA-256 checksum and exact byte size.
5. Fill in and validate that version's `release.json` with real URLs, checksums, sizes, and release notes.
6. Update `latest.json` only after the package is uploaded and verified. Keep previous published packages available for recovery.

`release-template.json` documents the package metadata expected for a published release. Never publish placeholder URLs, checksums, or sizes as if they were real.

## Security requirements

- Use HTTPS for metadata and package downloads.
- The updater must validate the manifest schema and version before acting.
- Verify the downloaded package's SHA-256 checksum before installation.
- A checksum detects corruption but does not prove who published a file; production releases should also be protected by a trusted signing process.
- Failed updates must leave the installed application recoverable and must preserve user data.

## Current status

No application package has been published. `latest.json` intentionally reports `release_status: unpublished` until a real, tested build is available.
