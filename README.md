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
nix flake show github:luochen1990/flake-devenv
```

Select a template (e.g. `python-poetry`), and init your project (e.g. `my-project`) via

```shell
cd my-project

nix flake init --template github:luochen1990/flake-devenv#python-poetry
```

Then activate the development environment via

```shell
direnv allow
```

Or if you prefer to activate the environment manually than use `direnv`, you can run

```shell
nix develop
```

And start your Editor/IDE here so that the development environment can be recognized

```shell
code .
```
