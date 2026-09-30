# home.nix - near-verbatim port of kunchenguid's home.nix, minus the Mac parts.
# nix-darwin doesn't exist on Linux, but home-manager (this file) is the same.
{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = "aker";
  home.homeDirectory = "/home/aker";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    claude-code  # the agent CLI - his repo installs this as a Homebrew cask
    # no nerd font here: fonts render on the WINDOWS side (WezTerm),
    # so Hack Nerd Font lives in the Windows dotfiles repo
    nodejs_26
  ];
  home.sessionVariables.EDITOR = "nvim";
  # user-installed binaries (the herdr installer targets this dir)
  home.sessionPath = [ "$HOME/.local/bin" ];

  # lets `home-manager switch` work as a plain command after the first run
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.git = {
    enable = true;
    settings.user.name = "Kursat Aker";
    settings.user.email = "4950963+kursataker@users.noreply.github.com";
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in the repo, home just points at it.
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/nvim";
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/herdr.toml";
  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/tmux.conf";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
