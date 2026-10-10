# Digi NSIS installer

## Visual design

The installer uses Digi's charcoal-and-muted-gold visual identity: near-black charcoal, soft white text, and restrained gold branding. It uses the standard NSIS Modern UI 2 wizard so installation remains familiar and predictable on Windows. The welcome and finish pages are branded; standard Windows controls may still use the operating system's native appearance.

## Build process

1. Build `Digi Search Engine.exe` and `DigiUpdater.exe` from the intended `Digi.app` commit.
2. Copy both executables and their matching `version.txt` into `installer/payload/`.
3. Open `DigiInstaller.nsi` in MakeNSISW and compile.
4. Test the resulting `DigiInstaller.exe` on a clean Windows profile and over an existing installation before publishing.

NSIS packages the already-built application. It does not compile the Digi application itself. Built executables are intentionally not stored in this repository.

## Staging layout

```text
installer/
├── DigiInstaller.nsi
├── README.md
└── payload/
    ├── Digi Search Engine.exe
    ├── DigiUpdater.exe
    └── version.txt
```

## Install behaviour

The installer installs to `%LOCALAPPDATA%\Digi` without requesting administrator privileges. It creates `Search Repository\Digi Notes`, `Cache`, and `Logs` if missing, and does not erase their contents. Digi's first-run bootstrap remains responsible for `Version manager` metadata.

It creates Desktop and Start Menu shortcuts and registers the install path/version for the current Windows user. The finish page offers to launch Digi.

## Uninstall behaviour

The uninstaller removes the two application executables, root `version.txt`, its own uninstaller, shortcuts, and the Digi registry key. It preserves `Search Repository`, `Cache`, `Logs`, `Version manager`, and any other remaining user files.

## Before release

- [ ] Set `APP_VERSION` to the exact release version.
- [ ] Stage both EXEs and the matching `version.txt`.
- [ ] Compile in MakeNSISW.
- [ ] Verify clean installation, existing-install update, shortcuts, first-run bootstrap, and uninstall.
- [ ] Confirm that user data is preserved.
- [ ] Test the updater and rollback separately.
- [ ] Publish the resulting installer through the intended release/site workflow.

The script is a design implementation, not a verified Windows build. It must be compiled and tested with NSIS on Windows before being distributed.
