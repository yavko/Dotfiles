{
  dart-sass,
  stdenvNoCC,
  src ? ./styles,
  entry ? "main",
}:
stdenvNoCC.mkDerivation {
  pname = "built-scss";
  version = "1.0";
  inherit src;
  nativeBuildInputs = [dart-sass];
  buildPhase = ''
    dart-sass ${entry}.scss > __nix_out__.css.out
  '';
  installPhase = ''
    mkdir -p $out/
    cp __nix_out__.css.out $out/out.css
  '';
}
