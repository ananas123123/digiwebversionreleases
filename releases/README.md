# Versioned release storage

Each release has its own folder and version-specific JSON metadata file.

- `1.0.0.0/1.0.0.0.json` — retained historical release metadata.
- `1.1.0.0/1.1.0.0.json` — retained previous release metadata.
- `1.2.0.0/1.2.0.0.json` — current stable release metadata.

The root `latest.json` points to the current version. `releases/directory.json` maps each version to its folder and metadata file. Digi reads the directory index and then fetches the exact metadata file for the selected latest version.

Each version manifest must have a `package` object and a `files` inventory that agree on filename, relative path, kind, exact byte size, and SHA-256. The package URL must be HTTPS and point to the actual release asset.

When publishing, create and verify the asset and version metadata first, update `directory.json` next, and update root `latest.json` last. Preserve prior release assets for recovery.
