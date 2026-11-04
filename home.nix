# home.nix - near-verbatim port of kunchenguid's home.nix, minus the Mac parts.
# nix-darwin doesn't exist on Linux, but home-manager (this file) is the same.
{ config, pkgs, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  # WIN_HOME comes from ~/.config/local-env.sh, which is not in git
  localEnv = ''
    [ -f "$HOME/.config/local-env.sh" ] && . "$HOME/.config/local-env.sh"
    export DOCUMENTS="$WIN_HOME/Documents"
    export PROJECTS="$DOCUMENTS/Projects"
  '';
in

{
  home.username = "aker";
  home.homeDirectory = "/home/aker";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
  # home.packages = [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    claude-code  # the agent CLI - his repo installs this as a Homebrew cask
    pi-coding-agent  # the pi agent CLI (binary: pi)
    omp
    # no nerd font here: fonts render on the WINDOWS side (WezTerm),
    # so Hack Nerd Font lives in the Windows dotfiles repo
    nodejs_26
    pnpm
    bun
    rustup
    gcc       # C linker (cc) that cargo needs
    # herdr
    uv
    flyctl
    # Add tuios here
    # inputs.tuios.packages.${pkgs.system}.default
    # Alternatively, if you want a specific package name from the flake:
    # inputs.tuios.defaultPackage.${pkgs.system}
    glab #gitlab cli
    podman
    tlaplus18
    visidata
  ];
  home.sessionVariables.EDITOR = "nvim";
  # user-installed binaries (the herdr installer targets this dir)
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.npm-global/bin" ];

  # lets `home-manager switch` work as a plain command after the first run
  programs.home-manager.enable = true;

  # machine-specific values (WIN_HOME) live outside the repo
  programs.bash = {
    enable = true;
    initExtra = localEnv;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept
      ${localEnv}
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
