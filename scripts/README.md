## Scripts in Host

Dependencies:

```
build-essential pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev libfdt-dev ninja-build libcap-ng-dev libattr1-dev
```

Run scripts 10~50 in order.

Connecting gdb to QEMU:

```
(gdb) target remote /PATH/TO/REPO/run/gdb-socket
# make some breakpoints
(gdb) c
```

The guest system should be running now. Connect to it with:

```
ssh -p 47183 ubuntu@127.0.0.1
```

The default password should be `ubuntu`.

## Scripts in Guest

First, temporarily mount the shared folder with:

```
mkdir -p /mnt/DistroSim
mount -t 9p -o trans=virtio,version=9p2000.L,rw distrosim /mnt/DistroSim
```

Run scripts 50 to configure the guest system, including installing dependencies and setting up the environment. After this step, the guest system is automatically powered off.

The guest system can be accessed with root user without password:

```
ssh -p 47183 root@127.0.0.1
```

Run script 60 to build and install the kernel module.

The kernel module will be loaded automatically when the guest system boots, so script 70 is not needed unless the module is not loaded correctly.

Run script 80 to run create and load qdma queues.

Run script 90 to execute the test program. Script 90 accepts arguments `-s` for setting size in bytes, and `-c` for setting number of iterations.
