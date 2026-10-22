#!/usr/bin/env bash
# Open VS Code and DOSBox-X for this repository, from any working directory.
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$repo_dir"

# Open the same repository in VS Code. This normally returns immediately.
# Missing VS Code should not prevent DOSBox-X from starting.
if command -v code >/dev/null 2>&1; then
    if ! code .; then
        printf 'Warning: VS Code could not be opened. Continuing with DOSBox-X.\n' >&2
    fi
else
    printf "Warning: 'code' is not on PATH; skipping VS Code.\n" >&2
fi

# Override with DOSBOX_X=/absolute/path/to/dosbox-x if necessary.
emulator="${DOSBOX_X:-dosbox-x}"
if ! command -v "$emulator" >/dev/null 2>&1; then
    printf 'DOSBox-X not found: %s\n' "$emulator" >&2
    printf 'Install DOSBox-X or set DOSBOX_X to the executable path.\n' >&2
    exit 1
fi

exec "$emulator" -conf "$repo_dir/dosbox-x.conf"
