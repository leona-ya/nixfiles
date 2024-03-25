# leona's nixfiles

In this repo is the configuration for all my [NixOS](https://nixos.org) based servers and desktops located.

## Structure
```
nixfiles
├── hosts               # Configuration for specific hosts 
├── lib                 # helpers
├── modules             # NixOS Modules (prefixed with `l.`)
├── packages            # Nix Packages (not in nixpkgs)
├── profiles            # Profiles that can be applied to multiple hosts. These are an abstraction for different types of hosts
│  ├── base             # Configuration for all hosts
│  ├── desktop          # Configuration for all desktops
│  └── zfs-nopersist    # Configuration for a volantile zfs based filesystem
├── secrets             # Secrets (managed by sops-nix) 
├── services            # Definition of services. Services are not specific to one host, but can be used more generally
└── users               # Configuration for specific users
```

## Flake outputs

Some NixOS modules and the leona user profile are published as flake output.
