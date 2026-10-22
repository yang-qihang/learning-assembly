# 8086 Assembly Exercises

Assembly programs and notes from working through Wang Shuang's *Assembly Language* and my university's 8086 Assembly Language course. This repository also contains a small [DOSBox-X](https://dosbox-x.com/) setup for assembling, running, and debugging DOS programs on **Linux and Windows** without maintaining two separate configurations. The launch scripts open this repository in **Visual Studio Code** and start DOSBox-X together.

The exercises primarily target the **Intel 8086**, using the DOS versions of **MASM** and **LINK**.

## Getting started

### 1. Install the required tools

- Install **DOSBox-X** on your host operating system (Linux or Windows).
- Install **Visual Studio Code**. On Linux, ensure its `code` command is available on `PATH`; on Windows, the launcher checks `PATH` and common VS Code installation locations for `code.cmd`. If VS Code is not found, the launcher prints a warning and still starts DOSBox-X.
- Obtain DOS-compatible copies of **`MASM.EXE`** and **`LINK.EXE`** that you are authorized to use. Place them in a folder named `MASM` at the root of the repository. The emulator does not include these tools.
- For step-by-step debugging, make sure a DOS **`DEBUG`** utility is available in your DOS environment.

Your working directory should look roughly like this:

```text
asm8086/
├── README.md
├── dosbox-x.conf          # Shared DOSBox-X configuration
├── run-dosbox-x.sh        # Linux launcher
├── run-dosbox-x.bat       # Windows launcher
├── DOSBOX_SETUP.md        # Additional setup and troubleshooting notes
├── BUILD.BAT              # Optional DOS-side MASM/LINK build helper
├── MASM/                  # Local DOS toolchain (not committed)
│   ├── MASM.EXE
│   └── LINK.EXE
└── ...                    # Assembly source files (*.ASM)
```

`MASM/` is intended to stay local to each machine; you do **not** need to commit the assembler or linker binaries.

### 2. Start DOSBox-X

**Linux**

From the repository root:

```bash
chmod +x run-dosbox-x.sh    # Needed only once
./run-dosbox-x.sh
```

If `dosbox-x` is not on your `PATH`, specify the executable explicitly:

```bash
DOSBOX_X=/absolute/path/to/dosbox-x ./run-dosbox-x.sh
```

**Windows**

Double-click `run-dosbox-x.bat`, or run it from a PowerShell terminal:

```powershell
.\run-dosbox-x.bat
```

The launcher first opens the repository in VS Code (equivalent to `code .`) and then starts DOSBox-X. It checks for `dosbox-x.exe` on your `PATH` and in common installation directories. If it cannot find the executable, set `DOSBOX_X` to its actual location for that PowerShell session:

```powershell
$env:DOSBOX_X = 'C:\Tools\DOSBox-X\Release SDL2\dosbox-x.exe'
.\run-dosbox-x.bat
```

The path above is **only an example**; replace it with the location on your PC.

Both launchers change to the repository root before opening VS Code, so `code .` opens the right folder even when the script is run from elsewhere. VS Code may reuse an existing window; the launcher does not force a separate new editor window each time. The editor stays open independently of DOSBox-X.

### 3. Check the DOS environment

When DOSBox-X starts, the repository should already be mounted as drive `C:` inside the emulator. Try:

```dos
C:
DIR
PATH
MASM
```

`DIR` should list your project files, `PATH` should contain `C:\MASM`, and `MASM` should start the DOS assembler if its executable is in `MASM/`.

> **Important:** DOSBox-X's `C:` drive is your **repository directory**, not the real Windows `C:` drive. For example, a clone at `D:\Projects\asm8086` on Windows and a clone at `/home/user/asm8086` on Linux both appear as `C:\` inside DOSBox-X.

## Assembling and debugging programs

If you have the repository's `BUILD.BAT` helper, assemble and link an exercise by passing its base filename **without** `.ASM`:

```dos
BUILD CH07_01
CH07_01
```

Alternatively, use MASM and LINK directly (example for a source file in the current DOS directory):

```dos
MASM CH07_01.ASM,CH07_01.OBJ;
LINK CH07_01.OBJ,CH07_01.EXE;
CH07_01
```

To inspect a program with DOS DEBUG, if that utility is available:

```dos
DEBUG CH07_01.EXE
```

Inside DEBUG, useful commands include `R` (registers), `U` (disassemble), `T` (single-step), `D` (dump memory), and `Q` (quit).

For best compatibility with classic DOS tools, prefer short, simple filenames (the traditional **8.3** naming convention).

## How the cross-platform setup works

Both launchers open VS Code for this repository, then start DOSBox-X with the **same** [`dosbox-x.conf`](dosbox-x.conf), from the repository root. Its startup commands:

```ini
[autoexec]
mount c "." -nocachedir
c:
path c:\masm;%PATH%
```

This mounts the repository as the DOS guest's `C:` drive and makes the local DOS toolchain available in `PATH`. The configuration uses `working directory option = config` to avoid hardcoded Linux or Windows paths. With `nocachedir`, files you edit in your host editor are easier to access immediately inside the emulator.

The configuration also selects `cputype = 8086`, deliberately targeting the processor used in the course. Programs requiring later x86 instructions may need a different CPU setting.

## Git hygiene

Keep source code, build helpers, and configuration files in Git; ignore generated DOS binaries and object files. Recommended rules for your root `.gitignore` include:

```gitignore
# MASM/LINK output
*.exe
*.com
*.obj
*.map
*.lst
*.crf

# Local third-party DOS tools
/MASM/

# Temporary files
*.bak
*.tmp
*.log
```

Because Git ignore patterns are case-sensitive, add uppercase variants if your tools produce uppercase extensions and you use Git on Linux (for example, `*.EXE` and `*.OBJ`).

For additional details, see [DOSBOX_SETUP.md](DOSBOX_SETUP.md).
