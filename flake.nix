{
  outputs =
    { self }:
    let
    in
    {
      apps = builtins.mapAttrs (system: pkgs: {
        default = {
          type = "app";
          program = ./.flox/flake/run.sh;
        };
      }) self.raw_packages_listing;

      # Process lockfile into a tree form
      raw_packages_listing =
        let
          lock = builtins.fromJSON (builtins.readFile ./.flox/env/manifest.lock);
          pkgsBySystem = builtins.groupBy (x: x.system) lock.packages;
          pkgsBySystemAttrOutput = builtins.mapAttrs (
            system: pkgs:
            let
              initGrouping = builtins.concatMap ( x:
                builtins.attrValues (
                  builtins.mapAttrs ( k: y: x // { path = y; output = k; }) x.outputs
                )) pkgs;
              perOutput = builtins.groupBy (x: "${x.attr_path}-${x.output}") initGrouping;
              finalForm = builtins.mapAttrs ( k: v: builtins.elemAt v 0) perOutput;
            in
            finalForm
          ) pkgsBySystem;
        in
        pkgsBySystemAttrOutput;

      packages = builtins.mapAttrs (
        system: pkgs:
        let
          closure =
            pkg:
            builtins.fetchClosure {
              fromStore = "https://cache.nixos.org";
              fromPath = pkg.path;
              inputAddressed = true;
            };
        in
        {
          default = builtins.derivation {
            name = "env";
            inherit system;
            builder = "builtin:buildenv";
            derivations = builtins.attrValues (
              builtins.mapAttrs (name: x: [
                "true"
                (toString x.priority)
                1
                (closure x)
              ]) pkgs
            );
            manifest = "/dummy";
          };
        }
        // builtins.mapAttrs (name: pkg: closure pkg) pkgs
      ) self.raw_packages_listing;

      build_packages = builtins.mapAttrs (
        system: pkgs:
        builtins.mapAttrs (
          name: pkg:
          # TODO: Provenance not stored in a usable form in lockfile, assume nixpkgs for now
          let
            flake = builtins.getFlake "github:flox/nixpkgs/${pkg.rev}";
          in
          flake.legacyPackages.${system}.${pkg.attr_path} or flake.packages.${system}.${pkg.attr_path}
        ) pkgs
      ) self.raw_packages_listing;

      devShells = builtins.mapAttrs (system: pkgs: {
        default =
          let
            getEnvSh = import ./.flox/flake/get-env.sh.nix;
            arg = {
              name = "devshell";
              builder = "${
                builtins.fetchClosure {
                  fromStore = "https://cache.nixos.org";
                  fromPath =
                    self.packages.${system}.bash-out or (throw "No bash found, install one into the toplevel");
                  inputAddressed = true;
                }
              }/bin/bash";
              inherit system;
              outputs = [ "out" ];
              stdenv = ./.flox/flake/stdenv;
              packages = [ pkgs.default ];

              # can append more context eg: argContext = builtins.getContext (toString derivationArg.args);
              args = [ (builtins.appendContext getEnvSh { }) ];

              shellHook = ''
                echo shellHook startup

                . <(nix eval --impure --expr 'let __div=x: y: y x; in ${./.flox/env}/manifest.toml / __readFile / builtins.fromTOML
                     / (x: x.vars or {}) / __mapAttrs (k: v: "export k=\"''${v}\"" ) / __attrValues / __concatStringsSep "\n"' --raw)

                . <(nix eval --impure --expr 'let __div=x: y: y x; in ${./.flox/env}/manifest.toml / __readFile / builtins.fromTOML
                     / (x: x.hook.on-activate or "")' --raw)

                # Find the parent shell
                pid=$PPID
                while [ "$pid" -ne 0 ]; do
                    new_shell=$(ps -p $pid -o comm= 2>/dev/null)
                    case "$new_shell" in
                        *bash|*zsh|*fish|*sh|*ksh|*csh|*tcsh) break ;;
                        *) : ;;
                    esac
                    pid=$(ps -p $pid -o ppid= 2>/dev/null | tr -d '[:space:]')
                    [ -z "$pid" ] && break
                done
                new_shell="''${new_shell#-}
                "$new_shell"
                echo shellHook exiting
              '';
            };
          in
          derivation arg;
      }) self.packages;

    };
}
