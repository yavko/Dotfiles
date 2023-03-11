{ pkgs, ... }: {
	home.packages = with pkgs; [
		grapejuice
		prismlauncher-qt5
	];
}
