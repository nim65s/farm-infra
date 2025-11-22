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

  buildPhase = "yarn build --outDir $out";
  checkPhase = "yarn check";

  doCheck = true;

  meta = {
    description = "Frontend for farm infra";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
