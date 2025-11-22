# Farm Infra

```
nix run .#nixosConfigurations.server.config.system.build.vm
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 root@localhost
```
