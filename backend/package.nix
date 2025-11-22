# NB: in this packaging, for the sake of the demo simplicity,
# I chose not to use the exact versions from uv.lock,
# but direct packages from nixpkgs instead. This is good enough here,
# but in a serious production setup, please consider
# https://pyproject-nix.github.io/uv2nix/ to have a single source of truth between dev and prod
#
# (or stop using uv and get deps from nix also in dev :p)
{
  lib,
  buildPythonPackage,

  uv-build,

  django,
  django-cors-headers,
  django-ninja,

  pytestCheckHook,
  pytest-django,
}:
buildPythonPackage {
  pname = "infra-farm-backend";
  version = "0.1.0";
  pyproject = true;

  src = lib.cleanSource ./.;

  build-system = [
    uv-build
  ];

  dependencies = [
    django
    django-cors-headers
    django-ninja
  ];

  nativeBuildInputs = [
    pytestCheckHook
    pytest-django
  ];

  meta = {
    description = "Backend for farm infra";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
