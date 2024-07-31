{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
  let
    project-name = "name-of-your-project"; #TODO: change it to your own
    ghc-version = "ghc98"; #TODO: change it as you wish
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    eachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f rec {
      inherit system;
      pkgs = nixpkgs.legacyPackages.${system};
      hpkgs = pkgs.haskell.packages.${ghc-version};
      ghc = hpkgs.ghcWithPackages (p: [ self.packages.${system}.default ]);
    });
  in
  rec {
    packages = eachSystem ({hpkgs, ...}: {
      default = hpkgs.callCabal2nix project-name ./. { };
    });

    # use them via `nix develop .#xxx` or `direnv allow`
    devShells = eachSystem ({pkgs, hpkgs, system, ...}: {
      default = pkgs.haskell.lib.addBuildTools packages.${system}.default
        (with hpkgs; [ haskell-language-server cabal-install ]);
    });

    # use them via `nix run .#xxx`
    apps = eachSystem ({pkgs, ghc, system, ...}: rec {
      default = main;
      ghci = {
        type = "app";
        program = "${pkgs.writeShellScript "${project-name}-ghci" ''
          exec ${ghc}/bin/ghci -ghci-script ${
            #TODO: change it as you wish
            pkgs.writeText ".ghci" ''
              :set +s
            ''
          }
        ''}";
      };
      main = {
        type = "app";
        program = "${packages.${system}.default}/bin/${project-name}";
      };
    });

  };
}
