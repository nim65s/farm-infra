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

## VM

### Build & Start

```
nix run .#nixosConfigurations.server.config.system.build.vm
```

### SSH

```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 root@localhost
```
