# Digi NSIS installer

## Visual design

The installer uses Digi's charcoal-and-muted-gold visual identity: near-black charcoal, soft white text, and restrained gold branding. It uses the standard NSIS Modern UI 2 wizard so installation remains familiar and predictable on Windows. The welcome and finish pages are branded; standard Windows controls may still use the operating system's native appearance.

## Build process

1. Build Digi from the intended `Digi.app` commit using `build.bat`.
2. From the build output, copy only these two application executables into `installer/payload/`:
   - `Digi Search Engine.exe`
   - `DigiUpdater.exe`
3. Open `DigiInstaller.nsi` in MakeNSISW and compile it. The script writes `DigiInstaller.exe` beside the `.nsi` file.
4. Test the resulting installer on a clean Windows profile and over an existing installation before publishing.

The supplied ZIP of the post-build install layout contained the two EXEs and these folders: `Cache`, `Logs`, `Search Repository`, and `Search Repository/Digi Notes`. It did **not** contain a root `version.txt`; the installer therefore does not package or delete one. Digi's first-run bootstrap creates its version metadata under `Version manager`. The `Logs/updater.log` file in the sample ZIP is a runtime log and should not be packaged.

NSIS packages the already-built application. It does not compile the Digi application itself. Built executables are intentionally not stored in this repository.

## Staging layout

Place the `.nsi` and payload folder together:

```text
installer/
├── DigiInstaller.nsi
├── README.md
└── payload/
    ├── Digi Search Engine.exe
    └── DigiUpdater.exe
```

The `.nsi` uses paths relative to its own location, so MakeNSISW can compile it regardless of the current working directory.

## Existing-install behaviour

At startup, setup checks for `Digi Search Engine.exe` in `%LOCALAPPDATA%\Digi` and checks the registered Digi install location. If an existing installation is detected, it asks before continuing:

- **Yes:** replace the application executables with the packaged versions.
- **No:** cancel setup without changing the installation.

This is an application-file replacement, not a clean wipe. Setup does not recursively delete the installation folder. It creates `Search Repository\Digi Notes`, `Cache`, and `Logs` only if missing, preserving existing content. It leaves `Version manager` metadata to Digi's first-run bootstrap.

The installer targets `%LOCALAPPDATA%\Digi` for the current Windows user and does not request administrator privileges. It creates Desktop and Start Menu shortcuts, registers the install path/version for the current user, and offers to launch Digi from the finish page.

## Uninstall behaviour

The uninstaller removes the two application executables, its own uninstaller, shortcuts, and the Digi registry key. It preserves `Search Repository`, `Cache`, `Logs`, `Version manager`, and any other remaining user files. The installation directory is removed only if empty.

## Before release

- [ ] Set `APP_VERSION` to the exact release version.
- [ ] Stage the two EXEs built from the intended app commit.
- [ ] Compile in MakeNSISW on Windows.
- [ ] Verify clean installation, existing-install confirmation, replacement, shortcuts, first-run bootstrap, and uninstall.
- [ ] Confirm that user data is preserved.
- [ ] Test the updater and rollback separately.
- [ ] Publish the resulting installer through the intended release/site workflow.

The script has not yet been compiled or tested on Windows. Verify it with NSIS and test the resulting installer before distribution.
