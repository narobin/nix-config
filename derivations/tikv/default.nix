{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  cmake,
  pkg-config,
  protobuf,
  gawk,
}:
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    features = [
      "memory-engine"
      "jemalloc"
      "pprof-fp"
      "trace-async-tasks"
      "test-engine-kv-rocksdb"
      "test-engine-raft-raft-engine"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "portable"
      "mem-profiling"
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [ "sse" ];
    featureString = lib.concatStringsSep "," features;
  in
  {
    pname = "tikv";
    version = "8.5.8";

    src = fetchFromGitHub {
      owner = "tikv";
      repo = "tikv";
      tag = "v${finalAttrs.version}";
      hash = "sha256-U/9/YK7LQ+DRahZUu7Py3DFFpxxyXoXBMVRznxwX170=";
    };

    cargoHash = "sha256-Tk2CDwDEChlGYBDRgnw9t5FOdU4g3xQqr1iQZig0/Ns=";

    nativeBuildInputs = [
      pkg-config
      cmake
      protobuf
      gawk
      rustPlatform.bindgenHook
    ];

    buildInputs = [ openssl ];

    cargoBuildFlags = [
      "--no-default-features"
      "--features"
      featureString
      "--config"
      "profile.release.lto=\"fat\""
      "--config"
      "profile.release.package.server.opt-level=3"
      "--config"
      "profile.release.package.server.codegen-units=1"
    ];

    env = {
      RUSTC_BOOTSTRAP = "1";
      RUSTFLAGS = "-Cforce-frame-pointers=yes";
      OPENSSL_NO_VENDOR = "1";
      CMAKE_POLICY_VERSION_MINIMUM = "3.5";
      TIKV_ENABLE_FEATURES = featureString;
      TIKV_PROFILE = "release";
    };

    postPatch = ''
      titan_dir=$(find "$cargoDepsCopy" -maxdepth 2 -type d -name 'libtitan_sys-*' -print -quit)
      rocks_dir=$(find "$cargoDepsCopy" -maxdepth 2 -type d -name 'librocksdb_sys-*' -print -quit)
      ln -sfn "$rocks_dir/rocksdb" "$(dirname "$titan_dir")/rocksdb"

      substituteInPlace src/server/tablet_snap.rs \
        --replace-fail "BorrowedBuf<'_>" "BorrowedBuf<'_, u8>"
    '';

    doCheck = false;

    meta = {
      description = "Distributed transactional key-value database";
      homepage = "https://tikv.org";
      license = lib.licenses.asl20;
      maintainers = [ ];
      mainProgram = "tikv-server";
    };
  }
)
