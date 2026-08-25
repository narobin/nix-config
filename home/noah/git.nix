{
  pkgs,
  config,
  ...
}:
let
  sshSignPath =
    if pkgs.stdenv.isDarwin then
      "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      "${pkgs._1password-gui}/share/1password/op-ssh-sign";
in
{
  home.file.".ssh/git-signing.pub".source = ./resources/git-signing.pub;

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Noah Robinson";
        email = "noah@narobin.com";
        signingkey = "${config.home.homeDirectory}/.ssh/git-signing.pub";
      };

      gpg = {
        format = "ssh";
        ssh = {
          program = sshSignPath;
        };
      };

      core = {
        fsmonitor = true;
        untrackedCache = true;
      };

      color = {
        ui = "auto";
      };

      column = {
        ui = "auto";
      };

      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };

      pull = {
        rebase = true;
      };

      fetch = {
        prune = true;
        pruneTags = true;
      };

      rebase = {
        autosquash = true;
        autostash = true;
        updateRefs = true;
        missingCommitsCheck = "error";
      };

      merge = {
        conflictStyle = "zdiff3";
        keepBackup = false;
      };

      diff = {
        algorithm = "histogram";
        renames = true;
        colorMoved = "plain";
        mnemonicPrefix = true;
      };

      grep = {
        patternType = "perl";
      };

      commit = {
        verbose = true;
        gpgsign = true;
      };

      rerere = {
        enabled = true;
        autoupdate = true;
      };

      help = {
        autocorrect = "prompt";
      };

      branch = {
        sort = "-committerdate";
      };

      tag = {
        sort = "version:refname";
      };

      log = {
        date = "iso";
      };

      feature = {
        experimental = true;
      };

      transfer = {
        fsckObjects = true;
      };

      url = {
        "git@github.com:".insteadOf = "https://github.com";
      };
    };
  };
}
