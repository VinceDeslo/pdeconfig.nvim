# pdeconfig.nvim

This repo is a flake wrapping my Neovim lua configuration in order for easy reuse in Home Manager.

## Inspiration
It is highly inspired from the [thealtf4stream.nvim](https://github.com/ALT-F4-LLC/thealtf4stream.nvim) repo. I found his approach of packaging a Neovim configuration as a Nix flake to be super practical since I can continue to configure Neovim without some abstraction such as NixVim. Furthermore, keeping the plugin as Lua makes it very simple to refer to the Neovim APIs while removing my dependency on Lazy & Mason.

## Local Development

```shell
# Format the Nix code 
nix fmt

# Dev shell
nix develop

# Dev shell commands
just
just update
just check
just run
just package "default"
just package "neovim"
```
