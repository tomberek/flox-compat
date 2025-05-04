#!/bin/sh
NIX_CONFIG=$(printf "%s\n" "experimental-features = nix-command flakes fetch-closure" "builders =")
export NIX_CONFIG

system=$(nix config show system)
dir=$(CDPATH= cd -- "$(dirname -- "$0")"/../.. && pwd)
flake="$dir"

# Used to either substitute, fetch (using fetchClosure information), or build the packages from the manifest.lock
# TODO: include out-links for better caching?
fetch_build(){
  # There is a TAB in the IFS whitespace
  nix eval "$flake#.raw_packages_listing.$system." --apply 'x: builtins.concatStringsSep "\n" (map (x: builtins.concatStringsSep "\t" [x.path x.attr_path x.output] ) (builtins.attrValues x))' --raw | \
  {
    while IFS="	" read -r path attr output; do
      nix build "$path"                                        || \
      nix build "$flake#.packages.$system.$attr-$output"       || \
      nix build "$flake#.build_packages.$system.$attr-$output" &
    done
    wait
  }
}

fetch_build

echo "Starting SHELL: $SHELL"

exec nix develop -L "$flake#" -c "${@:-true}"
