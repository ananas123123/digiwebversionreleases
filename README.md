# Digi Web Version Releases

This repository hosts the stable-release metadata used by Digi's built-in updater.

## Current stable release

- **Latest version:** 1.2.0.0
- **Previous version:** 1.1.0.0
- **Status:** published
- **Release asset:** [Digi.Search.Engine.exe](https://github.com/ananas123123/digiwebversionreleases/releases/download/v1.2.0.0/Digi.Search.Engine.exe)
- **Release page:** https://github.com/ananas123123/digiwebversionreleases/releases/tag/v1.2.0.0

## Metadata flow

1. Digi fetches [latest.json](./latest.json) from the repository root. Its `latest_version` field is the authoritative latest-version pointer.
2. Digi fetches [releases/directory.json](./releases/directory.json). The `releases` map resolves a version to its folder and metadata file.
3. Digi fetches the selected version metadata, currently [releases/1.2.0.0/1.2.0.0.json](./releases/1.2.0.0/1.2.0.0.json).
4. The manifest's package information must match its `files` inventory.
5. Digi downloads the HTTPS release asset, verifies exact byte size and SHA-256, then stages it for the updater helper.
6. The helper replaces only the installed Digi executable, waits for startup confirmation, and rolls back if confirmation fails. User data remains outside the replaceable executable.

## Publishing a release

1. Build and test the exact version being released.
2. Upload the actual executable to a GitHub Release asset.
3. Verify the asset's URL, exact byte size, and SHA-256.
4. Create version metadata in `releases/VERSION/VERSION.json`.
5. Add the version to `releases/directory.json`.
6. Validate all metadata JSON and cross-file consistency.
7. Update `latest.json` last, after the asset and version metadata are ready.
8. Keep previous release assets and metadata available for recovery.

## Security and integrity

- Metadata and downloads must use HTTPS.
- A SHA-256 checksum detects corruption but does not prove publisher identity; signed releases are recommended for stronger authenticity.
- Never publish invented sizes or checksums.
- Never mark a release published before its actual artifact is uploaded and verified.
