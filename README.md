# Singularity container for Abaqus on Ubuntu 20.04

Abaqus works well under Centos but is much less likely to work well under a bleeding edge distro like Arch, so let's run Abaqus within a Singularity container,
setting things up in such a way that we can run Abaqus CAE with mesa.

## Preparations

1. Abaqus is copied to /opt/abaqus/ (or anything else).
2. Make sure you have Singularity 3.6.2 (or newer) installed. (On newer OS you might need a newer singularity-version.)
A installguide can be found at https://github.com/hpcng/singularity/blob/master/INSTALL.md

```bash
if [ -f "/etc/debian_version" ]; then
 sudo apt-get update && sudo apt-get install -y build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup
fi
if [ "$(grep -Ei 'fedora|redhat' /etc/*release)" ]; then
 sudo yum groupinstall -y 'Development Tools'
 sudo yum install -y golang libseccomp-devel squashfs-tools cryptsetup squashfs-tools wget pkg-config git gcc-go golang-bin
fi
rm -r /usr/local/go
export VERSION=1.15.1 #https://golang.org/doc/install
export OS=linux ARCH=amd64  # change this as you need
wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz && \
sudo tar -C /usr/local -xzf /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz
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

## Remove

### Remove Go
If you do not remove old version, newer versions won't work properly, so removing old versions seems to be necessary.
```bash
rm -r /usr/local/go
```

### Remove Singulartity
If you do not remove old version, it might happen that the old version might still be the default version.
```bash
sudo rm -rf \
     /usr/local/libexec/singularity \
     /usr/local/var/singularity \
     /usr/local/etc/singularity \
     /usr/local/bin/singularity \
     /usr/local/bin/run-singularity \
     /usr/local/etc/bash_completion.d/singularity
```

### Remove the Container
Generally there is no need to remove old containers, except you want to save 157 MB space.
```bash
rm ~/imgs/sing/abaqus-centos-7.img
```
