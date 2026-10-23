{ pkgs, ... }:

let
  dockerfile = pkgs.writeText "cisco-vpn.Dockerfile" ''
    FROM fedora:41
    RUN dnf install -y iproute iptables-nft procps-ng gtk3 webkit2gtk4.1 dbus-x11 libXtst mesa-dri-drivers adwaita-icon-theme google-noto-sans-fonts && dnf clean all
    COPY xdg-open /usr/bin/xdg-open
    COPY xdg-open /usr/local/bin/xdg-open
    COPY cisco.rpm /tmp/cisco.rpm
    RUN dnf install -y /tmp/cisco.rpm && dnf clean all && rm /tmp/cisco.rpm
    CMD ["/opt/cisco/secureclient/bin/vpnagentd", "-execv_instance"]
  '';

  # Stand-in for xdg-open inside the container: hands URLs to the host, which opens them.
  fakeXdgOpen = pkgs.writeScript "xdg-open" ''
    #!/bin/sh
    echo "$1" >> /run/browser/urls
  '';

  vpn = pkgs.writeShellApplication {
    name = "vpn";

    # Spurious "arithmetic" warning on plain name=value assignments.
    excludeShellChecks = [ "SC2100" ];

    runtimeInputs = [
      pkgs.docker
      pkgs.coreutils
      pkgs.xdg-utils
      pkgs.xhost
    ];

    text = ''
      # sudo and resolvconf live outside the pinned PATH on NixOS.
      export PATH="$PATH:/run/wrappers/bin:/run/current-system/sw/bin"

      name=cisco-vpn
      image=cisco-secure-client
      cisco=/opt/cisco/secureclient/bin/vpn

      if [ "''${1:-}" = "--rebuild" ]; then
        docker image rm -f "$image" >/dev/null 2>&1 || true
        shift
      fi

      host="''${1:-''${VPN_HOST:-vpn.uni.lu/MFA}}"

      browserdir="''${XDG_RUNTIME_DIR:-/tmp}/cisco-vpn-browser"
      mkdir -p "$browserdir"
      : > "$browserdir/urls"

      cleanup() {
        trap - EXIT INT TERM
        echo
        echo "Tearing down VPN..."
        docker exec "$name" "$cisco" disconnect >/dev/null 2>&1 || true
        # Removing the container kills vpnagentd, which removes the tun device,
        # its routes and any firewall state it added.
        docker rm -f "$name" >/dev/null 2>&1 || true
        [ -z "''${opener:-}" ] || kill "$opener" 2>/dev/null || true
        rm -rf "$browserdir"
        xhost -SI:localuser:root >/dev/null 2>&1 || true
        sudo resolvconf -d "$name" >/dev/null 2>&1 || true
        echo "Networking restored."
      }

      if docker inspect "$name" >/dev/null 2>&1; then
        echo "Removing stale $name container from a previous run"
        docker rm -f "$name" >/dev/null
      fi

      if ! docker image inspect "$image" >/dev/null 2>&1; then
        rpms=("$HOME"/.vpn/cisco-secure-client-vpn-*.rpm)
        rpm="''${rpms[-1]}"
        echo "Building $image from $rpm"
        ctx=$(mktemp -d)
        cp "$rpm" "$ctx/cisco.rpm"
        cp ${fakeXdgOpen} "$ctx/xdg-open"
        docker build -t "$image" -f ${dockerfile} "$ctx"
        rm -rf "$ctx"
      fi

      trap cleanup EXIT INT TERM

      # The CLI can't do SAML/MFA logins, so the GUI runs in the container and
      # shows up on the host's X server (XWayland).
      # Let the container's root user talk to the X server (revoked on exit).
      xhost +SI:localuser:root
      gui=(-e "DISPLAY=''${DISPLAY:-:0}" -v /tmp/.X11-unix:/tmp/.X11-unix)
      if [ -n "''${XAUTHORITY:-}" ]; then
        gui+=(-e XAUTHORITY=/tmp/.Xauthority -v "$XAUTHORITY:/tmp/.Xauthority:ro")
      fi

      # Host networking so the tunnel, routes and DNS land on the host itself.
      docker run -d --name "$name" \
        --network host \
        --cap-add NET_ADMIN \
        --device /dev/net/tun \
        -v "$browserdir:/run/browser" \
        "''${gui[@]}" \
        "$image" >/dev/null

      # Open login URLs the container asks for in the host's browser. The SAML
      # callback goes to localhost, which is shared via host networking.
      tail -n0 -F "$browserdir/urls" | while read -r url; do
        xdg-open "$url" >/dev/null 2>&1 &
      done &
      opener=$!

      echo -n "Waiting for vpnagentd"
      for _ in $(seq 1 30); do
        if docker exec "$name" "$cisco" state >/dev/null 2>&1; then
          break
        fi
        echo -n "."
        sleep 1
      done
      echo

      docker exec -d "$name" /opt/cisco/secureclient/bin/vpnui
      echo "Cisco Secure Client window opened: connect to $host and finish the MFA login."

      echo -n "Waiting for the tunnel"
      until docker exec "$name" "$cisco" state 2>/dev/null | grep -q "state: Connected"; do
        if ! docker inspect -f '{{.State.Running}}' "$name" 2>/dev/null | grep -q true; then
          echo "VPN container exited." >&2
          exit 1
        fi
        echo -n "."
        sleep 2
      done
      echo

      # The client rewrites resolv.conf inside the container; hand it to the host resolver.
      docker exec "$name" cat /etc/resolv.conf | sudo resolvconf -a "$name" || \
        echo "warning: could not apply VPN DNS to the host" >&2

      echo "VPN up. Press Ctrl-C to disconnect and restore normal networking."
      while docker inspect -f '{{.State.Running}}' "$name" 2>/dev/null | grep -q true; do
        sleep 2
      done
      echo "VPN container exited."
    '';
  };
in
{
  home.packages = [ vpn ];
}
