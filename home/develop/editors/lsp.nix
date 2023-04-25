{
  pkgs,
  config,
  inputs,
  ...
}: let
  servers = [
    "rust-analyzer"
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
    args ? [],
    ...
  }: {
    command = "${pkg}/bin/${pkg.meta.name}";
  };
  generateHelixLang = name:
    if name == "bashls"
    then {
      name = name;
      language-server = genHelixLSP {
        pkg = pkgs.nodePackages.bash-language-server;
        args = ["start"];
      };
    }
    #else if name == "nil-ls"
    #then {
    #  name = "nix";
    #  language-server = genHelixLSP {pkg = inputs.nil.packages.${pkgs.system}.default;};
    #}
    else if pkgs ? name
    then {
      name = name;
      language-server = genHelixLSP {pkg = pkgs.${name};};
    }
    else {
      name = name;
    };
  createAlias = newName: pkg: bin:
    pkgs.symlinkJoin {
      name = newName;
      paths = [(pkgs.writeShellScriptBin "${newName}" "${pkgs.${pkg}}/bin/${bin} $@") pkgs.${pkg}];
      buildInputs = [pkgs.makeWrapper];
      postBuild = "wrapProgram $out/bin/${newName} --prefix PATH : $out/bin";
    };
  createAliasSame = newName: pkg: createAlias newName pkg pkg;

  jdtls = createAliasSame "jdtls" "jdt-language-server";
in {
  home.packages = with pkgs; [
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
  programs.helix.languages =
    map (
      name:
        generateHelixLang name
    )
    servers;
}
