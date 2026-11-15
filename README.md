# mawk

[mawk](https://invisible-island.net/mawk/) — Mike Brennan's fast implementation of the AWK programming language (Debian/Ubuntu's default `/usr/bin/awk`). A single self-contained binary, built natively for Linux, macOS, and Windows.

[![CI](https://github.com/unpins/mawk/actions/workflows/mawk.yml/badge.svg)](https://github.com/unpins/mawk/actions)
![Linux](https://img.shields.io/badge/Linux-✓-success?logo=linux&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-✓-success?logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-✓-success?logo=windows&logoColor=white)

Part of the [unpins](https://unpins.org) catalog; install it with [`unpin`](https://github.com/unpins/unpin): `unpin install mawk`.

## Usage

Run the `mawk` program with [unpin](https://github.com/unpins/unpin):

```bash
unpin mawk '{ print $1 }' file
echo "1 2 3" | unpin mawk '{ print $2 }'
```

To install it onto your PATH:

```bash
unpin install mawk
```

Installing also creates the `awk` command alongside `mawk`.

## Man pages

`mawk.1` and the two technical notes on its internals, `mawk-arrays.7` and `mawk-code.7`, are embedded in the binary:

```bash
unpin man mawk
unpin man mawk mawk-arrays
unpin man mawk mawk-code
```

## Build locally

```bash
nix build github:unpins/mawk
./result/bin/mawk -W version
```

Or run directly:

```bash
nix run github:unpins/mawk -- -W version
```

The first invocation will offer to add the [unpins.cachix.org](https://unpins.cachix.org) substituter so most pulls come pre-built.

## Manual download

The [Releases](https://github.com/unpins/mawk/releases) page has standalone binaries for manual download.

## Build notes

- **Windows:** a single `mawk.exe` targeting the mingw-w64 runtime. Command pipes (`cmd | getline`, `print | "cmd"`) run the command through `cmd.exe`, as `system()` does.
- **Tests:** mawk's test suite runs on native builds (0 failures under static-musl) and is skipped on cross targets the build host can't execute.
