# Digi Web Version Releases

This repository publishes stable Digi application releases and provides public metadata for the application's updater.

## Update endpoint

The updater reads [`latest.json`](./latest.json) over HTTPS:

`https://raw.githubusercontent.com/ananas123123/digiwebversionreleases/main/latest.json`

A `release_status` of `unpublished` means no stable release is available. The updater must not download or install anything in that state.

## Planned versions

Only two version directories are prepared:

- [`releases/1.0.0.0/`](./releases/1.0.0.0/) — full package metadata.
- [`releases/1.1.0.0/`](./releases/1.1.0.0/) — full package metadata and an incremental update from `1.0.0.0`.

These are metadata templates, not published releases. Actual ZIP packages are not present yet. Do not treat either version as available until its real package has been built, tested, uploaded, and verified.

## Publishing

1. Build and test the intended stable application version.
2. Create the full package; for `1.1.0.0`, also create an incremental package that applies specifically to `1.0.0.0`.
3. Upload real packages to GitHub Release assets or another stable HTTPS artifact location. Avoid committing large binaries to Git history.
4. Calculate each package's SHA-256 checksum and exact byte size.
5. Fill in `release.json` with real URLs, checksums, sizes, and release notes.
6. Update `latest.json` only after the selected package is uploaded and verified. Keep previous published packages available for recovery.

## Security

- Use HTTPS for metadata and package downloads.
- Validate the manifest and version before acting.
- Verify package SHA-256 before installation. A checksum detects corruption but does not establish publisher identity; production releases should also use a trusted signing process.
- Failed updates must be recoverable and must preserve user data.

## Current status

No application package has been published. `latest.json` remains `unpublished` until a real, tested build is available.
