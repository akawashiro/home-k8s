# home-k8s
Construct kubernetes cluster just one command. Just running `run.sh`

- Creates 3 VM using Vagrant.
- Install kubenetes all of them.

## Check dmesg from pod
Run this on nodes.
```bash
sudo sysctl -w kernel.dmesg_restrict=0
```

## TODO
- Network Interface Name

## MEMO
```
vagrant@k8s-workernode1:~$ sudo birdc -s /run/calico/bird.ctl                                                                                                                                                                                                                 BIRD v0.3.3+birdv1.6.8 ready.
bird> show route
0.0.0.0/0          via 10.0.2.2 on eth0 [kernel1 11:49:13] * (10)
10.0.2.2/32        dev eth0 [kernel1 11:49:13] * (10)
10.0.2.3/32        dev eth0 [kernel1 11:49:13] * (10)
10.0.2.0/24        dev eth0 [direct1 11:49:12] * (240)
192.168.11.0/24    dev eth1 [direct1 11:49:12] * (240)
172.16.1.3/32      dev caliefadf1cbccc [kernel1 11:49:15] * (10)
172.16.1.2/32      dev calie676ab916a5 [kernel1 11:49:13] * (10)
172.16.1.1/32      dev califfc71c11cc1 [kernel1 11:49:13] * (10)
172.16.0.0/26      via 192.168.11.73 on eth1 [Mesh_192_168_11_73 11:49:17] * (100/0) [i]
                   via 192.168.11.73 on eth1 [Mesh_192_168_11_73 11:49:17] (100/0) [i]
                   via 192.168.11.73 on eth1 [kernel1 11:49:13] (10)
172.16.1.0/26      blackhole [static1 11:49:12] * (200)
                   blackhole [kernel1 11:49:13] (10)
172.16.1.0/32      dev vxlan.calico [direct1 11:49:12] * (240)
172.16.2.64/26     via 192.168.11.71 on eth1 [Mesh_192_168_11_73 11:49:17 from 192.168.11.73] * (100/0) [i]
                   via 192.168.11.71 on eth1 [kernel1 11:49:12] (10)
172.16.1.5/32      dev cali1515d418588 [kernel1 12:05:41] * (10)
172.16.1.4/32      dev caliea619e8f997 [kernel1 11:49:16] * (10)
bird> show protocols
name     proto    table    state  since       info
static1  Static   master   up     11:49:12
kernel1  Kernel   master   up     11:49:12
device1  Device   master   up     11:49:12
direct1  Direct   master   up     11:49:12
Mesh_192_168_11_73 BGP      master   up     11:49:17    Established
Mesh_192_168_11_71 BGP      master   start  11:49:12    Active        Socket: Connection refused
```
