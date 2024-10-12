__default:
	just --list

update:
	nix flake update

check:
	nix flake check

package profile="default":
    nix build --json --no-link --print-build-logs ".#{{ profile }}"
