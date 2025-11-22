# Farm Infra Frontend

An example frontend for farm-infra in Svelte + TS + Vite

## Dev

Development is managed by `yarn` & `vite`:

```
yarn dev
```

## Prod

Production is managed by `package.nix` used in `nix-farm-web.nix` NixOS module.

NB: when yarn update stuff, you'll need to update the hash in `package.nix` with:

```
yarn-berry-fetcher missing-hashes yarn.lock > missing-hashes.json
yarn-berry-fetcher prefetch yarn.lock missing-hashes.json
```

(`yarn-berry-fetcher` is a nix thing, you can get it from default `devShell` in main `flake.nix` of this repo)
