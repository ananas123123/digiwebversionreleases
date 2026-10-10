Digi release metadata protocol (schema version 1)

1. Digi reads /latest.json at the repository root. latest_version is the authoritative current version; release_status must be published before an update is offered.
2. Digi reads /releases/directory.json. The releases object maps each version to a folder (relative to the releases directory) and metadata_file.
3. Digi reads the selected metadata file, for example /releases/1.2.0.0/1.2.0.0.json.
4. The selected metadata must match latest.json and directory.json and specify package.file_name, package.path, package.url, package.size_bytes, package.sha256, and package.kind. The matching files inventory entry must agree with package metadata.
5. Digi downloads the HTTPS URL, shows progress, verifies exact byte size and SHA-256, then stages the package in the local update manager.
6. The updater helper replaces only the designated installed application executable, waits for startup confirmation, and rolls back if startup fails. User data must remain preserved.
7. Release metadata must use actual verified artifact values. Never invent size or checksum values.

For each release, add and verify version metadata first, add its entry to releases/directory.json second, and update root latest.json last. Keep old published releases available for recovery.
