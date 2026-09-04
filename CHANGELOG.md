# Changelog

## [Unreleased]

### Changed

- The Windows binary is now built by the same compiler as the Linux and macOS
  ones (264 KB to 212 KB). Checked on Windows 10 against the previous binary:
  `-W version`, and awk programs — formatting, string functions and a piped
  input file — give identical output.

  It now uses the Universal C Runtime, which is part of Windows 10 and later.
  On Windows 7 or 8.1 that runtime has to be installed first — it comes through
  Windows Update. The previous binary did not need it.
