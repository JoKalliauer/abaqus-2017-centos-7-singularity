#!/bin/sh

if [ -f "/etc/debian_version" ]; then
 sudo apt-get update && sudo apt-get install -y build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup
fi
if [ "$(grep -Ei 'fedora|redhat' /etc/*release)" ]; then
 sudo dnf update && sudo dnf install -y squashfs-tools wget pkg-config git cryptsetup gcc-go golang-bin
fi

rm -r /usr/local/go
wget https://dl.google.com/go/go1.15.1.linux-amd64.tar.gz #https://golang.org/doc/install
sudo tar -C /usr/local -xzf go1.15.1.linux-amd64.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
    

#For Ubuntu 20.04 you need singularity 3.5.3 or newer
#For Fedora 32 you need singularity 3.6.2 or newer
wget https://raw.githubusercontent.com/hpcng/singularity/master/CHANGELOG.md
pid=$(grep "^# v" ./CHANGELOG.md)
export VERSION=${pid:3:5} # adjust this as necessary eg export VERSION=3.6.2
wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz &&     tar -xzf singularity-${VERSION}.tar.gz
cd singularity/
./mconfig
make -C ./builddir
sudo make -C ./builddir install
which singularity
singularity --version
cd ..


mkdir -p ~/imgs/sing
rm -f ~/imgs/sing/abaqus-centos-7.img
git clone https://github.com/JoKalliauer/abaqus-centos-7-singularity.git
cd ./abaqus-centos-7-singularity
sudo singularity build ~/imgs/sing/abaqus-centos-7.img ./abaqus-centos-7.def 

singularity exec --bind /opt/abaqus ~/imgs/sing/abaqus-centos-7.img vglrun /opt/abaqus/CAE/2019/linux_a64/code/bin/ABQLauncher cae -mesa


#
