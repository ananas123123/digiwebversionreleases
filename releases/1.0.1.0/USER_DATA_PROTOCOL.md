# Digi 1.0.1.0 — User Data Protection Protocol

Status: planning only; no application package has been published.

## Findings from Digi.app/development
- `run.bat` runs `digi_search_engine.py` using the repository-local `.venv`; this is the development launcher, not a production installer.
- `backend/config.py` currently sets `USER_DATA_ROOT` to `%LOCALAPPDATA%\\Digi` (without a leading dot).
- In source mode, `Digi Dependencies` is inside the repository. In frozen mode, Cache, Search Repository, and Version manager are below `USER_DATA_ROOT`.
- `backend/database.py` stores the index, tags, statuses, due dates, recent searches, and settings in the SQLite database under Cache.
- `backend/notes.py` stores note pages as PNG files under `Digi Notes` inside the configured library root.
- The library root and Incoming folder can be user-selected and may be outside LOCALAPPDATA.

## Protected data paths
Treat all of these as user data and never replace, delete, move, rename, reset, repair, or clean them during an application update:
- `%LOCALAPPDATA%\\Digi\\` — the path currently defined by the code.
- `%LOCALAPPDATA%\\.digi\\` — also protect this requested path until the canonical path is settled.
- The **Search Repository and every file and subfolder inside it**. This is an explicit permanent preservation rule; it must never be overwritten or replaced by an update.
- The configured library root and its contents.
- The configured Incoming folder and its contents.
- User notes, documents, databases, settings, caches, indexes, and other user-selected data outside the application directory.

## Application update rules
1. The full package must contain application files only, not live user data.
2. The intended production application directory is `%ProgramFiles%\\Digi\\`, subject to confirmation against the actual packaging design.
3. Only explicitly allowlisted files within the designated application directory may be replaced.
4. Never extract a package over the user profile, LOCALAPPDATA, the Search Repository, the library root, or Incoming.
5. Validate release metadata, package size, and SHA-256 before applying an update.
6. Stage the package first. If any package entry targets a protected location or is ambiguous, abort without changing anything.
7. Close Digi before replacing application files and retain the previous application files for rollback until the updated app starts successfully.
8. Any future user-data migration requires a separate design with backup and rollback, and must not alter the Search Repository.

## Before publishing
- Build and test the full production package.
- Confirm it contains application files only.
- Record the verified package size and SHA-256 in `release.json`.
- Mark the release published in `release.json` and `latest.json` only after verification.

Important: this is a protocol document, not implemented updater code. The inspected development launcher runs Python source; it does not prove that a production `Digi.exe` package already exists.
