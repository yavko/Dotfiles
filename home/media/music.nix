{
  pkgs,
  config,
  inputs,
  ...
}: let
  h = config.home.homeDirectory;
  d = config.xdg.dataHome;
  music = "${h}/Music";
  /*
    mxlrc = with pkgs.python39Packages; let
  	tiny = buildPythonPackage rec {
   		pname = "tinytag";
   		version = "1.8.1";

   		src = fetchPypi {
     		inherit pname version;
     		sha256 = "363ab3107831a5598b68aaa061aba915fb1c7b4254d770232e65d5db8487636d";
   		};
  	};
  in buildPythonPackage rec {
  	name = "mxlrc";
  	version = "1.2.2";
  	propegatedBuildInputs = [tiny];
  	src = pkgs.fetchFromGitHub {
  		owner = "fashni";
  		repo = "MxLRC";
  		rev = "v${version}";
  		sha256 = "sha256-cTekPt16gRu/qwQj/Ia9SgTTHZ8dBzS9aKC92foqPY8=";
  	};
  };
  */
in {
  home.packages = with pkgs; [
    tagger
    downonspot
    picard
    lame
    #(inputs.self.packages.${pkgs.hostPlatform.system}.open-utau)
    #mxlrc
  ];
  xdg.userDirs.music = "${h}/Music";
  services = {
    mpd = {
      enable = true;
      musicDirectory = music;
      playlistDirectory = "${music}/playlists";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
        audio_output {
          type "fifo"
          name "My fifo pipe"
          path "/tmp/mpd.fifo"
        }
        replaygain "track"
        replaygain_limit "no"
      '';
    };
    mpdris2 = {
      enable = true;
    };
  };
  programs = {
    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {
        visualizerSupport = true;
        taglibSupport = true;
        clockSupport = true;
        outputsSupport = true;
      };
    };
    beets = {
      enable = true;
      settings = {
        directory = music;
        library = "${d}/beets/library.db";
        plugins = [
          "mpdupdate"
          "lyrics"
          "thumbnails"
          "fetchart"
          "embedart"
          # DEPRECATED "acousticbrainz"
          "chroma"
          "fromfilename"
          "lastgenre"
        ];
        import = {
          move = true;
          write = true;
        };
        mpd = {
          host = "localhost";
          port = 6600;
        };
        lyrics = {
          auto = true;
        };
        thumbnails.auto = true;
        fetchart.auto = true;
        embedart = {
          auto = true;
          remove_art_file = true;
        };
        acousticbrainz.auto = true;
        chroma.auto = true;
      };
    };
  };
}
