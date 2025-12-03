{ ... }:
{
  programs.git = {
    enable = true;
    userName  = "Vraier";
    userEmail = "jpvdheydt@googlemail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}