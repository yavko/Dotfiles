{
  pkgs,
  lib,
  ...
}: let
  servers = [
    "rust-analyzer"
    #"nixd"
    "nil-ls"
    "tsserver"
    "bashls"
    "jdtls"
    "clangd"
    "cssls"
    "html"
    "jsonls"
    "lua-ls"
    "ltex"
    "marksman"
    "yamlls"
  ];
  genHelixLSP = {
    pkg,
    args ? [""],
  }: {
    command = "${lib.meta.getExe pkg}";
    inherit args;
  };
  generateHelixLang = name:
    if name == "bashls"
    then
      genHelixLSP {
        pkg = pkgs.nodePackages.bash-language-server;
        args = ["start"];
      }
    #else if name == "nixd"
    #then genHelixLSP {pkg = inputs.nixd.packages.${pkgs.system}.default;}
    else if name == "nil-ls"
    then genHelixLSP {pkg = pkgs.nil;} # inputs.nil.packages.${pkgs.system}.default;}
    else if pkgs ? name
    then
      genHelixLSP {
        pkg = pkgs.${name};
      }
    else {command = name;};

  createAlias = newName: pkg: bin:
    pkgs.symlinkJoin {
      name = newName;
      paths = [(pkgs.writeShellScriptBin "${newName}" "${pkgs.${pkg}}/bin/${bin} $@") pkgs.${pkg}];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = "wrapProgram $out/bin/${newName} --prefix PATH : $out/bin";
    };
  createAliasSame = newName: pkg: createAlias newName pkg pkg;

  jdtls = createAliasSame "jdtls" "jdt-language-server";
in {
  home.packages = with pkgs; [
    #nil
    #(inputs.nixd.packages.${pkgs.system}.default)
    #(inputs.nil.packages.${pkgs.system}.default)
    nil
    alejandra
    rust-analyzer
    jdt-language-server
    jdtls
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    clang-tools
    lua-language-server
    stylua
    ltex-ls
    marksman
  ];
  programs.neovim.plugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "lsps";
      src = let
        path = pkgs.writeTextDir "lua/lsps.lua" "return { ${
          builtins.concatStringsSep
          ", " (map (x: "\"${builtins.replaceStrings ["-"] ["_"] x}\"") servers)
        }}";
      in
        path;
    })
  ];
  programs.helix.languages = {
    language = [
      {
        name = "bash";
        auto-format = true;
        formatter = {
          command = "${pkgs.shfmt}/bin/shfmt";
          args = ["-i" "2" "-"];
        };
      }
    ];
    language-server = lib.genAttrs servers (
      name:
        generateHelixLang name
    );
  };
}
