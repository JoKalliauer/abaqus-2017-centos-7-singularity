# Update2020: Abaqus2020HF5 on Ubuntu20.04/Fedora32 without container
In September 2020 Abaqus released a HotFix5: `Abaqus 2020 HF5 (2020 FP.CFA.2038)`  for Abaqus 2020 that solves the terminating issue, it can be downloaded from  from https://www.3ds.com/support/download/ (login required).

The file needed should be `2020.FP.CFA.2038.Part_SIMULIA_EstPrd.Linux64.tar` with 2GB.

For more infos check [https://github.com/willfurnass/abaqus-2017-centos-7-singularity/issues/5#issue-713025844](https://github.com/willfurnass/abaqus-2017-centos-7-singularity/issues/5#issue-713025844)

Meantime Abaqus2021 got released, I assume the this version can be installed and used without any hotfix.

# Singularity container for Abaqus on Ubuntu20.04/Fedora32

Abaqus works well under CentOS but is much less likely to work well under a bleeding edge distro like Arch/Ubuntu/Fedora, so let's run Abaqus within a Singularity container,
setting things up in such a way that we can run Abaqus CAE with mesa.

## install Singularity 3.6.2 (or newer)
Make sure you have Singularity 3.6.2 (or newer) installed. (On newer OS you might need a newer singularity-version.)
A installguide can be found at https://github.com/hpcng/singularity/blob/master/INSTALL.md

```bash
if [ -f "/etc/debian_version" ]; then
 sudo apt-get update && sudo apt-get install -y build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup
fi
if [ "$(grep -Ei 'fedora|redhat' /etc/*release)" ]; then
 sudo yum groupinstall -y 'Development Tools'
 sudo yum install -y golang libseccomp-devel squashfs-tools cryptsetup squashfs-tools wget pkg-config git gcc-go golang-bin ksh
fi
rm -r /usr/local/go
export VERSION=1.15.1 #https://golang.org/doc/install
export OS=linux ARCH=amd64  # change this as you need
wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz
mkdir -p /usr/local
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

## Abaqus
There are several ways to install Abaqus
 - copy it from any other computer (e.g. Cent-OS)
 - install it via the container above
 - install it directly in Ubuntu/Fedora


If you choose the last option you need to do some manipulations
```bash
#cd (change directory) to the downloaded/DVD-install-files make shure you have write permissions

# "Linux.sh" checks if you have a compatible version, the script schould use DSY_OS_Release="CentOS"
tmp=$(find . -name "Linux.sh") #alternative you can use tmp=$(locate Linux.sh)
var1=$(echo $tmp | cut -f1 -d" ");
var2=$(echo $tmp | cut -f2 -d" ");
var3=$(echo $tmp | cut -f3 -d" ");
var4=$(echo $tmp | cut -f4 -d" ");
var5=$(echo $tmp | cut -f5 -d" ");
var6=$(echo $tmp | cut -f6 -d" ");
var7=$(echo $tmp | cut -f7 -d" ");
var8=$(echo $tmp | cut -f8 -d" ");
var9=$(echo $tmp | cut -f9 -d" ");
var0=$(echo $tmp | cut -f10 -d" ");
varB=$(echo $tmp | cut -f11 -d" ");
varC=$(echo $tmp | cut -f12 -d" ");
varD=$(echo $tmp | cut -f13 -d" ");
varE=$(echo $tmp | cut -f14 -d" ");

#might need sudo, depening on the owner
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var1
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var2
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var3
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var4
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var5
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var6
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var7
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var8
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var9
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $var0
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $varB
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $varC
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $varD
sed -ri "s/DSY_OS_Release=\`[-[:alnum:] _\|\/\']+\`/DSY_OS_Release=\"CentOS\"/" $varE


# sometimes you encouter problmes using the unzip of Abaqus, use unzip of the system
tmp2=$(find . -name "unzip")
file1=$(echo $tmp2 | cut -f1 -d" ");
file2=$(echo $tmp2 | cut -f2 -d" ");
file3=$(echo $tmp2 | cut -f3 -d" ");
file4=$(echo $tmp2 | cut -f4 -d" ");
file5=$(echo $tmp2 | cut -f5 -d" ");

mv $file1 ${file1}.backup
mv $file2 ${file2}.backup
mv $file3 ${file3}.backup
mv $file4 ${file4}.backup
mv $file5 ${file5}.backup

# which unzip should return /usr/bin/unzip 
ln -s $file1 /usr/bin/unzip
ln -s $file2 /usr/bin/unzip
ln -s $file3 /usr/bin/unzip
ln -s $file4 /usr/bin/unzip
ln -s $file5 /usr/bin/unzip


export LANG=en_US.UTF-8 #change to english, since english ist the most stable version
export DSY_Skip_CheckPrereq=1 #Added to avoid prerequisite check
export XLIB_SKIP_ARGB_VISUALS=1 #to avoid transparent-problems in Abaqus CAE
export run_mode=INTERACTIVE #if you run a problem you should see in the terminal if it is finished
```

more details can be found at http://coquake.eu/wp-content/uploads/2019/02/Abaqus18_on_Ubuntu18.04LTS.pdf

after that search for "StartTUI.sh" (alternativ you could use the grafical interface "StartGUI.sh") and start the script, and follow the requested steps.




## Running the container

Assuming Abaqus is installed at `/opt/abaqus`:

To run Abaqus CAE without hardware-accelerated graphics:

```bash
singularity exec --bind /opt/abaqus ~/imgs/sing/abaqus-centos-7.img /opt/abaqus/CAE/2019/linux_a64/code/bin/ABQLauncher cae -mesa
```

To run Abaqus CAE with hardware-accelerated graphics: (remove the `-mesa`, not working on my pc)

```bash
singularity exec --bind /opt/abaqus ~/imgs/sing/abaqus-centos-7.img /opt/abaqus/CAE/2019/linux_a64/code/bin/ABQLauncher cae
```

## Remove/Uninistall

### Remove/Uninstall Abaqus
Generally there is no need to remove old Abaqus-Versions, except you want to save space.

If you copied Abaqus, remove it. If you installed it you can uninstall it using "Uninstall.sh"

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
Generally there is no need to remove old containers, except you want to save space (only 157 MB).
```bash
rm ~/imgs/sing/abaqus-centos-7.img
```
