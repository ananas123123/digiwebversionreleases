# Versioned release storage

Each release has its own folder and version-specific JSON metadata file.

- `1.0.0.0/release.json` — retained historical metadata template.
- `1.1.0.0/1.1.0.0.json` — current stable release metadata.
- `1.2.0.0/1.2.0.0.json` — retained historical release metadata; its GitHub tag and release are unchanged.

The root `latest.json` points to the current version, 1.1.0.0. `releases/directory.json` maps known versions to their folders and metadata files. Digi reads the directory index and then fetches the exact metadata file for the selected latest version.

Each version manifest must have a `package` object and a `files` inventory that agree on filename, relative path, kind, exact byte size, and SHA-256. The package URL must be HTTPS and point to the actual release asset.

When publishing, create and verify the asset and version metadata first, update `directory.json` next, and update root `latest.json` last. Preserve prior release assets for recovery.
