# Farm Infra

## Dev

### Backend

```
cd backend
uv run manage.py runserver
```

### Frontend

```
cd frontend
yarn dev
```

## Server VM

### Build & Start

```
nix run .#nixosConfigurations.server.config.system.build.vm
```

### SSH

```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 root@localhost
```

## RPi

Demo laptop must have 192.168.3.10/24, aka. web.farm
RPi has hardcoded     192.168.3.14/24.

### Initial deploy

```
nix build .#nixosConfigurations.rpi.config.system.build.sdImage
caligula burn result/sd-image/nixos-image-sd-card-*-aarch64-linux.img.zst
```
