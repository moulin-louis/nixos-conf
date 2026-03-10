_:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "lomoulin";
        email = "lomoulin@iliad-free.fr";
      };
      init.defaultBranch = "main";
    };
  };
}
