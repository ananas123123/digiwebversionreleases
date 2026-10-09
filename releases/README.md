# Versioned release storage

The repository has metadata directories prepared for these planned versions:

- `1.0.0.0.0/` — full package metadata.
- `1.0.0.0.1/` — full and incremental package metadata; incremental update is intended to apply from `1.0.0.0.0`.
- `1.0.0.0.2/` — full and incremental package metadata; incremental update is intended to apply from `1.0.0.0.1`.

Each version's `release.json` describes the expected package filenames, download URLs, SHA-256 hashes, and byte sizes. These version entries are **unpublished templates**, not proof that those versions have been built or released.

The expected package files are `full-package.zip` for every version and `update-package.zip` for versions `1.0.0.0.1` and `1.0.0.0.2`. Actual ZIP archives are not present yet; do not create fake or empty ZIPs. Upload real, tested packages as release assets or to a stable HTTPS artifact location, then fill in the exact URLs, checksums, and sizes in `release.json`.

Only change `latest.json` to point at a version after its package has been uploaded and verified. Preserve previous published packages for recovery. Never commit secrets into release metadata.
