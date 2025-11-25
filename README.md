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
nix run .#nixosConfigurations.farm-infra-server.config.system.build.vm
```

### SSH

```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 root@localhost
```

## RPi

Demo laptop must have 192.168.3.10/24, aka. web.farm

RPi has hardcoded     192.168.3.14/24.

Also, 8000 must be open on host, so eg.:
```
sudo ip addr add 192.168.3.10/24 dev CHANGEME
sudo iptables -I INPUT -p tcp --dport 8000 -j ACCEPT
```

### Initial deploy

```
nix build .#nixosConfigurations.farm-infra-rpi.config.system.build.sdImage
caligula burn result/sd-image/nixos-image-sd-card-*-aarch64-linux.img.zst
```
