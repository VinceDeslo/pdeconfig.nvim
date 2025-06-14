{
  description = "Neovim configuration for my personal development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        lib = import ./lib {inherit inputs;};
      };

      systems = ["aarch64-darwin" "x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) alejandra just mkShell;
      in {
        # Definition of the Neovim entrypoint based on packages below
        apps = {
          nvim = {
            program = "${config.packages.neovim}/bin/nvim";
            type = "app";
          };
        };

        # Development utils
        devShells = {
          default = mkShell {
            buildInputs = [just];
          };
        };
        formatter = alejandra;

        # Packages pulled in from the local lib to construct Neovim
        packages = {
          default = self.lib.mkVimPlugin {inherit system;};
          neovim = self.lib.mkNeovim {inherit system;};
        };
      };
    };
}
