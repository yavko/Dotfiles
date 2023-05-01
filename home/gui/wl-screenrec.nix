{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    (pkgs.rustPlatform.buildRustPackage {
      pname = "wl-screenrec";
      version = (builtins.fromTOML (builtins.readFile (inputs.wl-screenrec + "/Cargo.toml"))).package.version;
      src = inputs.wl-screenrec;
      cargoDeps = pkgs.rustPlatform.importCargoLock {lockFile = inputs.wl-screenrec + "/Cargo.lock";};
      cargoLock.lockFile = inputs.wl-screenrec + "/Cargo.lock";
      nativeBuildInputs = with pkgs; [pkg-config wayland-scanner clang clang.cc.lib];
      LIBCLANG_PATH = "${pkgs.clang.cc.lib}/lib";
      preConfigure = ''
        export LIBCLANG_PATH="${pkgs.clang.cc.lib}/lib"
      '';
      nativeCheckInputs = [pkgs.clang];
      passthru = {inherit (pkgs) clang;};
      preBuild = let
        inherit (pkgs) stdenv lib;
      in ''
        export BINDGEN_EXTRA_CLANG_ARGS="$(< ${stdenv.cc}/nix-support/libc-crt1-cflags) \
              $(< ${stdenv.cc}/nix-support/libc-cflags) \
              $(< ${stdenv.cc}/nix-support/cc-cflags) \
              $(< ${stdenv.cc}/nix-support/libcxx-cxxflags) \
              ${lib.optionalString stdenv.cc.isClang "-idirafter ${stdenv.cc.cc}/lib/clang/${lib.getVersion stdenv.cc.cc}/include"} \
              ${lib.optionalString stdenv.cc.isGNU "-isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc} -isystem ${stdenv.cc.cc}/include/c++/${lib.getVersion stdenv.cc.cc}/${stdenv.hostPlatform.config} -idirafter ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${lib.getVersion stdenv.cc.cc}/include"} \
            "
      '';
      buildInputs = with pkgs; [
        wayland
        wayland-protocols
        ffmpeg
        x264
        libpulseaudio
        ocl-icd
        opencl-headers
        clang.cc.lib
      ];
    })
  ];
}
