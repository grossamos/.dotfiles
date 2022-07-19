# LXC Containers
## Creating a Container
Follow the arch wiki instructions on setting up lxd.

Add your uid and guid (run `id`) to /etc/subgid and /etc/subgid:
```bash
echo 'root:1000:1' | sudo tee -a /etc/subuid /etc/subgid
```

create a container and map its uid and guid:
```bash
lxc init images:archlinux/current/amd64 test-arch

lxc config set test-arch raw.idmap 'both 1000 1000'
```

mount the directory:
```bash
lxc config device add test-arch some_name_you_want_to_think_of disk source=<abs_path> path=<abs_path>
```

now start the container and everything should be working!

## Configuring a container
Install packages and create a user:
```bash
pacman -S git zsh neovim fzf ripgrep
useradd amos
usermod -aG wheel,audio,video -s /bin/zsh amos

EDITOR=nvim visudo #uncomment line for wheel group without passwd
```

Enter as that user:
```bash
lxc exec clang -- sh -c "cd /home/amos/code/c && su amos"
```

When using zsh with kitty (or alacrity), you might want to copy the contents of ``infocmp -a xterm-kitty`` to ``~/.terminfo/x/xterm-kitty``.

## Binding to wayland
Open config of container: ``lxc config edit <container_name>``

Add the following devices:
```yaml
mygpu:
   type: gpu
Xsocket:
    bind: container
    connect: unix:/tmp/.X11-unix/X0
    listen: unix:/mnt/xorg1/X0
    uid: "1000"
    gid: "1000"
    security.gid: "1000"
    security.uid: "1000"
    mode: "0777"
    type: proxy
```

Make sure you create the actual folder in `/mnt/xorg1` first!

Run the following commands:
```bash
ln -s /mnt/xorg1/X0 /tmp/.X11-unix/X0 # optional
export DISPLAY=:0
```

Now install xorg (usually installing some gui application should be enough).

## Binding to pulse audio
Add the following config:

```yaml
PulseSocket1:
  bind: container
  connect: unix:/run/user/1000/pulse/native
  gid: "1000"
  listen: unix:/mnt/pulse
  mode: "0777"
  security.gid: "1000"
  security.uid: "1000"
  type: proxy
  uid: "1000"
```

And export the pulse server as such:

```bash
export PULSE_SERVER=unix:/mnt/pulse
```

## Binding to camera

Run the following command:

```bash
lxc config device add test-arch video0 unix-char path=/dev/video0
```

## Potential issues
If docker and lxd are installed on the same system, you might need to flush iptables to not face network issues:
```bash
iptables -F FORWARD
iptables -P FORWARD ACCEPT
```

## Sources
- https://tribaal.io/nicer-mounting-home-in-lxd.html
- https://wiki.archlinux.org/title/LXD
- https://github.com/docker/for-linux/issues/103
