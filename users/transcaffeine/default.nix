{
  pkgs,
  lib,
  config,
  ...
}:

{

  users.users.transcaffeine = {
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCnjrKWYc0bcIsTkdpyC+yAsxSeY9M1WxVDNm3I/R3BYqyvfFuzJMQyh5APhM52yKGMN9UOuJPNPz0C4P6EY3iC3ZqUHFJ6ILrZZxdLZBVxdy2F19Xv6XcZkZxLpRKWapVFECF5z/Bi0rg1uzNRyrHjfZWcHfHIvlqxUYiitvvTbbSMQKqEV8wlnshSzBoYzaKtV1+crwlgz6wCnXq8HIupEeWfUc9kc+zunpYnuHnU5Z3HhzQGBuIiPoVritDjOo7qYREftV4qQ15xFWdezsMZlR15edwZeyNdAEx044QgaGddC8uEMoi5cp4APIqH1cEkIvSU6Y+esdgZ4CHU6M5G5ub5PTT2TaKoUMLLFtpW6QImjVApixFTHWR7tUhqInplWWLqvviS4MoI1ppxgcDUg/bgPdeDBsoRkbESr2uT8ResNi9DlPlN2rlUjlb28awzHm7agFhwfPQZ1afnFSUh0tTFz1WeR7xIGhxR1xXc8sapJhgLnYYWpR2NaJzbYYdk7CWW/3rgEsJem7Kvll6HevnFgRP/uVhEyGZl9hw+tECzvwB/LEmQ/4raDMxqOB9XO9kusJX/jTnQIObrFubfKn3ToXlYbQxZX9+QobANvQ8huILz1bBeH8aKjf9RXu+j4VNyoCKhzU/v0MIdRCsgVWgjuYXMGRo0MFMFyMqQiw=="
    ];
    isNormalUser = true;
    extraGroups = [
      "libvirtd"
      "wheel"
    ];
  };

  home-manager.users.transcaffeine = {
    home.stateVersion = "25.11";
    # prevent ifd
    manual.manpages.enable = false;
  };
}
