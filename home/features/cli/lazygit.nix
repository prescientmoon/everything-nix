# TODO: make this wrapper-based
{
  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
      disableStartupPopups = true;
    };
  };
}
