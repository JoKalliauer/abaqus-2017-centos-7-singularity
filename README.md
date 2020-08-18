# Singularity container for Abaqus on Ubuntu 20.04

Abaqus works well under Centos but is much less likely to work well under a bleeding edge distro like Arch, so let's run Abaqus within a Singularity container,
setting things up in such a way that we can run Abaqus CAE with mesa.

## Preparations

1. Abaqus is copied to /opt/abaqus/ (or anything else).
2. Make sure you have Singularity 3.5.3 (or newer) installed. (I used 3.6)

```bash
go get -d github.com/sylabs/singularity
export VERSION=3.6.0 && # adjust this as necessary     wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz &&     tar -xzf singularity-${VERSION}.tar.gz &&     cd singularity
cd ..
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
clone git https://github.com/JoKalliauer/abaqus-centos-7-singularity.git
cd ./abaqus-centos-7-singularity
sudo singularity build ~/imgs/sing/abaqus-centos-7.img ./abaqus-centos-7.def 
```

## Running the container

To run Abaqus CAE without hardware-accelerated graphics:

```bash
singularity exec --bind /opt/abaqus /home/jkalliau/imgs/sing/abaqus-centos-7.img vglrun /opt/abaqus/CAE/2019/linux_a64/code/bin/ABQLauncher cae -mesa
```
