# Vagrant Environment for Kubernetes Cluster Lab

This project provides a **Vagrant-based virtual machine environment** for building a **Kubernetes cluster lab using kubeadm**.

The environment creates multiple VMs that can be used as:

* 1 Control Plane node
* Multiple Worker nodes

The virtual machines are provisioned using **Vagrant with the KVM/libvirt provider**.

---

# Cluster Topology

| Hostname     | Role                     |
| ------------ | ------------------------ |
| controlplane | Kubernetes Control Plane |
| node01       | Worker Node              |
| node02       | Worker Node              |

---

# Prerequisites

## Install Vagrant

```bash
sudo apt update
sudo apt install -y vagrant
```

---

## Install virtualization packages

This project uses **KVM + libvirt** as the virtualization provider.

```bash
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager
```

Install the Vagrant plugin for libvirt:

```bash
vagrant plugin install vagrant-libvirt
```

---

# Create libvirt Storage Pool

Create a directory for storing Vagrant VM disks.

```bash
sudo mkdir -p /var/lib/libvirt/vagrant
sudo chown libvirt-qemu:kvm /var/lib/libvirt/vagrant
sudo chmod 775 /var/lib/libvirt/vagrant
```

Define the storage pool:

```bash
sudo virsh pool-define-as vagrant dir - - - - "/var/lib/libvirt/vagrant"
```

Enable autostart:

```bash
sudo virsh pool-autostart vagrant
```

Start the pool:

```bash
sudo virsh pool-start vagrant
```

Verify the pool:

```bash
sudo virsh pool-list --all
```

Expected output:

```
Name     State    Autostart
---------------------------
vagrant  active   yes
```

---

# Start the Virtual Machines

From the project directory run:

```bash
vagrant up --provider=libvirt
```

Vagrant will automatically create:

* 1 Control Plane VM
* 2 Worker Node VMs

---

# Project Structure

```
k8s-cluster/
├── Vagrantfile
├── disable-swap.sh
├── setup-hosts.sh
├── update-dns.sh
├── ssh.sh
├── vimrc
└── README.md
```

---

# Accessing the VMs

You can SSH into any VM using:

```bash
vagrant ssh controlplane
```

or

```bash
vagrant ssh node01
```

---

# Destroy the Environment

To remove all virtual machines:

```bash
vagrant destroy -f
```

