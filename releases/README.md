# Versioned release storage

Only these two version directories are currently prepared:

- `1.0.0.0/release.json` — metadata for the full package `full-package.zip`.
- `1.1.0.0/release.json` — metadata for `full-package.zip` and `update-package.zip`, with the incremental package intended to apply from `1.0.0.0`.

These files are unpublished metadata templates. The actual ZIP packages have not been built or uploaded, and these versions must not be advertised as available until real packages have been verified.

Upload genuine packages to GitHub Release assets or another stable HTTPS artifact location, then populate each `release.json` with the exact download URL, SHA-256 checksum, and byte size. Update `latest.json` only after a release package is available and verified. Preserve previous published packages for recovery.
