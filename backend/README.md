# Farm Infra Backend

An example backend for farm-infra in django, with a django-ninja API

## Dev

Development is managed by `uv` & `django-admin`:

```
uv run manage.py migrate
uv run manage.py createsuperuser
uv run manage.py runserver
```

## Prod

Production is managed by `package.nix` used in `nix-farm-web.nix` NixOS module.

NB: For serious business, `package.nix` should follow the exact versions from `uv.lock`. 
In that case, ref. <https://pyproject-nix.github.io/uv2nix/>
