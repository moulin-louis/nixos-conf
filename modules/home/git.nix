_:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "moulin-louis";
        email = "louis.moulin@outlook.fr";
      };
      init.defaultBranch = "main";
    };
  };
}
