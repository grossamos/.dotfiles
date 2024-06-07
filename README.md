# .dotfiles
This is a collection of my dotfiles for my nixos setup.

## Setup

In order to get this working on a new machine run:
```bash
sudo nixos-rebuild switch --flake .
```

## Updating
The configuration contains a script that automatically versions this configuration and pushes changes to github:
```bash
rebuild
```
