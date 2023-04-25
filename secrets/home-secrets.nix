{
  config,
  pkgs,
  lib,
  ...
}: let
  # Works very well, if using home-manager separately, well sadly,
  # I don't anymore, so I just use agenix, but this is still pretty nifty
  decrypt = with builtins;
    {
      secret,
      key,
      finalPathDir,
      finalPathFile,
      prefix ? "",
      suffix ? "",
      name ? "",
    }: let
      finalPathStr = "${toString finalPathDir}/${toString finalPathFile}";
      pre =
        if prefix == ""
        then ""
        else "'${prefix}'";
      suf =
        if suffix == ""
        then ""
        else "'${suffix}'";
    in ''
        decrypt_and_write() {
      local hash=$(nix-hash --flat ${toString secret})
      if [[ -f ${finalPathStr}}.hash ]] && [[ hash == ${finalPathStr}.hash ]]; then
      	${
        if name != ""
        then "echo 'Secret ${name} hasn't changed"
        else "echo 'Secret located at ${finalPathStr} hasn't changed"
      }
      	return 0
      fi
        	if [[ ! -d ${toString finalPathDir} ]]; then
        		mkdir -p ${toString finalPathDir}
        	fi
        	[[ -f ${finalPathStr} ]] &&  rm ${finalPathStr}
        	local secret="$(${pkgs.rage}/bin/rage -d ${toString secret} -i ${toString key})"
        	echo ${pre}"$secret"${suf} > ${finalPathStr}
      ${
        if name != ""
        then "echo 'Updated secret ${name}'"
        else "echo 'Updated secret located at ${finalPathStr}'"
      }
      touch ${finalPathStr}.hash
      rm ${finalPathStr}.hash
      nix-hash --flat ${toString secret} > ${finalPathStr}.hash
        }
        decrypt_and_write
    '';
  h = config.home.homeDirectory;
in {
  home.activation.updateSecrets = lib.hm.dag.entryAfter ["writeBoundary"] (decrypt {
    secret = ./downonspot.age;
    key = "${h}/.ssh/id_ed25519";
    finalPathDir = "${h}/music-downloads";
    finalPathFile = "settings.json";
    name = "downonspot";
  });
}
