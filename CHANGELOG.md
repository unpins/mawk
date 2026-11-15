# Changelog

## [Unreleased]

### Fixed

- On Windows, command pipes work: `"cmd" | getline` and `print | "cmd"` stopped
  with `pipes not supported`. The command runs through `cmd.exe`, as
  `system()` does, and `close()` returns its exit status.
- With `-W interactive`, every input line longer than 4 KB grew mawk's memory
  by up to 256 KB that was never reused. Ten thousand such lines took
  gigabytes, and on 32-bit Linux (i686, armv7l) mawk stopped with
  `out of memory`.

### Changed

- mawk's test suite now runs on every native build, so a regression fails the
  build instead of shipping.

## [1.3.4-20240819-1] - 2026-09-26

Initial release — `mawk` 1.3.4-20240819 as a single self-contained binary, built
natively for Linux, macOS, and Windows.

### Added

- Builds for Linux (x86_64, aarch64, armv7l, i686, ppc64le, riscv64), macOS
  (Intel and Apple Silicon), and Windows (x86_64).
- `awk` is created alongside `mawk` when you install it.
- `mawk.1` and the `mawk-arrays.7` / `mawk-code.7` pages are embedded in the
  binary — read them with `unpin man mawk`.
- The Windows binary uses the Universal C Runtime, which is part of Windows 10
  and later. On Windows 7 or 8.1 that runtime has to be installed first — it
  comes through Windows Update.
