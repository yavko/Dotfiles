{lib, ...}: let
  inherit (builtins) map toString;
  id = list: i: builtins.elemAt list i;
  colors = builtins.attrValues (import ./colors.nix).base;
  lowerChars = lib.strings.stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  upperChars = lib.strings.stringToCharacters "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  hexes = ["a" "b" "c" "d" "e" "f"];
  hexInts = map (x: "1" + (toString x)) [0 1 2 3 4 5];
  toLower = str: builtins.replaceStrings upperChars lowerChars str;
  hexCharToInt = hex: let
    lex = toLower hex;
    nex = builtins.replaceStrings hexes hexInts lex;
  in
    lib.strings.toInt nex;
  fromHex = hexStr: let
    chars = lib.strings.stringToCharacters hexStr;
    doubles = [[(id chars 1) (id chars 2)] [(id chars 3) (id chars 4)] [(id chars 5) (id chars 6)]];
    r = ((hexCharToInt (id (id doubles 0) 0) + 0.0) * 16) + (hexCharToInt (id (id doubles 0) 1) + 0.0);
    g = ((hexCharToInt (id (id doubles 1) 0) + 0.0) * 16) + (hexCharToInt (id (id doubles 1) 1) + 0.0);
    b = ((hexCharToInt (id (id doubles 2) 0) + 0.0) * 16) + (hexCharToInt (id (id doubles 2) 1) + 0.0);
  in [r g b];
  parsedColors = map (x: fromHex x) colors;
  gColors = lib.lists.imap0 (i: x: "solarized[${toString i}] = vec3(${toString ((id x 0) / 255)},${toString ((id x 1) / 255)},${toString ((id x 2) / 255)});") parsedColors;
  lengthOfList = builtins.length gColors;
  gColorsStr = "vec3 solarized[${toString lengthOfList}];\n" + (builtins.concatStringsSep "\n" gColors);
in ''
  precision lowp float;
  varying vec2 v_texcoord;
  uniform sampler2D tex;

  float distanceSquared(vec3 pixColor, vec3 solarizedColor) {
  	vec3 distanceVector = pixColor - solarizedColor;
  	return dot(distanceVector, distanceVector);
  }

  void main() {
  ${gColorsStr}

  	vec3 pixColor = vec3(texture2D(tex, v_texcoord));
  	int closest = 0;
  	float closestDistanceSquared = distanceSquared(pixColor, solarized[0]);
  	for (int i = 1; i < ${toString lengthOfList}; i++) {
  		float newDistanceSquared = distanceSquared(pixColor, solarized[i]);
  		if (newDistanceSquared < closestDistanceSquared) {
  			closest = i;
  			closestDistanceSquared = newDistanceSquared;
  		}
  	}

  	gl_FragColor = vec4(solarized[closest], 1.);
  }
''
