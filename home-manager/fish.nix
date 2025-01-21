{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    # Fish shell aliases
    functions = {
      fish_prompt = {
        body = ''
    # Check if in nix shell
    set -l nix_part ""
    if test -n "$IN_NIX_SHELL"
        set nix_part " [nix]"
    end

    # Get git branch
    set -l git_part ""
    if command -sq git
        and test -d .git; or git rev-parse --git-dir >/dev/null 2>/dev/null
        set -l git_branch (git branch --show-current 2>/dev/null)
        if test $status -eq 0
            set git_part " ($git_branch)"
        end
    end

    # Build prompt
    echo -n (set_color green)"$(whoami)"(set_color normal)
    echo -n "@$(hostname -s) "
    echo -n (set_color green)(prompt_pwd)(set_color normal)
    echo -n "$git_part"
    echo -n (set_color cyan)"$nix_part"
    echo -n (set_color normal)"> "
        '';
      };
      rebuild = {
        body = ''
          switch (uname)
              case Darwin
                  darwin-rebuild switch --flake $HOME/nixos-conf/#MacBook-Pro-de-Louis
              case Linux
                  sudo nixos-rebuild switch --flake $HOME/nixos-conf/#(hostname)
              case '*'
                  echo "Unsupported operating system"
                  return 1
          end
        '';
      };
    };
    shellAliases = {
      # Common commands
      gcl = "git clone";
      ls = "eza";
      cat = "bat";
      cd = "z";
    };
    interactiveShellInit = ''
      set fish_greeting
      set -g nvm_default_version lts
    '';
    shellInit = ''
      if test -f $HOME/.asdf/asdf.fish
        source $HOME/.asdf/asdf.fish
      end
      # Source Cargo environment
      if test -f "$HOME/.cargo/env.fish"
        source "$HOME/.cargo/env.fish"
      end
      zoxide init fish | source
    '';
    plugins = [
      {
        name = "fisher";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "fisher";
          rev = "4.4.5";
          sha256 = "00zxfv1jns3001p2jhrk41vqcsd35xab8mf63fl5xg087hr0nbsl";
        };
      }
    ];
  };
}
