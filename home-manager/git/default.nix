{pkgs, ...}: {
  programs.git = {
    enable = true;
	settings = {
	  user.name = "grossamos";
	  user.email = "email@amosgross.com";
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
      credential.credentialStore = "cache";
      credential."https://github.com".username = "grossamos";
      pull.rebase = "false";
      init.defaultBranch = "main";
      core.editor = "nvim";
	};
  };
}
