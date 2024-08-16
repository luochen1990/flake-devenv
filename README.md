NixOS Development Environment
=============================

This is a collection of community-maintained flake.nix templates designed to help NixOS users quickly start coding for new projects.

This contains flake.nix files for different programming languages and technology stacks. It is a basic version but has sufficient extensibility, allowing you to continuously add new content as the project evolves.

I hope that the flake.nix file here can also be used by your colleagues and friends (who likely do not use NixOS), so you won't need to prepare a separate development environment for them. Therefore, the flake here will also consider this compatibility aspect.

Of course, if you are not a NixOS user but have grown tired of struggling in non-reproducible development environments, it is also a good idea to try the solutions presented here.

Usage
-----

Show available templates

```shell
nix flake show github:luochen1990/nixos-develop-env
```

Select a template (e.g. `python-poetry`), and init your project (e.g. `my-new-project`) via

```shell
cd my-new-project

nix flake init --template github:luochen1990/nixos-develop-env#python-poetry
```

Run `direnv allow` to activate the develop environment if you use `direnv`,

Else you can run `nix develop` everytime to activate the develop environment manually.
