# Versioned release storage

Store release-specific notes and metadata here only when a real release is prepared. Keep published binary packages in GitHub Releases or another stable HTTPS artifact location rather than committing large binaries to Git history.

Suggested layout for a published version:

- `releases/<version>/release.json` — immutable metadata for that version.
- `releases/<version>/checksums.txt` — SHA-256 checksums for its published packages.

Do not create a version directory that implies a release is available until the corresponding package has been built, tested, uploaded, and verified.
