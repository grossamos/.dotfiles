{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "grossamos";
    userEmail = "email@amosgross.com";
    extraConfig = {
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
    };
  };
}
