{
  config,
  pkgs,
  lib,
  user,
  ...
}: {
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      visualizerSupport = true;
    };
    mpdMusicDir = "/home/${user}/Music";
    settings = {
      mpd_crossfade_time = 2;

      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer";
      visualizer_in_stereo = "yes";
      visualizer_fps = 60;
      visualizer_type = "spectrum";
      visualizer_look = "󰝤▐";
      visualizer_color = "magenta";
      visualizer_spectrum_smooth_look = "yes";
      # visualizer_spectrum_dft_size = 2;

      connected_message_on_startup = "no";
      cyclic_scrolling = "yes";
      mouse_support = "yes";
      mouse_list_scroll_whole_page = "yes";
      lines_scrolled = 1;
      message_delay_time = 1;
      playlist_shorten_total_times = "yes";
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";
      playlist_editor_display_mode = "columns";
      autocenter_mode = "yes";
      centered_cursor = "yes";
      user_interface = "alternative";
      alternative_header_second_line_format = "{{ ($4%a$9) }}|{%D}";
      follow_now_playing_lyrics = "yes";
      locked_screen_width_part = 50;
      ask_for_locked_screen_width_part = "yes";
      display_bitrate = "no";
      external_editor = "vim";
      main_window_color = "default";
      startup_screen = "playlist";
      screen_switcher_mode = "playlist, visualizer, browser";

      progressbar_look = "━━━";
      progressbar_elapsed_color = 5;
      progressbar_color = "black";

      header_visibility = "no";
      statusbar_visibility = "yes";
      titles_visibility = "yes";
      enable_window_title = "no";

      statusbar_color = "white";
      color1 = "white";
      color2 = "blue";

      now_playing_prefix = "$b$2$7 ";
      now_playing_suffix = "  $/b$8";
      current_item_prefix = "$b$7$/b$3 ";
      current_item_suffix = "  $8";

      song_columns_list_format = "(50)[]{t}";

      song_list_format = " {%t $R   $8%a$8}|{%f $R   $8%l$8} $8";

      song_status_format = "{$6 %t }";
    };
  };
}

