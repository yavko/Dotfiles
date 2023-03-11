{pkgs, ...}: let
	vividPkg = pkgs.rustPlatform.buildRustPackage {
  	pname = "vivid";
  	version = "0.9.0";

  	src = pkgs.fetchFromGitHub {
			owner = "sharkdp";
    	repo = "vivid";
    	rev = "9299aa4c843bb7ed757b47bb2449abbba3aed793";
    	sha256 = "sha256-gzl4ETkwnSuSKA0g7udOdFbnG1poXU/ZQyDJj/zqOV4=";
		};

  	cargoSha256 = "sha256-4BpaEjh2SWAObprAXs6cYGuoc9tky6DNdkUVZ8AHkK4=";

	  meta = with pkgs.lib; {
    	description = "A generator for LS_COLORS with support for multiple color themes";
    	homepage = "https://github.com/sharkdp/vivid";
    	license = with licenses; [ asl20 /* or */ mit ];
    	maintainers = [ maintainers.dtzWill ];
    	platforms = platforms.unix;
  	};
	};
in {
  imports = [
    ./bat.nix
    ./cava.nix
    ./macchina.nix
    ./zsh.nix
    ./btop.nix
  ];
  home.packages = with pkgs; [
    trashy
    socat
    unzip
		vividPkg
  ];
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    settings = {
      confirm_os_window_close = "0";
    };
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    ];
  };
}
