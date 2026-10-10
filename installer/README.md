# Digi NSIS installer design

## Goal

Build a small per-user Windows installer that places Digi in:

`%LOCALAPPDATA%\Digi`

It does not require administrator privileges and does not install into Program Files.

## Simple build flow

1. Build the two executables from `Digi.app` using the project's build process:
   - `Digi Search Engine.exe`
   - `DigiUpdater.exe`
2. Copy those finished executables and the matching `version.txt` into this folder:
   `installer/payload/`
3. Open `DigiInstaller.nsi` in MakeNSISW and compile it.
4. NSIS outputs `DigiInstaller.exe` beside the `.nsi` file. Test it on a clean Windows user profile before publishing.

**NSIS packages files; it does not compile the Digi application.** The EXEs must already have been built. Do not commit the built EXEs to this release-metadata repository unless deliberately deciding to store binaries here.

## Expected staging layout

```text
installer/
├── DigiInstaller.nsi
├── README.md
└── payload/                         # local staging folder; provide before compiling
    ├── Digi Search Engine.exe
    ├── DigiUpdater.exe
    └── version.txt
```

The `payload/` folder is deliberately not populated with fake or placeholder executables in Git. NSIS compilation will fail clearly if a required payload file is missing.

## What the installer does

- Installs/updates the two EXEs to `%LOCALAPPDATA%\Digi`.
- Creates `Search Repository\Digi Notes`, `Cache`, and `Logs` if they do not exist.
- Leaves existing files in those data folders untouched.
- Leaves `Version manager` initialization to Digi's first-run bootstrap.
- Creates a Desktop shortcut and Start Menu shortcuts for the current Windows user.
- Records the install path and installed version in `HKCU\Software\Digi`.
- Includes an uninstaller.

## Uninstall safety

The uninstaller removes the two application EXEs, root `version.txt`, the uninstaller, shortcuts, and the Digi registry key. It intentionally does **not** delete Search Repository, Cache, Logs, Version manager, or other user files. The install directory will remain if it contains user data.

## Release checklist

- [ ] Set `APP_VERSION` to the exact release version.
- [ ] Build both EXEs from the intended `Digi.app` commit.
- [ ] Put both EXEs and the matching `version.txt` in `payload/`.
- [ ] Compile using MakeNSISW.
- [ ] Install on a clean Windows account and verify both EXEs, folders, shortcuts, and first-run bootstrap.
- [ ] Install over an existing Digi folder and confirm Search Repository and Cache are unchanged.
- [ ] Uninstall and confirm user data is preserved.
- [ ] Test update/rollback separately; a successful installer compile is not proof that the updater works.
- [ ] Publish the resulting installer from the release workflow/site, not from the NSIS source folder.
