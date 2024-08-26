{
  description = "A Python development environment with uv/poetry/pip (powered by devenv)";

  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
    nixpkgs-python.inputs = { nixpkgs.follows = "nixpkgs"; };
  };

  nixConfig = {
    extra-substituters = "https://devenv.cachix.org";
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  };


  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
  let
    eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f rec {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
      devShells = self.devShells.${system};
      cfg = self.devenvConfig;
    });
  in
  {
    devenvConfig = {
      #DOC: https://devenv.sh/reference/options

      # packages = pkgs: [ pkgs.git ];  # add packages from nixpkgs

      languages.python.enable = true;
      #languages.python.version = "3.12"; # set python version explicitly

      languages.python.poetry.enable = true;

      # processes.hello.exec = "hello"; # add custom processes (for `devenv-up`)
    };

    packages = eachSystem ({devShells, ...}: {
      devenv-up = devShells.default.config.procfileScript;
    });

    devShells = eachSystem ({pkgs, cfg, ...}:
    {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          (cfg // { packages = cfg.packages pkgs; })
          {
            enterShell = pkgs.lib.mkIf cfg.languages.python.poetry.enable ''
              export PATH=$(poetry env info --path)/bin:$PATH
            '';
          }
        ];
      };
    });
  };
}
