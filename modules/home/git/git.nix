{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Vraier";
        email = "jpvdheydt@googlemail.com";
      };

      # Previously 'extraConfig'
      init = {
        defaultBranch = "main";
      };
    };
  };
}
