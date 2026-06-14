{
  description = "mawk (Debian's default awk) as a single self-contained binary";

  nixConfig = {
    extra-substituters = [ "https://unpins.cachix.org" ];
    extra-trusted-public-keys = [ "unpins.cachix.org-1:DDaShjbZ8VvcqxeTcAU3kV9vxZQBlyb7V/uLBHfTynI=" ];
  };

  inputs.unpins-lib.url = "github:unpins/nix-lib";

  # mawk is Debian/Ubuntu's `/usr/bin/awk`. Single binary; `awk` is registered
  # as an UNPIN_META alias (mawk doesn't switch on argv[0] — the alias just
  # invokes the same binary, which IS awk). Native from pkgsStatic.mawk;
  # Windows through mingw (mawk is portable K&R C).
  #
  # macOS: ships now. Earlier the darwin binary SIGILLed at startup, even on
  # `{print 6*7}` — root-caused (crash report: __strcpy_chk → __chk_fail_overflow
  # in new_STRING ← field_init) to a fortify false positive. mawk's STRING ends
  # in a fixed-size trailing array `char str[2]` used as a flexible array member
  # (types.h); every string is `zmalloc(len + STRING_OH)` and copied in with
  # `strcpy(sval->str, s)`. clang on darwin, unlike gcc on linux, treats `[2]`
  # as a real fixed array under its default -fstrict-flex-arrays level, so
  # _FORTIFY_SOURCE computes __builtin_object_size(sval->str, 1) == 2 and
  # __strcpy_chk aborts the first default string copied in field_init
  # (CONVFMT "%.6g" → 5 bytes > 2), even though the allocation reserved room.
  # -fstrict-flex-arrays=0 restores the trailing-array-is-flexible semantics
  # mawk's code assumes (object size becomes unknown → the check passes), while
  # keeping every other fortify check intact — unlike a blanket
  # -D_FORTIFY_SOURCE=0. gcc/linux already treats it as flexible, so the flag is
  # darwin-only and the linux/mingw builds are untouched.
  outputs = { self, unpins-lib }:
    let lib = unpins-lib.lib;
    in
    lib.mkStandaloneFlake {
      inherit self;
      name = "mawk";
      smoke = [ "-W" "version" ];
      smokePattern = "mawk 1\\.3";
      build = pkgs:
        let
          base = pkgs.pkgsStatic.mawk;
          # See the header note: clang/darwin fortify SIGILLs on mawk's
          # fake-flexible-array STRING without this; gcc/linux doesn't need it.
          fixed =
            if pkgs.stdenv.hostPlatform.isDarwin
            then base.overrideAttrs (o: {
              NIX_CFLAGS_COMPILE = (o.NIX_CFLAGS_COMPILE or "") + " -fstrict-flex-arrays=0";
            })
            else base;
        in
        lib.withAliases pkgs { primary = "mawk"; aliases = [ "awk" ]; } fixed;
      windowsBuild = pkgs:
        lib.withAliases pkgs { primary = "mawk.exe"; aliases = [ "awk" ]; }
          (lib.mingwStaticCross pkgs).mawk;
    };
}
