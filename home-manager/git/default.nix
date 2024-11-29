{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "grossamos";
    userEmail = "email@amosgross.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
      credential.credentialStore = "cache";
      credential."https://github.com".username = "grossamos";
      pull.rebase = "false";
      init.defaultBranch = "main";
      core.editor = "lvim";
    };
  };
}
