{
  lib,
  stdenv,

  nodejs,
  yarn-berry,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "infra-farm-frontend";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    ## updating this hash is extra boring:
    # yarn-berry-fetcher missing-hashes yarn.lock > missing-hashes.json
    # yarn-berry-fetcher prefetch yarn.lock missing-hashes.json
    hash = "sha256-JhXCFRI77NCyBHvxepziixdJWhK5LDYXjwoeCrcoadU=";
  };

  # in dev we're on http://localhost:5173/, so we need to document the API full URL.
  # but in prod, we want to rely on nginx to correctly wire things, so we can http://whatever.tld/api/todos
  buildPhase = "substituteInPlace src/api.ts --replace-fail 'http://localhost:8000' ''";

  installPhase = "yarn build --outDir $out";

  checkPhase = "yarn check";
  doCheck = true;

  meta = {
    description = "Frontend for farm infra";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
