Flake Development Environment
=============================

This is a collection of `flake.nix` templates designed to help you quickly start coding for new projects.


Features
--------

- Contains `flake.nix` files for different programming languages and technology stacks.
- It is **Out-of-the-box** but also has sufficient **extensibility**, allowing you to continuously add new content as the project evolves.
- Designed for both **NixOS** users and **non-NixOS (Nix only)** users.
- And it is compatible with traditional toolchains, allowing for **seamless collaboration** with non-Nix users.


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
