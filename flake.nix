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
  outputs = { self, unpins-lib }:
    let lib = unpins-lib.lib;
    in
    lib.mkStandaloneFlake {
      inherit self;
      name = "mawk";
      smoke = [ "-W" "version" ];
      smokePattern = "mawk 1\\.3";
      build = pkgs:
        lib.withAliases pkgs { primary = "mawk"; aliases = [ "awk" ]; }
          pkgs.pkgsStatic.mawk;
      windowsBuild = pkgs:
        lib.withAliases pkgs { primary = "mawk.exe"; aliases = [ "awk" ]; }
          (lib.mingwStaticCross pkgs).mawk;
    };
}
