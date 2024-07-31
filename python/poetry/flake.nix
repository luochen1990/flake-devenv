{
  description = "A Python development environment with poetry";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    eachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f rec {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
      python3 = pkgs.python3; # or pkgs.python3.withPackages (p: []) if you need more python packages in nixpkgs
      py-version = python3.version;
    });
  in
  {
    # use them via `nix develop .#xxx` or `direnv allow`
    devShells = eachSystem ({pkgs, python3, ...}: rec {
      default = poetry;

      poetry = pkgs.mkShell {
        buildInputs = [
          python3
          pkgs.poetry
        ];

        shellHook = ''
          export PATH=$(poetry env info --path)/bin:$PATH
        '';
      };
    });

    # use them via `nix run .#xxx`
    apps = eachSystem ({system, pkgs, ...}: {
      default = {
        type = "app";
        program = "${pkgs.writeShellScript "funix-app" ''
          source ${self.devShells.${system}.default.shellHook}
          funix ./src
        ''}";
      };
    });

  };
}
