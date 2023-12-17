# NixOS

## Guide

### Boot Live USB

```
sudo -i
systemctl start wpa_supplicant
wpa_cli
add_network
set_network 0 ssid "network"
set_network 0 psk "password"
set_network 0 key_mgmt WPA-PSK
enable_network 0
quit
```

### nvme:
```
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart primary 512MB -8GB
parted /dev/nvme0n1 -- mkpart primary linux-swap -8GB 100%
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1 -- set 3 esp on

mkfs.ext4 -L nixos /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3
```

### sda:
```
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3
```

### Mounting:
```
mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot

mount /dev/disk/by-label/boot /mnt/boot
```

`swapon /dev/nvme0n1p2`
or
`swapon /dev/sda2`

### Config:

```
nixos-generate-config --root /mnt
nix-env -iA nixos.git
git clone https://gitlab.com/Alllusive/dotfiles /mnt/etc/nixos/allusive
```

### Install:
```
rm /mnt/etc/nixos/allusive/nix/hardware-configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/allusive/nix/hardware-configuration.nix
nixos-install --flake /mnt/etc/nixos/allusive#nixos
```

## Setup

Check the `install` script to finish everything else up if needed
