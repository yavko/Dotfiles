{
  pkgs,
  config,
	inputs,
  ...
}: let
	papirus-cat = pkgs.papirus-icon-theme.overrideAttrs (finalAttrs: previousAttrs: {
    buildInputs = [pkgs.getent pkgs.sudo];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/icons
      mv {,e}Papirus* $out/share/icons
      cp -r ${cat-folders}/src/* $out/share/icons/Papirus
      for theme in $out/share/icons/*; do
        #${pkgs.bash}/bin/bash ${cat-folders}/papirus-folders -t $theme -o -C cat-mocha-peach
      	${papirus-folders-cat}/bin/papirus-folders -t $theme -o -C cat-mocha-peach
      	gtk-update-icon-cache --force $theme
      done
      runHook postInstall
    '';
  });

  rev = "210a220814740bfc47152cb7d008076cae511905";
  cat-folders = pkgs.fetchFromGitHub {
    owner = "yavko";
    repo = "papirus-folders";
    rev = rev;
    sha256 = "sha256-3yjIGzN+/moP2OVGDIAy4zPqUroSjx3c2mJjdZGhTsY=";
  };
  papirus-folders-cat = pkgs.stdenv.mkDerivation {
    pname = "papirus-folders";
    version = "1.12.1.0";
    src = inputs.papirus-folders-yavko;
    buildInputs = with pkgs; [getent];
    makeFlags = ["PREFIX=${placeholder "out"}"];
    patchPhase = ''
      substituteInPlace ./papirus-folders --replace "getent" "${pkgs.getent}/bin/getent"
    '';
  };
	papirus-better = pkgs.papirus-icon-theme.overrideAttrs (final: prev: {
		nativeBuildInputs = with pkgs; [ gtk3 papirus-folders-cat getent sudo ];
		installPhase = ''
    	runHook preInstall
    	mkdir -p $out/share/icons
    	mv {,e}Papirus* $out/share/icons
			ls $out/share/icons
			${papirus-folders-cat}/bin/papirus-folders -l
    	for theme in $out/share/icons/*; do
    		echo installing for $theme
				cp -r ${inputs.papirus-folders-yavko}/src/* $out/share/icons/$theme
      	${papirus-folders-cat}/bin/papirus-folders -t $theme -o -C cat-mocha-peach
      	gtk-update-icon-cache --force $theme
    	done
    	runHook postInstall
  	'';
	});
in {
  enable = true;

  font = {
    name = "Roboto";
    package = pkgs.roboto;
  };

  gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  iconTheme = {
    name = "Papirus-Dark";
    #package = papirus-better;
		package = pkgs.papirus-icon-theme.override {color = "orange";};
		#papirus-better; #.override {color = "cat-mocha-peach";};
  };

  theme = {
    name = "Catppuccin-Mocha-Compact-Peach-Dark";
    package = pkgs.catppuccin-gtk.override {
      size = "compact";
      accents = ["peach"];
      variant = "mocha";
    };
  };
}
