# mawk

[mawk](https://invisible-island.net/mawk/) — Mike Brennan's fast implementation of the AWK programming language (Debian/Ubuntu's default `/usr/bin/awk`). A single self-contained binary, built natively for Linux, macOS, and Windows.

[![CI](https://github.com/unpins/mawk/actions/workflows/mawk.yml/badge.svg)](https://github.com/unpins/mawk/actions)
![Linux](https://img.shields.io/badge/Linux-✓-success?logo=linux&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-✓-success?logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-✓-success?logo=windows&logoColor=white)

Part of the [unpins](https://unpins.org) catalog; install it with [`unpin`](https://github.com/unpins/unpin): `unpin install mawk`.

One binary; `awk` is registered as an alias for it (mawk does not switch on the command name — the alias simply invokes the same binary, which *is* an awk).

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

- **Platforms:** Linux, macOS, Windows.
- **Windows:** mingw cross (mawk is portable K&R C) — a self-contained PE32+ `.exe`.
- **Man pages:** embedded in the binary, read with `unpin man mawk`.
