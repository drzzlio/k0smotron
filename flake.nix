{
  description = "Kubebuilder Flake";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-23.11"; };
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, devenv }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ inputs.devenv.flakeModule ];
    systems = nixpkgs.lib.systems.flakeExposed;

    perSystem = { config, system, pkgs, ... }: {
      packages.default = pkgs.buildGoModule {
        name = "k0smotron";
        src = ./.;
        vendorHash = "sha256-kXwhE9QSYwuDjszF0tydpwvREYM1WlbDztmr+3n/f4g=";
      };

      devenv.shells.default = {
        languages.go.enable = true;
        languages.c.enable = true;

        env = {
          GOPROXY="https://proxy.golang.org,direct";
        };

        packages = with pkgs; [
          gopls
          gotools
          go-tools
          kubebuilder
          kustomize
          gnumake
        ];
      };

    };

  };
}
