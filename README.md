# Singularity container for Abaqus on Ubuntu 20.04

Abaqus works well under Centos but is much less likely to work well under a bleeding edge distro like Arch, so let's run Abaqus within a Singularity container,
setting things up in such a way that we can run Abaqus CAE with mesa.

## Preparations

1. Abaqus is copied to /opt/abaqus/ (or anything else).
2. Make sure you have Singularity 3.6.2 (or newer) installed. (On newer OS you might need a newer singularity-version.)

```bash
#sudo dnf install gcc-go golang-bin
rm -r /usr/local/go
wget https://dl.google.com/go/go1.15.1.linux-amd64.tar.gz #https://golang.org/doc/install
sudo tar -C /usr/local -xzf go1.15.1.linux-amd64.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
export VERSION=3.6.2 && # adjust this as necessary
tar -xzf singularity-${VERSION}.tar.gz
cd singularity/
./mconfig &&     make -C ./builddir &&     sudo make -C ./builddir install
which singularity
singularity --version
cd ..
```

## Building the singularity image

```bash
mkdir -p ~/imgs/sing
rm -f ~/imgs/sing/abaqus-centos-7.img
git clone https://github.com/JoKalliauer/abaqus-centos-7-singularity.git
cd ./abaqus-centos-7-singularity
sudo singularity build ~/imgs/sing/abaqus-centos-7.img ./abaqus-centos-7.def 
```

## Running the container

To run Abaqus CAE without hardware-accelerated graphics:

```bash
singularity exec --bind /opt/abaqus ~/imgs/sing/abaqus-centos-7.img /opt/abaqus/CAE/2019/linux_a64/code/bin/ABQLauncher cae -mesa
```
