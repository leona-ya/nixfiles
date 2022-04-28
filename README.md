# leona's nixfiles

In this repo is the configuration for all my [NixOS](https://nixos.org) based servers and desktops located.

## Structure
```
nixfiles
├── common              # NixOS configuration applyed to all hosts
├── deploy.sh           # custom deploy script
├── desktop             # NixOS configuration for all desktop devices
├── hosts               # NixOS configuration for specific hosts 
├── lib                 # helpers
├── modules             # NixOS Modules (stuff used on multiple hosts)
├── packages            # Nix Packages (not in nixpkgs)
├── secrets             # Secrets (managed by sops-nix) 
├── services            # Nix files for services
└── users               # NixOS configuration for specific users
```
