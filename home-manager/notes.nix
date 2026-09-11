{ pkgs, ... }:

let
  syncNotes = pkgs.writeShellApplication {
    name = "sync-notes";

    runtimeInputs = [
      pkgs.git
      pkgs.openssh
    ];

    text = ''
      set -eu

      cd "$HOME/notes"

      git add -A

      # Do nothing if there are no changes.
      if git diff --cached --quiet; then
        exit 0
      fi

      git commit -m "Update notes"
      git push
    '';
  };
in
{
  systemd.user.services.notes-sync = {
    Unit = {
      Description = "Commit and push notes";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${syncNotes}/bin/sync-notes";
    };
  };

  systemd.user.timers.notes-sync = {
    Unit = {
      Description = "Periodically sync notes";
    };

    Timer = {
      # Every day at 03:00.
      OnCalendar = "*-*-* 03:00:00";

      # Run once after login if a scheduled run was missed.
      Persistent = true;

      Unit = "notes-sync.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

