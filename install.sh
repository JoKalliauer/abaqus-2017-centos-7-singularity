#!/bin/sh

#sudo dnf install gcc-go golang-bin
rm -r /usr/local/go
wget https://dl.google.com/go/go1.15.1.linux-amd64.tar.gz #https://golang.org/doc/install
sudo tar -C /usr/local -xzf go1.15.1.linux-amd64.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
    

#For Ubuntu 20.04 you need singularity 3.5.3 or newer
#For Fedora 32 you need singularity 3.6.2 or newer
export VERSION=3.6.2 && # adjust this as necessary
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
