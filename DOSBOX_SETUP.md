# DOSBox-X setup (Linux and Windows)

This repository uses one shared DOSBox-X configuration for studying 8086
assembly with MASM and DOS DEBUG. The DOSBox-X program itself and the DOS
assembler/linker are **not** included. The two launchers also open the repository
in Visual Studio Code before starting DOSBox-X.

## Suggested repository layout

```text
asm8086/
├── dosbox-x.conf
├── run-dosbox-x.sh
├── run-dosbox-x.bat
├── DOSBOX_SETUP.md
├── .gitattributes          # consistent line endings on both systems
├── BUILD.BAT              # if you already have a DOS-side build script
├── MASM/                  # local DOS toolchain; normally not committed
│   ├── MASM.EXE
│   └── LINK.EXE
└── ...                    # your .ASM source files
```

The `MASM` directory should contain **DOS** binaries, not a Windows-native
assembler or a Linux executable. Obtain the assembler and linker from a source
you are authorized to use. Keep the same folder layout on both computers.

## Linux

1. Install DOSBox-X (preferably version 2026.10.01 or newer) from an official
   distribution channel, and verify the `dosbox-x` command is available.
   Install Visual Studio Code and verify `code .` works in a terminal; otherwise
   the launcher will warn and continue with DOSBox-X alone.
2. Place the files above in the Git repository root.
3. Run:

   ```sh
   chmod +x run-dosbox-x.sh
   ./run-dosbox-x.sh
   ```

   If the executable is not on `PATH`, use its absolute location:

   ```sh
   DOSBOX_X=/path/to/dosbox-x ./run-dosbox-x.sh
   ```

## Windows

1. Install Visual Studio Code and DOSBox-X from https://dosbox-x.com/ . The official
   Windows installer is the easiest choice. A portable ZIP also works.
   The launcher finds VS Code through `code.cmd` on PATH or in its usual install folders.
2. Clone the repository anywhere, e.g. `D:\Projects\asm8086`, and put your
   DOS `MASM.EXE` and `LINK.EXE` in `D:\Projects\asm8086\MASM`.
3. Double-click `run-dosbox-x.bat`, or execute it in PowerShell or cmd.exe.
4. If the script cannot find the emulator, set its location **for the current
   PowerShell session** and try again:

   ```powershell
   $env:DOSBOX_X = 'C:\Tools\DOSBox-X\Release SDL2\dosbox-x.exe'
   .\run-dosbox-x.bat
   ```

   Change the path to the actual `dosbox-x.exe` on your computer. In a portable
   ZIP, look in the extracted `Release` or `Release SDL2` folder.

## Opening both programs

Launching `run-dosbox-x.sh` or `run-dosbox-x.bat` opens the repository in VS Code
(equivalent to `code .` from the repository root), then starts DOSBox-X using
`dosbox-x.conf`. You edit `.ASM` files in VS Code and use DOSBox-X to run
`BUILD name` and `DEBUG name.EXE`. If VS Code is not available, the launcher
warns but still attempts to open DOSBox-X. `code .` may reuse an existing VS Code
window rather than creating a new one.

## How to verify it works (both platforms)

After the launcher opens DOSBox-X, you should see `C:\>`:

```dos
C:
DIR
PATH
MASM
```

- `C:` is **not** the host Windows `C:` drive. It is your Git repository folder
  mounted as the DOSBox-X guest `C:` drive.
- `DIR` should show the project's files, including the `MASM` directory.
- `PATH` should include `C:\MASM` and the built-in DOSBox-X utility paths.
- `MASM` should start the DOS assembler if `MASM.EXE` was installed correctly.
  Exit its prompt, or use your existing `BUILD filename` script instead.
- `DEBUG yourprog.exe` and `BUILD yourprog` should work as before if the
  appropriate files and DOS utilities are present.

**If MASM is not recognized:** check that `MASM.EXE` actually exists under
`MASM/`, not just that DOSBox-X itself was installed. DOSBox-X does not bundle
Microsoft MASM 5.00 and LINK 3.60.

## What is portable and what is not

- Portable: `.asm` files, `.bat` build scripts, `dosbox-x.conf`, both launchers.
- Installed independently: DOSBox-X itself and a legally acquired DOS MASM/LINK
  toolchain on each system.
- Host paths can differ; the launcher and config do not need editing.
- Classic DOS tools such as MASM 5.00 work most reliably with traditional
  short (8.3) DOS filenames for source files and directories.
- `cputype = 8086` is intentional for the course. Switch back to `auto` if you
  need software that requires instructions introduced after the 8086.

## Git ignore note

Keep your existing `.gitignore` rules for `*.exe`, `*.obj`, `*.map`, etc.
Consider adding the entire DOS toolchain directory to it:

```gitignore
/MASM/
```

This avoids accidentally tracking third-party DOS binaries. If the files were
previously committed, ignoring them alone does not remove them from Git's
index; untrack them explicitly if needed.

## Why `MOUNT C .` works

`working directory option = config` tells DOSBox-X to use the directory of
its primary configuration file. Both launch scripts specify that exact config
with `-conf` and start the host process in the repository root. Consequently,
`MOUNT C "."` mounts the same repository path on Linux and Windows.

Reference: https://dosbox-x.com/wiki/Home and
https://github.com/joncampbell123/dosbox-x/wiki/DOSBox%E2%80%90X%E2%80%99s-Command%E2%80%90Line-Options

## Line endings

The included `.gitattributes` keeps Bash launchers LF-terminated and Windows
batch files CRLF-terminated when checked out from Git. If your repository
already has a `.gitattributes`, merge these rules into it instead of replacing
your existing rules.
