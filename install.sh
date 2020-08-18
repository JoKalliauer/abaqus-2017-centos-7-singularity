#!/bin/sh


mkdir -p ~/Documents/GitHub
# clone git https://github.com/JoKalliauer/abaqus-centos-7-singularity.git
mkdir -p ~/Documents/GitHub/abaqus-centos-7-singularity
mkdir -p ~/imgs/sing

cd ~/Documents/GitHub/abaqus-centos-7-singularity

rm -f ~/imgs/sing/abaqus-centos-7.img

#For Ubuntu 20.04 you need singularity 3.5.3 or newer

sudo singularity build ~/imgs/sing/abaqus-centos-7.img ~/Documents/GitHub/abaqus-centos-7-singularity/abaqus-centos-7.def 

singularity exec --bind /opt/abaqus /home/jkalliau/imgs/sing/abaqus-centos-7.img vglrun /opt/abaqus/CAE/2019/linux_a64/code/bin/ABQLauncher cae -mesa


#
