{
  fuse,
  fuse3,
  fuse-common,
  dotnetCorePackages,
  dotnet-runtime,
  buildDotnetModule,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  lib,
  xorg,
  lttng-ust,
  alsa-lib,
  libGL,
  numactl,
  fontconfig,
  libXcursor,
  libXext,
  libXrandr,
  glew,
}: let
  version = "0.1.112";
  desc = "Open singing synthesis platform / Open source UTAU successor";
in
  buildDotnetModule {
    pname = "openutau";
    inherit version;
    src = fetchFromGitHub {
      owner = "stakira";
      repo = "OpenUtau";
      rev = "build/" + version;
      sha256 = "sha256-G/y+RJ8NYpOtGg6vR+eTcieDZUBgK1WcfZ4iqiOamqQ=";
    };
    desktopItems = [
      (makeDesktopItem {
        desktopName = "OpenUtau";
        name = "OpenUtau";
        exec = "OpenUtau";
        icon = "openutau";
        comment = desc;
        type = "Application";
        categories = ["Audio"];
      })
    ];
    fixupPhase = ''
        runHook preFixup

      mkdir -p $out/share/pixmaps
      cp -f OpenUtau/Logo/openutau.svg $out/share/pixmaps/openutau.svg

        runHook postFixup
    '';
    projectFile = "OpenUtau/OpenUtau.csproj";
    nugetDeps = ./deps.nix;
    dotnet-sdk = with dotnetCorePackages;
      combinePackages [
        sdk_7_0
        sdk_6_0
      ];
    dotnet-runtime = dotnetCorePackages.runtime_7_0;
    executables = ["OpenUtau"];
    buildType = "Release";
    #packNupkg = true;
    nativeBuildInputs = [copyDesktopItems];
    makeWrapperArgs = [
      # Without this Ryujinx fails to start on wayland. See https://github.com/Ryujinx/Ryujinx/issues/2714
      "--set GDK_BACKEND x11"
      "--set SDL_VIDEODRIVER x11"
    ];
    runtimeDeps = [
      fuse
      fuse3
      fuse-common
      xorg.libXi
      libGL
      xorg.libX11
      xorg.libICE
      xorg.libSM
      fontconfig
      lttng-ust
      alsa-lib
      numactl
      libXcursor
      libXext
      libXrandr
      glew
    ];
    #libraryPath = lib.makeLibraryPath runtimeDeps;
    # makeWrapperArgs = [
    #   ''--suffix PATH : "${lib.makeBinPath [xdg-utils]}"''
    # ];
    meta = with lib; {
      description = desc;
      homepage = "http://www.openutau.com/";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "OpenUtau";
    };
    passthru.updateScript = ./update.sh;
  }
