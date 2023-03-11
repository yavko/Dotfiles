{
  pkgs,
  config,
  ...
}: {
  programs.mpv = {
    enable = true;
    config = {
      sub-auto = "fuzzy";
      sub-bold = "yes";

      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";

      osc = false;
      border = false;

      slang = "enUS";

      #ytdl-raw-options="sub-format=srt";
      #ytdl-raw-options="add-metadata=";
      #ytdl-raw-options="embed-thumbnail=";
      #ytdl-raw-options="external-downloader=aria2c";
      #ytdl-raw-options="external-downloader-args=-c -j 3 -x 3 -s 3 -k 1M";

      hwdec = "vaapi";
    };
    scripts = with pkgs.mpvScripts; [mpris thumbnail];
  };
}
