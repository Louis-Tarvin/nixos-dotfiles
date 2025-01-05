{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "louist";
  home.homeDirectory = "/home/louist";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # cli tools
    fastfetch # better fetch
    git
    eza # better ls
    dust # better du
    zenith # better htop
    ripgrep
    fzf
    # system
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    hyprpolkitagent # Popup for app authentication
    phinger-cursors
    nwg-look # GTK3 settings editor
    arc-theme
    arc-icon-theme
    lxmenu-data # for pcmanfm
    feh # image viewer
    # wallpaper
    swww
    waypaper
    # apps
    firefox
    pcmanfm
    alacritty
    obsidian
    spotify
    aseprite
    # dev
    clang
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer
    mold
    nodejs_23
  ];

  # Non-free packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "obsidian"
      "spotify"
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/alacritty/alacritty.toml".text = ''
      [env]
      TERM = "xterm-256color"
      [colors.primary]
      background = '#1d1f21'
      foreground = '#c5c8c6'
      
      [colors.cursor]
      text = '#1d1f21'
      cursor = '#ffffff'
      
      # Normal colors
      [colors.normal]
      black   = '#1d1f21'
      red     = '#cc6666'
      green   = '#b5bd68'
      yellow  = '#e6c547'
      blue    = '#81a2be'
      magenta = '#b294bb'
      cyan    = '#70c0ba'
      white   = '#373b41'
      
      # Bright colors
      [colors.bright]
      black   = '#666666'
      red     = '#ff3334'
      green   = '#9ec400'
      yellow  = '#f0c674'
      blue    = '#81a2be'
      magenta = '#b77ee0'
      cyan    = '#54ced6'
      white   = '#282a2e'
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/louist/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      l = "eza";
      ls = "eza";
      ll = "eza -l";
      lll = "eza -la";
      m = "mold -run cargo";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
	    "git"
	    "rust"
	    "colored-man-pages"
	    "z"
            "tmux"
      ];
      theme = "gnzh";
    };
    initExtra = ''
      bindkey '^n' autosuggest-accept
      if [ "$TMUX" = "" ]; then tmux new; fi
      fastfetch
    '';
  };

  # tmux
  programs.tmux = {
    enable = true;
    mouse = true;
    shortcut = "a";
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
    terminal = "screen-256color";
    extraConfig = ''
      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      
      bind -n M-. next-window
      bind -n M-, previous-window
      
      unbind '"'
      unbind %
      
      # split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # open in same directory
      bind v new-window -c "#{pane_current_path}"

      # Force true colors
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      #  modes
      setw -g clock-mode-colour yellow
      setw -g mode-style 'fg=black bg=yellow bold'
      
      # panes
      set -g pane-border-style 'fg=white'
      set -g pane-active-border-style 'fg=green'
      
      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-keys vi
      set -g status-style 'bg=black fg=white'
      set -g status-right-length 50
      set -g status-left-length 20
      set -g status-left ''\'''\'
      set -g status-right ''\'''\'
      
      setw -g window-status-current-style 'fg=brightwhite bg=blue bold'
      setw -g window-status-current-format ' #I:#W#F '
      
      setw -g window-status-style 'fg=blue bg=black'
      setw -g window-status-format ' #I:#W#F '
      
      setw -g window-status-bell-style 'fg=yellow bg=green bold'
      
      # messages
      #set -g message-style 'fg=white bg=black bold'
      #set -g message-command-style 'fg=white bg=black bold'
    '';
  };

  # Fonts
  fonts.fontconfig.enable = true;

  # Hyprland
  programs.kitty.enable = true;
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = "HDMI-A-1, 2560x1440@144, 0x0, 1";
    "$mod" = "SUPER";
    bindm = [ # Mouse binds
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];
    bind =
    [
      # Compositor commands
      "$mod, Q, killactive,"
      "$mod, F, fullscreen,"
      "$mod SHIFT, F, togglefloating,"
      "$mod, G, togglegroup,"

      # Launch programs
      "$mod, T, exec, alacritty"
      "$mod, Return, exec, alacritty"
      "$mod SHIFT, Return, exec, firefox"

      # Move/swap focus
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod SHIFT, left, swapwindow, l"
      "$mod SHIFT, right, swapwindow, r"
      "$mod SHIFT, up, swapwindow, u"
      "$mod SHIFT, down, swapwindow, d"
      "Control_L&ALT, right, workspace, e+1"
      "Control_L&ALT, left, workspace, e-1"

      # Scratchpad
      "$mod, U, togglespecialworkspace,"

      # Rofi
      "$mod, Space, exec, rofi -show drun"
      "$mod, P, exec, ~/scripts/powermenu"
    ]
    ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
    bindl = [
      # media controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      # volume
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    input = {
      kb_layout = "gb";
      repeat_rate = 23;
      repeat_delay = 350;
    };
    general = {
      border_size = 2;
      "col.active_border" = "rgba(88888888)";
      "col.inactive_border" = "rgba(00000088)";
      resize_on_border = true;
    };
    decoration = {
      rounding = 10;
    };
    cursor = {
      inactive_timeout = 10;
    };
    windowrulev2 = [
      "float, class:floating"
    ];
    animation = [
      "specialWorkspace, 1 2, default, slidevert"
    ];
    debug = {
      disable_logs = false;
    };
  };
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = hyprctl setcursor phinger-cursors-light 32
    exec-once = swww-daemon
    exec-once = waybar
    exec-once = [workspace special silent] alacritty --class floating
  '';

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = [];
        modules-right = ["disk" "cpu" "memory" "pulseaudio/slider" "network" "clock" "tray" "custom/power"];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "";
            active = "";
          };
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };

        disk = {
          format = "  {free} ";
          interval = 60;
        };
       
        cpu = {
          format = "  {usage}% ";
          tooltip = false;
          interval = 5;
        };

        memory = {
          format = "  {percentage}% ";
          tooltip = false;
          interval = 5;
        };

        pulseaudio = {
          format = " {icon} ";
          format-muted = "";
          format-icons = ["󰕿" "󰖀" "󰕾"];
          tooltip = true;
          tooltip-format = "{volume}%";
        };

        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        network = {
          format-wifi = " ";
          format-disconnected = "睊";
          format-ethernet = "󰈀";
          tooltip = true;
          tooltip-format = "{signalStrength}%";
          tooltip-format-ethernet = "{ipaddr}";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          tooltip = true;
          tooltip-format = "{percent}%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "";
          format-plugged = "";
          format-icons = ["" "" "" "" "" "" "" "" "" "" "" ""];
          tooltip = true;
          tooltip-format = "{capacity}%";
        };

        "custom/power" = {
          tooltip = false;
          on-click = "~/scripts/powermenu";
          format = "⏻";
        };

        clock = {
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = ''󰃭 {:%d/%m/%Y}'';
          format = '' {:%H:%M}'';
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };
      };
    };

    style = builtins.readFile ./waybar/style.css;
  };
  xdg.configFile."waybar/tomorrow-night.css".text = builtins.readFile ./waybar/tomorrow-night.css;
  home.file."./scripts/powermenu" = {
    text = builtins.readFile ./waybar/powermenu;
    executable = true;
  };

  # Git
  programs.git = {
    enable = true;
    userName = "Louis Tarvin";
    userEmail = "me@louistarvin.uk";
    aliases = {
      lg = "log --graph --all --oneline --decorate --color";
    };
  };

  # Vim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    #package = pkgs.neovim;
    coc.enable = false;

    plugins = [
      #  pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];

    extraPackages = [
      pkgs.lua-language-server
      pkgs.tree-sitter
      pkgs.gcc
      pkgs.fzf
    ];

    #extraConfig = ''
    #  :luafile ~/.config/nvim/init.lua
    #'';
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };

  # Rofi
  programs.rofi = {
    enable = true;
    theme = ./rofi/colorful-8.rasi;
  };
  xdg.configFile."rofi/powermenu.rasi".text = builtins.readFile ./rofi/powermenu.rasi;
}
