{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    # Fish shell aliases
    functions = {
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
