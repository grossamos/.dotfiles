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

## Sources
- https://tribaal.io/nicer-mounting-home-in-lxd.html
