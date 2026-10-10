Digi release metadata protocol (schema version 1)

1. Digi reads /latest.json at the repository root and takes latest_version as the authoritative version pointer.
2. Digi reads /releases/directory.json. The releases object maps each version to a directory (relative to this releases folder) and a metadata_file path.
3. Digi reads the selected version-specific metadata file, e.g. /releases/1.2.0.0/1.2.0.0.json.
4. The version metadata must match latest.json and directory.json and must specify package.file_name, package.path, package.size_bytes, package.sha256, and package.kind.
5. Digi constructs the package URL from the releases base URL, selected directory, and package path. It downloads only after validating metadata, then verifies exact size and SHA-256 before saving to its local package-installer folder.
6. A .txt file is accepted only when package.kind is test-fixture. Published application packages should use .exe and kind installer.

Directory paths are relative to this releases folder, not repository root. Keep metadata_file inside the selected version directory. Do not place executable binaries in latest.json.
