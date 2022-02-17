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
Waylandsocket:
    bind: container
    connect: unix:/run/user/1000/wayland-0
    listen: unix:/mnt/wayland1/wayland-0
    uid: "1000"
    gid: "1000"
    security.gid: "1000"
    security.uid: "1000"
    mode: "0777"
    type: proxy
```

Run the script `init_wayland.sh` in the container.

Adjust display numbers, etc. accordingly:
```bash
echo "export XDG_RUNTIME_DIR=/run/user/1000" >> ~/.profile
echo "export WAYLAND_DISPLAY=wayland-0" >> ~/.profile
echo "export QT_QPA_PLATFORM=wayland" >> ~/.profile
```

Then reload .profile with:
```bash
. .profile
```

When binding to home directory, don't forget t delete `.profile` before rebooting!

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
