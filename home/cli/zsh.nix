{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    zsh-powerlevel10k
    zsh-fzf-tab
    lesspipe
    less
    bat
    exa
    chafa
    exiftool
    file
		binutils
		figlet
  ];
  programs.zsh = {
    enable = true;
		enableCompletion = true;
    autocd = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    historySubstringSearch = {
      searchUpKey = ''^[[A' history-substring-search-up
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M emacs '^P'';
      searchDownKey = ''^[[B' history-substring-search-down
      bindkey "$terminfo[kcud1]" history-substring-search-down
      bindkey -M vicmd 'j' history-substring-search-down
      bindkey -M emacs '^N'';
      enable = true;
    };
    dotDir = ".config/zsh";

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.zsh";
      }
      {
       name = "zsh-cat-syntax";
       src = pkgs.fetchFromGitHub {
         owner = "catppuccin";
         repo = "zsh-syntax-highlighting/";
         rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
         sha256 = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
       };
       file = "themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
      }
			{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
      {
        name = "p10k-config";
        src = ./p10k;
        file = "p10k.zsh";
      }
    ];
    localVariables = let
      lessfilter = pkgs.writeShellScript "lessfilter.sh" ''
        mime=$(file -bL --mime-type "$1")
        category=''${mime%%/*}
        kind=''${mime##*/}
        if [ -d "$1" ]; then
        	exa --all --color=always --icons "$1"
        elif [ "$category" = image ]; then
        	chafa -f symbols "$1"
        	exiftool "$1"
        elif [ "$category" = text ]; then
        	bat --color=always "$1"
				elif [ "$mime" = "inode/x-empty" ]; then
					figlet empty
					figlet file
				elif [ "$kind" = "pgp-keys" ]; then
					gpg --show-keys --with-fingerprint "$1"
        else
         lesspipe.sh "$1" | bat --color=always
        fi
      '';
    in {
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
      LESSOPEN = "|${lessfilter} %s";
      ZSH_AUTOSUGGEST_STRATEGY = ["history" "completion"];
    };
    initExtra = ''
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false

      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always --icons $realpath'

      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'

      zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ''${(Q)realpath}'

      zstyle -d ':completion:*' format

      zstyle ':completion:*:descriptions' format '[%d]'

			export LS_COLORS="$(vivid generate catppuccin-mocha)"
    '';
    shellAliases = {
      cavaw = "kitty  --override font_size=0 --execute cava &";
      cat = "bat";
      ls = "exa --all --icons";
      tree = "exa --tree --all --icons";
      icat = "kitty +kitten icat";
      open = "xdg-open";
    };
  };
}
