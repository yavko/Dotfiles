num: let
  # Credit to https://www.asciiart.eu/animals/cats
  cat = ''
         _._     _,-'""`-._
    (,-.`._,'(       |\`-/|
        `-.-' \ )-`( , o o)
              `-    \`_`"'-

  '';
  # Credit to https://github.com/andreasgrafen/pfetch-with-kitties
  cat2 = ''
     /| ､
    (°､ ｡ 7
     |､  ~ヽ
     じしf_,)〳

  '';
in
  if num == 0
  then cat
  else cat2
