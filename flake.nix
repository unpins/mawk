{
  description = "mawk (Debian's default awk) as a single self-contained binary";

  nixConfig = {
    extra-substituters = [ "https://unpins.cachix.org" ];
    extra-trusted-public-keys = [ "unpins.cachix.org-1:DDaShjbZ8VvcqxeTcAU3kV9vxZQBlyb7V/uLBHfTynI=" ];
  };

  inputs.unpins-lib.url = "github:unpins/nix-lib";

  # mawk is Debian/Ubuntu's `/usr/bin/awk`. Single binary; `awk` is an alias
  # of it. Native from pkgsStatic.mawk; Windows through mingw, with
  # windows-popen-pipes.patch for command pipes (mawk only has them via fork).
  # Both compile with the engine's clang.
  outputs = { self, unpins-lib }:
    let lib = unpins-lib.lib;
    in
    lib.mkStandaloneFlake {
      inherit self;
      name = "mawk";

      # Build via the unpin-llvm engine + emit a bitcode multicall module.
      engine = "unpin-llvm";
      multicall = {
        # The `.exe` on the engine too, not the nixpkgs mingw-gcc cross.
        windows = true;
        programs = [{
          name = "mawk";
          # upstream has no page named awk.
          aliases = [ { name = "awk"; noMan = true; } ];
        }];
      };
      smoke = [ "-W" "version" ];
      smokePattern = "mawk 1\\.3";
      build = pkgs:
        # The engine adds a second (module) output, which flips nixpkgs'
        # multiple-outputs hook into per-dir-flag mode (--bindir/--docdir/…).
        # mawk's hand-rolled configure (Dickey's, not autoconf) rejects
        # --docdir. The module output isn't a configure dir, so suppress those
        # flags — everything installs under $out as before.
        pkgs.pkgsStatic.mawk.overrideAttrs (o: {
          setOutputFlags = false;
          patches = (o.patches or [ ]) ++ [
            ./test-longline-path.patch
            ./interactive-buffer-growth.patch
          ];
          doCheck = pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform;
        });
      # Same `setOutputFlags` note as the native build above: on the engine the
      # windows build grows a module output too, and mawk's configure is
      # Dickey's, not autoconf — it rejects --docdir.
      windowsBuild = pkgs:
        (lib.mingwStaticCross pkgs).mawk.overrideAttrs (o: {
          setOutputFlags = false;
          patches = (o.patches or [ ]) ++ [
            ./interactive-buffer-growth.patch
            ./windows-popen-pipes.patch
          ];
        });
    };
}
